//
//  SettingsHelper.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 28/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsHelper : NSObject

+ (void)saveToUserDefaults:(id)myVal forKey:(NSString *)myKey;
+ (id)getFromUserDefaultsWithKey:(NSString *)myKey;

@end
