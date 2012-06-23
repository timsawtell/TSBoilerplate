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
{
    BOOL _finished;
    BOOL _executing;
}
@end

@implementation AsynchronousCommand

- (BOOL)runInBackground
{
    return YES;
}

- (void) start
{
    [self setFinished: NO];

    //subclass should override execute to perform the logic of the command
    _executing = YES;
    [self prepare];

    // If we are still executing, make sure that any observers have been notified
    if( self.executing ) {
        [self willChangeValueForKey: @"isExecuting"];
        [self didChangeValueForKey: @"isExecuting"];
    }
    
    //subclass MUST call [self finish] at the appropriate time, generally in the commandCompletionBlock
}

- (void)cancel
{
    for (Command *cmd in self.subCommands) {
        [cmd cancel];
    }
    //in subclasses add your logic to cancel the processing in execute.
    [super cancel];
}

- (void)prepare
{
    NSAssert(NO, @"don't call super on prepare");
    [self markAsFinished];
}

- (void)markAsFinished
{
    [self setFinished:YES];
}

- (BOOL)isFinished
{
    BOOL returnValue;
    @synchronized(self) {
        returnValue = _finished;
    }
    return returnValue;
}

- (void) setFinished:(BOOL)isFinished
{
    [self setExecuting: !isFinished];
    [self willChangeValueForKey: @"isFinished"];
    @synchronized(self) {
        _finished = isFinished;
    }
    [self didChangeValueForKey: @"isFinished"];
}

- (BOOL)isExecuting
{
    BOOL returnValue;
    @synchronized(self) {
        returnValue = _executing;
    }
    return returnValue;
}

- (void) setExecuting:(BOOL) isExecuting
{
    [self willChangeValueForKey: @"isExecuting"];
    @synchronized(self) {
        _executing = isExecuting;
    }
    [self didChangeValueForKey: @"isExecuting"];
}

@end
