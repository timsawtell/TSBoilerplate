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

#import <Foundation/Foundation.h>

typedef void(^commandCompletionBlock)(NSError *error);

@interface Command : NSOperation

@property (nonatomic, copy) commandCompletionBlock commandCompletionBlock;
@property (nonatomic, assign) BOOL completeOnMainThread;
@property (nonatomic, readonly) BOOL runInBackground;
@property (nonatomic, strong) NSMutableArray *subCommands;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL saveModel; //flag to save the model, intended to be used at the end of the execute method. Sublasses set this.

- (void)setValue:(id)value forKey:(NSString *)key;
- (NSError *)execute;

@end
