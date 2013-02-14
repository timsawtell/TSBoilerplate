//
//  TwitterUserBuilder.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import <Foundation/Foundation.h>
#import "TwitterEntity.h"

@interface TwitterEntityBuilder : NSObject

+ (TwitterEntity *)twitterEntityFromJSON:(id)json;
+ (void)updateTwitterEntity:(TwitterEntity *)twitterEntity fromJSON:(id)json;
+ (NSMutableDictionary *)dictionaryFromTwitterEntity:(TwitterEntity *)twitterEntity;

@end
