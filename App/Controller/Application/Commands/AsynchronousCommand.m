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
@end

@implementation AsynchronousCommand
@synthesize _subCommands, commandCompletionBlock, multiThreaded, finished, executing, parentCommand;

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
            });
        }
        strongSelf.completionBlock = nil; // needed to do this otherwise retain cycle
    };
    //subclass should override execute to perform the logic of the command
    [self execute];
    
    //subclass MUST call [self finish] at the appropriate time, generally in the commandCompletionBlock
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
    
    if (executing) {
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
    finished = isFinished;
    [self didChangeValueForKey: @"isFinished"];
}

- (void) setExecuting:(BOOL) isExecuting
{
    [self willChangeValueForKey: @"isExecuting"];
    executing = isExecuting;
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
            self.parentCommand._subCommands = [NSMutableArray array]; // clear the reference to sub commands, allows dealloc
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

- (NSArray *)subCommands
{
    return _subCommands;
}

@end