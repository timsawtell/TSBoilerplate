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

#import "TSCommandRunner.h"

@interface TSCommandRunner()
+ (TSCommandRunner *)sharedCommandRunner;
@end

@implementation TSCommandRunner

+ (TSCommandRunner *)sharedCommandRunner
{
    __strong static TSCommandRunner *commandRunner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            commandRunner = [TSCommandRunner new];
    });
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
        if (![[[TSCommandRunner sharedOperationQueue] operations] containsObject:asynchronousCommand]) {
            [[TSCommandRunner sharedOperationQueue] addOperation:asynchronousCommand]; // run on any other thread
        }
    } else {
        if (![[[NSOperationQueue mainQueue] operations] containsObject:asynchronousCommand]) {
            [[NSOperationQueue mainQueue] addOperation: asynchronousCommand]; // run on thread 0
        }
    }
}

- (void)executeSynchronousCommand:(Command *)command
{
    [command execute];
}

@end
