#import "UIView+loadFromNib.h"

@implementation UIView (loadFromNib)

+ (id)loadNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle owner:(id)owner
{
    if (nil == bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    if (nil == nibNameOrNil) {
        nibNameOrNil = NSStringFromClass([self class]);
    }
    
    NSArray *objects = [bundle loadNibNamed:nibNameOrNil owner:owner options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[self class]]) {
            return object;
        }
    }
    return nil;
}

+ (id)loadFromNib
{
    return [self loadNibName:nil bundle:nil owner:nil];
}

@end
