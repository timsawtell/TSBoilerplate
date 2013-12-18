/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "AsynchronousCommand.h"

@interface AsynchronousCommand()
@property (nonatomic, strong) NSMutableArray *_subCommands;
- (void)beginBackgroundUpdateTask;
- (void)endBackgroundUpdateTask;
@end

@implementation AsynchronousCommand

@synthesize _subCommands;

- (id)init
{
    if (self = [super init]){
        _subCommands = [NSMutableArray array];
    }
    return self;
}

- (void) start
{
    [self setFinished: NO];
    [self main];
}

- (void) main
{
    //set the NSOperation's completionBlock which occurs at the end of main
    __weak AsynchronousCommand *weakSelf = self;
    self.completionBlock = ^{
        __strong AsynchronousCommand *strongSelf = weakSelf;
        
        if (NULL != strongSelf.commandCompletionBlock && !strongSelf.isCancelled) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                strongSelf.commandCompletionBlock(strongSelf.error);
                [strongSelf endBackgroundUpdateTask];
                if (strongSelf.saveModel) {
                    [[Model sharedModel] save];
                }
            });
        }
        if (strongSelf.isBackgroundExecutable) {
            [strongSelf endBackgroundUpdateTask];
        }
        strongSelf.completionBlock = nil; // needed to do this otherwise retain cycle
    };
    //subclass should override execute to perform the logic of the command

    if (self.isBackgroundExecutable) {
        self.backgroundUpdateTaskId = [[NSDate date] timeIntervalSince1970];
        [self beginBackgroundUpdateTask];
    }
    [self execute];
    
    //subclass MUST call [self finish] at the appropriate time, generally in the commandCompletionBlock
}

- (void)beginBackgroundUpdateTask
{
    self.backgroundUpdateTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTaskId];
    self.backgroundUpdateTaskId = UIBackgroundTaskInvalid;
}

- (BOOL)isMultiThreaded
{
    return YES;
}

- (void)cancel
{
    for (Command *cmd in [self subCommands]) {
        [cmd cancel];
    }
    self._subCommands = [NSMutableArray array]; // release the subcommands
    
    if (self.executing) {
        [self setFinished:YES];
        [self finish];
    } else {
        [super cancel];
    }
}

- (void) setFinished:(BOOL) isFinished
{
    [self setExecuting: !isFinished];
    [self willChangeValueForKey: @"isFinished"];
    _finished = isFinished;
    [self didChangeValueForKey: @"isFinished"];
}

- (void) setExecuting:(BOOL) isExecuting
{
    [self willChangeValueForKey: @"isExecuting"];
    _executing = isExecuting;
    [self didChangeValueForKey: @"isExecuting"];
}

- (void) finish
{
    // if I am a subcommand (I am if I have a parentCommand) then check if my parent has no other sub commands running. If so, then finish the parent as well
    if (nil != self.parentCommand) {
        BOOL runningSubCommands = NO;
        for (AsynchronousCommand *cmd in self.parentCommand.subCommands) {
            if ([cmd isEqual:self]) continue; // don't look at self in this loop
            if (!cmd.isFinished) {
                runningSubCommands = YES;
                break;
            }
        }
        if (!runningSubCommands) {
            [self setFinished: YES]; // have to finish self before the parent, makes sence
            [self.parentCommand finish];
            [self.parentCommand clearSubCommands]; // clear the reference to sub commands, allows dealloc
            return;
        }
    }
    [self setFinished: YES];
}

- (void)addSubCommand:(AsynchronousCommand *)command
{
    command.parentCommand = self;
    [_subCommands addObject:command];
}

- (void)removeSubCommand:(Command *)command
{
    if ([_subCommands containsObject:command]) {
        [_subCommands removeObject:command];
    }
}

- (void)clearSubCommands
{
    _subCommands = [NSMutableArray array];
}

- (NSArray *)subCommands
{
    return _subCommands;
}

@end