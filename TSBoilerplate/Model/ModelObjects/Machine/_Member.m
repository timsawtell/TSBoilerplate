//
//  _Member.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.h instead.
//


#import "_Member.h"

NSString * const kModelPropertyMemberMemberId = @"memberId";
NSString * const kModelPropertyMemberName = @"name";
NSString * const kModelPropertyMemberGroup = @"group";
NSString * const kModelDictionaryMemberGroup = @"Member.group";
#import "Group.h"

@interface _Member()
@end

/** \ingroup DataModel */

NS_INLINE NSMutableSet* NonretainingNSMutableSetMake()
{
    CFSetCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual, CFHash};
    return (__bridge NSMutableSet*) CFSetCreateMutable(0, 0, &callbacks);
}

@implementation _Member
+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet setWithSet:[super dictionaryRepresentationKeys]];
    
	  [set addObject:kModelPropertyMemberMemberId];
	  [set addObject:kModelPropertyMemberName];
    [set addObject:kModelDictionaryMemberGroup];
    
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
        self.memberId = [aDecoder decodeObjectForKey: kModelPropertyMemberMemberId];
        self.name = [aDecoder decodeObjectForKey: kModelPropertyMemberName];
        self.group = [aDecoder decodeObjectForKey: kModelPropertyMemberGroup];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    [aCoder encodeObject: self.memberId forKey: kModelPropertyMemberMemberId];
    [aCoder encodeObject: self.name forKey: kModelPropertyMemberName];
    [aCoder encodeObject: self.group forKey: kModelPropertyMemberGroup];
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if((self = [super initWithDictionaryRepresentation:dictionary]))
    {
        self.memberId = [dictionary objectForKey:kModelPropertyMemberMemberId];
        self.name = [dictionary objectForKey:kModelPropertyMemberName];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentation]];
    [dict setObjectIfNotNil:self.memberId forKey:kModelPropertyMemberMemberId];
    [dict setObjectIfNotNil:self.name forKey:kModelPropertyMemberName];
    return dict;
}

#pragma mark Direct access

- (void) setGroup: (Group*) group_ settingInverse: (BOOL) setInverse
{
    if (group_ == nil && setInverse == YES) {
        [group removeMembersObject: (Member*)self settingInverse: NO];
    }
    group = group_;
    if (setInverse == YES) {
        [group addMembersObject: (Member*)self settingInverse: NO];
    }}

- (void) setGroup: (Group*) group_
{
    [self setGroup: group_ settingInverse: YES];
}

- (Group*) group{
    return group;
}


//scalar setter and getter support
- (int32_t)memberIdValue {
    NSNumber *result = [self memberId];
    return [result intValue];
}

- (void)setMemberIdValue:(int32_t)value_ {
    [self setMemberId:[NSNumber numberWithInt:value_]];
}

#pragma mark Synthesizes

@synthesize memberId;
@synthesize name;

@end
