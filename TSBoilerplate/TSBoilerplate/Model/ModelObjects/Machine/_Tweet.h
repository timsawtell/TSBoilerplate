// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.

#import "ModelObject.h"


@class TwitterEntity;



@interface _Tweet : ModelObject <NSCoding>





@property (nonatomic, strong) NSString* text;








@property (nonatomic, strong) TwitterEntity *user;






- (id) initWithCoder: (NSCoder*) aDecoder;
- (void) encodeWithCoder: (NSCoder*) aCoder;
@end
