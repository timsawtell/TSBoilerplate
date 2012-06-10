//
//  AsynchronousCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 8/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousCommand.h"

@implementation AsynchronousCommand
@synthesize commandCompletionBlock, multiThreaded, finished, executing;

- (void) start
{
    [self setFinished: NO];
    [self main];
}

- (void) main
{
    //set the NSOperation's completionBlock which occurs at the end of main
    self.completionBlock = ^{
        if (self.commandCompletionBlock != NULL) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.commandCompletionBlock(self.error);
            });
        }
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
    for (Command *cmd in self.subCommands) {
        [cmd cancel];
    }
    //in subclasses add your logic to cancel the processing in execute.
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
    [self setFinished: YES];
}

@end
