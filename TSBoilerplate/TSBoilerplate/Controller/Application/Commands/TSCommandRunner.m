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

/*
 -- SC: There should not be a difference in running the command
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
    [command start];
}
*/

- (void)executeCommand:(Command *)command
{
    if( [command isKindOfClass:[AsynchronousCommand class]] )
    {
        // Always start an async command on the main queue
        // http://www.dribin.org/dave/blog/archives/2009/09/13/snowy_concurrent_operations/
        [self executeCommand:command
                     onQueue:[NSOperationQueue mainQueue]];
    }
    else
    {
        // Decide which queue the command should be running on
        // Note: Technically if it is to run on the mainQueue, we could have just called [NSOperation start];
        [self executeCommand:command 
                     onQueue:(command.runInBackground ? [[self class] sharedOperationQueue] : [NSOperationQueue mainQueue])];
    }
}

- (void)executeCommand:(Command *)command onQueue:(NSOperationQueue *)queue
{
    assert(nil != queue);
    if( nil == queue )
    {
        [NSException raise:NSInvalidArgumentException format:@"queue"];
        return;
    }
    if( !command.runInBackground && queue != [NSOperationQueue mainQueue] )
    {
        // Warn that a background command is running on the main queue
        DLog(@"a background command is running on the main thread");
    }
    [queue addOperation:command];
}

@end
