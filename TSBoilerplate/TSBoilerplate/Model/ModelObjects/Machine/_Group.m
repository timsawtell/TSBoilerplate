// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.m instead.

#import "_Group.h"

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



@synthesize groupName;




@synthesize members;





@end
