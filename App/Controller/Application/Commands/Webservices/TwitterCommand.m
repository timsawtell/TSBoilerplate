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

#import "TwitterCommand.h"
#import "TwitterEngine.h"
#import "MemberDisplayCommand.h"
#import "Tweet.h"
#import "TwitterEntity.h"
#import "TweetBuilder.h"
#import "TwitterEntityBuilder.h"

@implementation TwitterCommand

@synthesize screenName, includeEntities, includeRetweets, tweetCount;

- (void)execute
{
    
    /* we make a new completion block and add add in things that a programmer wouldn't want to do in the running code.
     i.e. I think it's rude to ask a programmer to do command level functions like [NSCommand finish] in their day 
     to day code, so when they type out the completionBlock, it's just business logic. In here though, we need to also 
     do lower level things. */
    __weak TwitterCommand *weakSelf = self;
    _serviceCompletionBlock completionBlock = ^(id results, NSError *error) {
        __strong TwitterCommand *strongSelf = weakSelf;
        if(strongSelf.isCancelled) {
            [strongSelf finish];
            return;
        }
        
        if (nil != error) {
            self.error = error;
            [self finish];
            return;
        }
        
        for (id tweetInstanceJSON in results) {
            id user = [tweetInstanceJSON objectForKey:kTwitterUser];
            if (user != nil) {
                TwitterEntity *tweetsUser = [TwitterEntityBuilder twitterEntityFromJSON:user];
                
                Tweet *tweet = [TweetBuilder tweetFromJSON:tweetInstanceJSON];
                if (nil != tweet) {
                    tweet.twitterEntity = tweetsUser;
                }
            }
        }
        
        if (self.saveModel) {
            [[Model sharedModel] save];
        }
        
        [strongSelf finish];
    };
        
    TwitterEngine *twitterEngine = [TwitterEngine new];
    [twitterEngine getPublicTimelineForScreenName:self.screenName 
                                 includedEntities:self.includeEntities 
                                  includeRetweets:self.includeRetweets 
                                       tweetCount:self.tweetCount 
                                     onCompletion:completionBlock];
}

@end
