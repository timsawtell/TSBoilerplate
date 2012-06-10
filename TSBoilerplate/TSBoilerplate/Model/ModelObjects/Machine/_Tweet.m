// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.m instead.

#import "_Tweet.h"

@implementation _Tweet

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
        
        self.text = [aDecoder decodeObjectForKey: @"text"];
        
        
        self.user = [aDecoder decodeObjectForKey: @"user"];
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.text forKey: @"text"];
    
    [aCoder encodeObject: self.user forKey: @"user"];
    
}



@synthesize text;




@synthesize user;





@end
