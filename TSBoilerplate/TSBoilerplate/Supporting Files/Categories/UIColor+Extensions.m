#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+(UIColor *)colorWithHexString:(NSString *)stringToConvert
{
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	if ([cString length] < 6) return [UIColor blackColor];
	if ([cString hasPrefix:@"0X"])
		cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"])
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6) return [UIColor blackColor];
    
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
    
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
    
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
    
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
    
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

@end
