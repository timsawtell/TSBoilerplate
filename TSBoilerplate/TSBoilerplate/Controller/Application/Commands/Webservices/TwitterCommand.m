//
//  TwitterCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterCommand.h"
#import "TwitterEngine.h"

@implementation TwitterCommand

@synthesize screenName, includeEntities, includeRetweets, tweetCount, twitterCommandCompletionBlock;

- (void)execute
{
    TwitterEngine *twitterEngine = [TwitterEngine new];
    [twitterEngine getPublicTimelineForScreenName:self.screenName 
                                 includedEntities:self.includeEntities 
                                  includeRetweets:self.includeRetweets 
                                       tweetCount:self.tweetCount 
                                     onCompletion:self.twitterCommandCompletionBlock];
}

@end
