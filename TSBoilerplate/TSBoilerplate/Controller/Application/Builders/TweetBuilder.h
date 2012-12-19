//
//  TweetBuilder.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface TweetBuilder : NSObject

+ (Tweet *)tweetFromJSON:(id)json;
+ (void)updateTweet:(Tweet *)tweet fromJSON:(id)json;
+ (NSMutableDictionary *)dictionaryFromTweet:(Tweet *)tweet;

@end
