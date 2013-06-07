//  _TwitterEntity.m
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterEntity.h instead.


#import "_TwitterEntity.h"

NSString * const kModelPropertyTwitterEntityName = @"name";
NSString * const kModelPropertyTwitterEntityScreen_name = @"screen_name";
NSString * const kModelPropertyTwitterEntityTweets = @"tweets";
NSString * const kModelDictionaryTwitterEntityTweets = @"TwitterEntity.tweets";
#import "Tweet.h"

@interface _TwitterEntity()
@property (nonatomic, strong, readwrite) NSSet *tweets;

@end

/** \ingroup DataModel */

@implementation _TwitterEntity
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyTwitterEntityName];
	  [set addObject:kModelPropertyTwitterEntityScreen_name];
    [set addObject:kModelDictionaryTwitterEntityTweets];
    
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
        self.name = [aDecoder decodeObjectForKey: kModelPropertyTwitterEntityName];
        self.screen_name = [aDecoder decodeObjectForKey: kModelPropertyTwitterEntityScreen_name];
        self.tweets = [aDecoder decodeObjectForKey: kModelPropertyTwitterEntityTweets];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.name forKey: kModelPropertyTwitterEntityName];
    [aCoder encodeObject: self.screen_name forKey: kModelPropertyTwitterEntityScreen_name];
    [aCoder encodeObject: self.tweets forKey: kModelPropertyTwitterEntityTweets];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.name = [dictionary objectForKey:kModelPropertyTwitterEntityName];
        self.screen_name = [dictionary objectForKey:kModelPropertyTwitterEntityScreen_name];
        for(id objectRepresentationForDict in [dictionary objectForKey:kModelDictionaryTwitterEntityTweets])
        {
            Tweet *tweetsObj = [[Tweet alloc] initWithDictionaryRepresentation:objectRepresentationForDict];
            [self addTweetsObject:tweetsObj];
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.name forKey:kModelPropertyTwitterEntityName];
    [dict setObjectIfNotNil:self.screen_name forKey:kModelPropertyTwitterEntityScreen_name];
    if([self.tweets count] > 0)
    {
        NSMutableSet *tweetsRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.tweets count]];
        for(Tweet *obj in self.tweets)
        {
            [tweetsRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
        }
        [dict setObjectIfNotNil:tweetsRepresentationsForDictionary forKey:kModelDictionaryTwitterEntityTweets];
    }
    return dict;
}

#pragma mark Direct access

- (NSMutableSet*)tweetsSet {
    return (NSMutableSet*)[self mutableSetValueForKey:kModelPropertyTwitterEntityTweets];;
}

- (void)addTweetsObject:(Tweet*)value_ settingInverse: (BOOL) setInverse
{
    if(self.tweets == nil)
    {
        self.tweets = [NSMutableSet set];
    }

    [(NSMutableSet *)self.tweets addObject:value_];
    if (setInverse == YES) {
        [value_ setTwitterEntity: (TwitterEntity*)self settingInverse: NO];
    }
}

- (void)addTweetsObject:(Tweet*)value_
{
    [self addTweetsObject:(Tweet*)value_ settingInverse: YES];
}

- (void)removeAllTweets{
    self.tweets = [NSMutableSet set];
}

- (void)removeTweetsObject:(Tweet*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setTwitterEntity: nil settingInverse: NO];
    }
    if (value_ != nil) {
        [(NSMutableSet *)self.tweets removeObject:value_];
    }
}

- (void)removeTweetsObject:(Tweet*)value_
{
    [self removeTweetsObject:(Tweet*)value_ settingInverse: YES];
}


//scalar setter and getter support

#pragma mark Synthesizes

@synthesize name;
@synthesize screen_name;
@synthesize tweets;

@end
