// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.m instead.

#import "_Member.h"

@implementation _Member

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
        
        self.memberId = [aDecoder decodeObjectForKey: @"memberId"];
        
        self.name = [aDecoder decodeObjectForKey: @"name"];
        
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.memberId forKey: @"memberId"];
    
    [aCoder encodeObject: self.name forKey: @"name"];
    
}



@synthesize memberId;


- (int32_t)memberIdValue {
	NSNumber *result = [self memberId];
	return [result intValue];
}

- (void)setMemberIdValue:(int32_t)value_ {
	[self setMemberId:[NSNumber numberWithInt:value_]];
}




@synthesize name;








@end
