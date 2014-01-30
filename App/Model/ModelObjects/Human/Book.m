#import "Book.h"

@implementation Book

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

#pragma mark Abstract method overrides




// Custom logic goes here.

@end
