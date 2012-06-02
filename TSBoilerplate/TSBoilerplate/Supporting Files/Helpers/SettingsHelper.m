//
//  SettingsHelper.m
//  SwitchedDig
//
//  Created by Tim Sawtell on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsHelper.h"

@implementation SettingsHelper


+ (void)saveToUserDefaults:(id)myVal forKey:(NSString *)myKey
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myVal forKey:myKey];
		[standardUserDefaults synchronize];
	}
}

+ (id)getFromUserDefaultsWithKey:(NSString *)myKey
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	id val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey:myKey];
	
	return val;
}

@end
