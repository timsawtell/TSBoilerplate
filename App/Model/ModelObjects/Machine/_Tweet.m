//  _Tweet.m
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.


#import "_Tweet.h"

NSString * const kModelPropertyTweetText = @"text";
NSString * const kModelPropertyTweetTwitterEntity = @"twitterEntity";
NSString * const kModelDictionaryTweetTwitterEntity = @"Tweet.twitterEntity";
#import "TwitterEntity.h"

@interface _Tweet()
@end

/** \ingroup DataModel */

@implementation _Tweet
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyTweetText];
    [set addObject:kModelDictionaryTweetTwitterEntity];
    
    return [NSSet setWithSet:set];
}

- (id)init
{
    if((self = [super init]))
    {
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    if ([[super class] instancesRespondToSelector: @selector(initWithCoder:)]) {
        self = [super initWithCoder: aDecoder];
    } else {
        self = [super init];
    }
    if (self) {
        self.text = [aDecoder decodeObjectForKey: kModelPropertyTweetText];
        self.twitterEntity = [aDecoder decodeObjectForKey: kModelPropertyTweetTwitterEntity];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.text forKey: kModelPropertyTweetText];
    [aCoder encodeObject: self.twitterEntity forKey: kModelPropertyTweetTwitterEntity];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.text = [dictionary objectForKey:kModelPropertyTweetText];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    __weak NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.text forKey:kModelPropertyTweetText];
    return dict;
}

#pragma mark Direct access

- (void) setTwitterEntity: (TwitterEntity*) twitterEntity_ settingInverse: (BOOL) setInverse
{
    if (twitterEntity_ == nil && setInverse == YES) {
        [_twitterEntity removeTweetsObject: (Tweet*)self settingInverse: NO];
    }
    _twitterEntity = twitterEntity_;
    if (setInverse == YES) {
        [_twitterEntity addTweetsObject: (Tweet*)self settingInverse: NO];
    }}

- (void) setTwitterEntity: (TwitterEntity*) twitterEntity_
{
    [self setTwitterEntity: twitterEntity_ settingInverse: YES];
}


//scalar setter and getter support

#pragma mark Synthesizes

@synthesize text;

@end
