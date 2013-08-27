//
//  TwitterUserBuilder.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import "TwitterEntityBuilder.h"

@implementation TwitterEntityBuilder

+ (TwitterEntity *)twitterEntityFromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    TwitterEntity *twitterEntity = [TwitterEntity MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    [TwitterEntityBuilder updateTwitterEntity:twitterEntity fromJSON:json];
    return twitterEntity;
}

+ (void)updateTwitterEntity:(TwitterEntity *)twitterEntity fromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *jsonDict = (NSDictionary *)json;
    ASSIGN_NOT_NIL(twitterEntity.screen_name, [jsonDict valueForKey:kTwitterScreenName]);
    ASSIGN_NOT_NIL(twitterEntity.name, [jsonDict valueForKey:kTwitterName]);
}

+ (NSMutableDictionary *)dictionaryFromTwitterEntity:(TwitterEntity *)twitterEntity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:twitterEntity.screen_name forKey:kTwitterScreenName];
    [dict setValue:twitterEntity.name forKey:kTwitterName];
    return dict;
}

@end
