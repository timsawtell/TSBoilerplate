//
//  TSCommandRunner.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TSCommandRunner.h"

@interface TSCommandRunner()
+ (TSCommandRunner *)sharedCommandRunner;
@end

@implementation TSCommandRunner

+ (TSCommandRunner *)sharedCommandRunner
{
    static TSCommandRunner *commandRunner;
    @synchronized(self) {
        if (commandRunner == nil) {
            commandRunner = [TSCommandRunner new];
        }
    }
    return commandRunner;
}

+ (NSOperationQueue*) sharedOperationQueue
{
    __strong static NSOperationQueue *sharedOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOperationQueue = [NSOperationQueue new];
    });
    return sharedOperationQueue;
}

- (void)executeAsynchronousCommand:(AsynchronousCommand *)asynchronousCommand
{
    assert([asynchronousCommand isKindOfClass:[AsynchronousCommand class]]);
    
    if ([asynchronousCommand isMultiThreaded]) {
        [[TSCommandRunner sharedOperationQueue] addOperation:asynchronousCommand]; // run on any other thread
    } else {
        [[NSOperationQueue mainQueue] addOperation: asynchronousCommand]; // run on thread 0
    }
}


- (void)executeSynchronousCommand:(Command *)command
{
    [command execute];
}

@end
