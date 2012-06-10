//
//  TwitterCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousCommand.h"

typedef void(^twitterCommandCompletionBlock)(NSArray *tweets, NSError *error);

@interface TwitterCommand : AsynchronousCommand

@property (nonatomic, copy) NSString *screenName;
@property (nonatomic, assign) BOOL includeRetweets;
@property (nonatomic, assign) BOOL includeEntities;
@property (nonatomic, assign) NSUInteger tweetCount;
@property (nonatomic, copy) twitterCommandCompletionBlock twitterCommandCompletionBlock;

@end
