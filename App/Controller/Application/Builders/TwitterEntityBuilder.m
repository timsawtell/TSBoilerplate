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
    ASSIGN_NOT_NIL(twitterEntity.screen_name, [jsonDict valueForKey:TwitterEntityAttributes.screen_name]);
    ASSIGN_NOT_NIL(twitterEntity.name, [jsonDict valueForKey:TwitterEntityAttributes.name]);
}

+ (NSMutableDictionary *)dictionaryFromTwitterEntity:(TwitterEntity *)twitterEntity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:twitterEntity.screen_name forKey:TwitterEntityAttributes.screen_name];
    [dict setValue:twitterEntity.name forKey:TwitterEntityAttributes.name];
    return dict;
}

@end
