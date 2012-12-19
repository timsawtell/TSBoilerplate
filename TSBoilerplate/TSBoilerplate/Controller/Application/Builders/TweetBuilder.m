//
//  TweetBuilder.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import "TweetBuilder.h"

@implementation TweetBuilder

+ (Tweet *)tweetFromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    Tweet *tweet = [Tweet new];
    [TweetBuilder updateTweet:tweet fromJSON:json];
    return tweet;
}

+ (void)updateTweet:(Tweet *)tweet fromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *jsonDict = (NSDictionary *)json;
    ASSIGN_NOT_NIL(tweet.text, [jsonDict valueForKey:kTweetText]);
}

+ (NSMutableDictionary *)dictionaryFromTweet:(Tweet *)tweet
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:tweet.text forKey:kTweetText];
    return dict;
}

@end
