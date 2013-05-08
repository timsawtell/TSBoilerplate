#import <UIKit/UIKit.h>

@interface UIView (loadFromNib)

+ (id)loadNibName:(NSString *)nibName bundle:(NSBundle *)bundle owner:(id)owner;
+ (id)loadFromNib;

@end
