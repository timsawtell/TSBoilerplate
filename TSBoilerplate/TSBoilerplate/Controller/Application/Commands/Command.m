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

#import "Command.h"

@implementation Command

@synthesize runInBackground, subCommands, error, saveModel, commandCompletionBlock = _commandCompletionBlock, completeOnMainThread;

- (id)init
{
    self = [super init];
    if( self ) {
        runInBackground = YES;
        completeOnMainThread = YES;
    }
    return self;
}

- (void)main
{
    self.error = [self execute];
}

- (NSError *)execute
{
    return nil;
}

- (void)setCommandCompletionBlock:(commandCompletionBlock)newCompletionBlock
{
    if( newCompletionBlock == _commandCompletionBlock ) return;
    
    _commandCompletionBlock = newCompletionBlock;
    
    //set the NSOperation's completionBlock which occurs at the end of main
    self.completionBlock = ^{
        if (self.commandCompletionBlock != NULL) {
            dispatch_queue_t queue = self.completeOnMainThread ? dispatch_get_main_queue() : dispatch_get_current_queue();
            dispatch_sync(queue, ^{
                self.commandCompletionBlock(self.error);
            });
        }
    };
}

@end
