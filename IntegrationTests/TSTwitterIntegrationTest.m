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

#import "TSTwitterIntegrationTest.h"
#import "TwitterCommand.h"
#import "TSCommandRunner.h"
#import "Model.h"

#define kTwitterScreenName @"ID_AA_Carmack" // coolest guy in the world
#define kTweetCount 1

@implementation TSTwitterIntegrationTest

- (void)testCanGetTweets
{
//    TwitterCommand *twitterCommand = [TwitterCommand new];
//    twitterCommand.screenName = kTwitterScreenName;
//    twitterCommand.includeRetweets = YES;
//    twitterCommand.includeEntities = NO;
//    twitterCommand.tweetCount = kTweetCount;
//    twitterCommand.commandCompletionBlock = ^ (NSError *error) {
//        XCTAssertNil(error, @"The twitter error was: %@", error.localizedDescription);
//        XCTAssertTrue([[Model sharedModel].tweets count] > 0, @"Oh no, there are no tweets");
//        dispatch_semaphore_signal(self.semaphore);
//    };
//    
//    [[TSCommandRunner sharedCommandRunner] executeCommand:twitterCommand];
//    
//    while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW)) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
}

@end