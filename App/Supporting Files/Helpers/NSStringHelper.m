#import "NSStringHelper.h"

@implementation NSStringHelper

BOOL NSStringIsSane(NSString* string)
{
	if (string == nil) {
		return NO;
	}
	if ((__bridge  void*)string == (__bridge void*)[NSNull null]) {
		return NO;
	}
	if ([string length] == 0) {
		return NO;
	}
	if ([string isEqualToString: @""]) {
		return NO;
	}
	if ([[string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString: @""]) {
		return NO;
	}
    if ([string.lowercaseString isEqualToString:@"null"]) {
        return NO;
    }
	return YES;
}

@end
