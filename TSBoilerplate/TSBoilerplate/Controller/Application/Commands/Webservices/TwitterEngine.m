//
//  TwitterEngine.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
                          onCompletion:(twitterCommandCompletionBlock) completion
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
                 entity.screen_name = [user valueForKey:kTwitterScreenName];
                 entity.name = [user valueForKey:kTwitterName] != nil ? [user valueForKey:kTwitterName] : nil;
                 
                 id text = [dictionary objectForKey:kTweetText];
                 if (text != nil) {
                     Tweet *tweet = [Tweet new];
                     tweet.user = entity;
                     tweet.text = text;
                     [tmpArray addObject:tweet];
                 }
             }
         }
        completion(tmpArray, nil);
         
     }onError:^(NSError* error) {
         completion(nil, error);
     }];
    
    [self enqueueOperation:op];
}

@end
