//  _Group.m
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.


#import "_Group.h"

NSString * const kModelPropertyGroupGroupName = @"groupName";
NSString * const kModelPropertyGroupMembers = @"members";
NSString * const kModelDictionaryGroupMembers = @"Group.members";
#import "Member.h"

@interface _Group()
@property (nonatomic, strong, readwrite) NSSet *members;

@end

/** \ingroup DataModel */

@implementation _Group
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyGroupGroupName];
    [set addObject:kModelDictionaryGroupMembers];
    
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
        self.groupName = [aDecoder decodeObjectForKey: kModelPropertyGroupGroupName];
        self.members = [aDecoder decodeObjectForKey: kModelPropertyGroupMembers];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.groupName forKey: kModelPropertyGroupGroupName];
    [aCoder encodeObject: self.members forKey: kModelPropertyGroupMembers];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.groupName = [dictionary objectForKey:kModelPropertyGroupGroupName];
        for(id objectRepresentationForDict in [dictionary objectForKey:kModelDictionaryGroupMembers])
        {
            Member *membersObj = [[Member alloc] initWithDictionaryRepresentation:objectRepresentationForDict];
            [self addMembersObject:membersObj];
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.groupName forKey:kModelPropertyGroupGroupName];
    if([self.members count] > 0)
    {
        NSMutableSet *membersRepresentationsForDictionary = [NSMutableSet setWithCapacity:[self.members count]];
        for(Member *obj in self.members)
        {
            [membersRepresentationsForDictionary addObject:[obj dictionaryRepresentation]];
        }
        [dict setObjectIfNotNil:membersRepresentationsForDictionary forKey:kModelDictionaryGroupMembers];
    }
    return dict;
}

#pragma mark Direct access

- (NSMutableSet*)membersSet {
    return (NSMutableSet*)[self mutableSetValueForKey:kModelPropertyGroupMembers];;
}

- (void)addMembersObject:(Member*)value_ settingInverse: (BOOL) setInverse
{
    if(self.members == nil)
    {
        self.members = [NSMutableSet set];
    }

    [(NSMutableSet *)self.members addObject:value_];
    if (setInverse == YES) {
        [value_ setGroup: (Group*)self settingInverse: NO];
    }
}

- (void)addMembersObject:(Member*)value_
{
    [self addMembersObject:(Member*)value_ settingInverse: YES];
}

- (void)removeAllMembers{
    self.members = [NSMutableSet set];
}

- (void)removeMembersObject:(Member*)value_ settingInverse: (BOOL) setInverse
{
    if (setInverse == YES) {
        [value_ setGroup: nil settingInverse: NO];
    }
    if (value_ != nil) {
        [(NSMutableSet *)self.members removeObject:value_];
    }
}

- (void)removeMembersObject:(Member*)value_
{
    [self removeMembersObject:(Member*)value_ settingInverse: YES];
}


//scalar setter and getter support

#pragma mark Synthesizes

@synthesize groupName;
@synthesize members;

@end
