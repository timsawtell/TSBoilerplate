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

#import "TwitterEngine.h"
#import "TwitterCommand.h"
#import "Tweet.h"
#import "TwitterEntity.h"

#define kTwitterTimelineBaseURL @"https://api.twitter.com/1/statuses/user_timeline.json"
#define kIncludeEntities @"include_entities"
#define kIncludeReTweets @"include_rts"
#define kTweetCount @"count"
#define kTwitterScreenName @"screen_name"
#define kTwitterUser @"user"
#define kTwitterName @"name"
#define kTweetText @"text"

@implementation TwitterEngine

- (void)getPublicTimelineForScreenName:(NSString *)screenName
                      includedEntities:(BOOL)includeEntities
                       includeRetweets:(BOOL)includeRetweets
                            tweetCount:(NSUInteger)tweetCount
                          onCompletion:(twitterEngineCompletionBlock)complete
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            screenName, kTwitterScreenName,
                            [NSNumber numberWithBool:includeEntities], kIncludeEntities,
                            [NSNumber numberWithBool:includeRetweets], kIncludeReTweets, 
                            [NSNumber numberWithInteger: tweetCount], kTweetCount, nil];
    [self registerOperationSubclass:[MKNetworkOperation class]];
    
    MKNetworkOperation *op = [self operationWithURLString:kTwitterTimelineBaseURL 
                                                   params:params
                                               httpMethod:@"GET"];
    
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         // loop through the JSON to build up a TwitterEntity object for each Tweet object. Add the Tweet to the array in the completion block
         id jsonResponse = [completedOperation responseJSON];
         NSMutableArray *tmpArray = [NSMutableArray array];
         for (NSDictionary *dictionary in jsonResponse) {
             id user = [dictionary objectForKey:kTwitterUser];
             if (user != nil) {
                 TwitterEntity *entity = [TwitterEntity new];
                 entity.screen_name = [user objectForKey:kTwitterScreenName] != nil ? [user valueForKey:kTwitterScreenName] : nil;
                 entity.name = [user objectForKey:kTwitterName] != nil ? [user valueForKey:kTwitterName] : nil;
                 
                 id text = [dictionary objectForKey:kTweetText];
                 if (text != nil) {
                     Tweet *tweet = [Tweet new];
                     tweet.user = entity;
                     tweet.text = text;
                     [tmpArray addObject:tweet];
                 }
             }
         }
         complete(tmpArray, nil);
     }onError:^(NSError* error) {
         complete(nil, error);
     }];
    
    [self enqueueOperation:op];
}

@end
