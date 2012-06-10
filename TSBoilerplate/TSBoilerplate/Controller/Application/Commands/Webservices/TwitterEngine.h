//
//  TwitterEngine.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "TwitterCommand.h"

@interface TwitterEngine : MKNetworkEngine

- (void)getPublicTimelineForScreenName:(NSString *)screenName
                      includedEntities:(BOOL)includeEntities
                       includeRetweets:(BOOL)includeRetweets
                            tweetCount:(NSUInteger)tweetCount
                          onCompletion:(twitterCommandCompletionBlock) completion;

@end
