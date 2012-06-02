// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import "ModelObject.h"


extern const struct GroupAttributes {
	__unsafe_unretained NSString *groupName;
} GroupAttributes;

extern const struct GroupRelationships {
	__unsafe_unretained NSString *members;
} GroupRelationships;

extern const struct GroupFetchedProperties {
} GroupFetchedProperties;

@class Member;



@interface _Group : ModelObject <NSCoding>





@property (nonatomic, strong) NSString* groupName;








@property (nonatomic, strong) NSSet *members;

- (NSMutableSet*)membersSet;





- (id) initWithCoder: (NSCoder*) aDecoder;
- (void) encodeWithCoder: (NSCoder*) aCoder;
@end
