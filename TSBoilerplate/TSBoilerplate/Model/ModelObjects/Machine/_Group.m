// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.m instead.

#import "_Group.h"

const struct GroupAttributes GroupAttributes = {
	.groupName = @"groupName",
};

const struct GroupRelationships GroupRelationships = {
	.members = @"members",
};

const struct GroupFetchedProperties GroupFetchedProperties = {
};

@implementation _Group

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
        
        self.groupName = [aDecoder decodeObjectForKey: @"groupName"];
        
        
        self.members = [aDecoder decodeObjectForKey: @"members"];
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.groupName forKey: @"groupName"];
    
    [aCoder encodeObject: self.members forKey: @"members"];
    
}




@dynamic groupName;






@dynamic members;

	
- (NSMutableSet*)membersSet {
	//[self willAccessValueForKey:@"members"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];
  
	//[self didAccessValueForKey:@"members"];
	return result;
}
	






@end
