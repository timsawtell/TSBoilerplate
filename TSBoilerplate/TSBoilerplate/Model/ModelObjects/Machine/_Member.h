// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.h instead.

#import "ModelObject.h"


extern const struct MemberAttributes {
	__unsafe_unretained NSString *name;
} MemberAttributes;

extern const struct MemberRelationships {
	__unsafe_unretained NSString *group;
} MemberRelationships;

extern const struct MemberFetchedProperties {
} MemberFetchedProperties;

@class Group;



@interface _Member : ModelObject <NSCoding>





@property (nonatomic, strong) NSString* name;








@property (nonatomic, strong) Group *group;






- (id) initWithCoder: (NSCoder*) aDecoder;
- (void) encodeWithCoder: (NSCoder*) aCoder;
@end
