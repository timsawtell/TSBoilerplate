/*
 Copyright (c) 2013 Tim Sawtell
 
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
#import "TwitterEntity.h"
#import "TweetBuilder.h"
#import "TwitterEntityBuilder.h"

@implementation TwitterCommand

@synthesize screenName, includeEntities, includeRetweets, tweetCount;

- (void)execute
{
    __weak typeof(self) weakSelf = self;
    
    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(strongSelf.isCancelled) {
            [strongSelf finish];
            return;
        }
        
        if (![resultObject isKindOfClass:[NSArray class]]) {
            strongSelf.error = [NSError errorWithDomain:NSURLErrorDomain withCode:NSURLErrorCannotParseResponse withText:kUnableToParseMessageText];
            [strongSelf finish];
            return;
        }
        NSArray *resultsArray = (NSArray *)resultObject;
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (id tweetInstanceJSON in resultsArray) {
            id user = [tweetInstanceJSON objectForKey:kTwitterUser];
            if (user != nil) {
                TwitterEntity *tweetsUser = [TwitterEntityBuilder twitterEntityFromJSON:user];
                
                Tweet *tweet = [TweetBuilder tweetFromJSON:tweetInstanceJSON];
                if (nil != tweet) {
                    tweet.twitterEntity = tweetsUser;
                    [tmpArray addObject:tweet];
                }
            }
        }
        [Model sharedModel].tweets = tmpArray;
        
        if (strongSelf.saveModel) {
            [[Model sharedModel] save];
        }
        
        [strongSelf finish];
    };
    
    /*
    TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.error = error;
        [strongSelf finish];
        return;
    };
    
    
    NSDictionary *params = @{kTwitterScreenName: screenName,
                             kIncludeEntities: [NSNumber numberWithBool:includeEntities],
                             kIncludeReTweets: [NSNumber numberWithBool:includeRetweets],
                             kTweetCount: [NSNumber numberWithInteger: tweetCount]};
    
    [[TSNetworking sharedSession] setBaseURLString:kTwitterBaseURL];
    
    [[TSNetworking sharedSession] performDataTaskWithRelativePath:@"1/statuses/user_timeline.json"
                                                       withMethod:HTTP_METHOD_GET
                                                   withParameters:params
                                             withAddtionalHeaders:@{@"Content-Type":@"application/json", @"Accept":@"application/json"}
                                                      withSuccess:successBlock
                                                        withError:errorBlock];
    */
    
    // since twitter changed their security model, I'm just using some hard coded results for this example
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fake_results" ofType:@"json"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSError *error;
        NSDictionary *timelineData =
        [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                        options:NSJSONReadingAllowFragments error:&error];
        successBlock(timelineData, nil, nil);
    }
    
    
}

@end
