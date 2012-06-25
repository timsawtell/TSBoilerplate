#import "Group.h"


@interface Group ()

// Private interface goes here.

@end


@implementation Group

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


@end
