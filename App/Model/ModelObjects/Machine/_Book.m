//  _Book.m
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.


#import "_Book.h"

NSString * const kModelPropertyBookAuthor = @"author";
NSString * const kModelPropertyBookBlurb = @"blurb";
NSString * const kModelPropertyBookPrice = @"price";
NSString * const kModelPropertyBookTitle = @"title";

@interface _Book()
@end

/** \ingroup DataModel */

@implementation _Book
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyBookAuthor];
	  [set addObject:kModelPropertyBookBlurb];
	  [set addObject:kModelPropertyBookPrice];
	  [set addObject:kModelPropertyBookTitle];
    
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
        self.author = [aDecoder decodeObjectForKey: kModelPropertyBookAuthor];
        self.blurb = [aDecoder decodeObjectForKey: kModelPropertyBookBlurb];
        self.price = [aDecoder decodeObjectForKey: kModelPropertyBookPrice];
        self.title = [aDecoder decodeObjectForKey: kModelPropertyBookTitle];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.author forKey: kModelPropertyBookAuthor];
    [aCoder encodeObject: self.blurb forKey: kModelPropertyBookBlurb];
    [aCoder encodeObject: self.price forKey: kModelPropertyBookPrice];
    [aCoder encodeObject: self.title forKey: kModelPropertyBookTitle];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.author = [dictionary objectForKey:kModelPropertyBookAuthor];
        self.blurb = [dictionary objectForKey:kModelPropertyBookBlurb];
        self.price = [dictionary objectForKey:kModelPropertyBookPrice];
        self.title = [dictionary objectForKey:kModelPropertyBookTitle];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.author forKey:kModelPropertyBookAuthor];
    [dict setObjectIfNotNil:self.blurb forKey:kModelPropertyBookBlurb];
    [dict setObjectIfNotNil:self.price forKey:kModelPropertyBookPrice];
    [dict setObjectIfNotNil:self.title forKey:kModelPropertyBookTitle];
    return dict;
}

#pragma mark Direct access


//scalar setter and getter support

#pragma mark Synthesizes

@synthesize author;
@synthesize blurb;
@synthesize price;
@synthesize title;

@end
