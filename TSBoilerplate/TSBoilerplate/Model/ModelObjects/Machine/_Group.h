// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import "ModelObject.h"


@class Member;



@interface _Group : ModelObject <NSCoding>





@property (nonatomic, strong) NSString* groupName;








@property (nonatomic, strong) NSSet *members;






- (id) initWithCoder: (NSCoder*) aDecoder;
- (void) encodeWithCoder: (NSCoder*) aCoder;
@end
