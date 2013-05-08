#import "Member.h"


@interface Member ()

// Private interface goes here.

@end


@implementation Member

#pragma mark - NSCoding

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Implement custom loading logic here
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    // Implement custom saving logic here
}


// Custom logic goes here.

@end
