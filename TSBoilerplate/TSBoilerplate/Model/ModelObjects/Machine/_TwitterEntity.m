// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterEntity.m instead.

#import "_TwitterEntity.h"

@implementation _TwitterEntity

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
        
        self.name = [aDecoder decodeObjectForKey: @"name"];
        
        self.screen_name = [aDecoder decodeObjectForKey: @"screen_name"];
        
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.name forKey: @"name"];
    
    [aCoder encodeObject: self.screen_name forKey: @"screen_name"];
    
}



@synthesize name;




@synthesize screen_name;








@end
