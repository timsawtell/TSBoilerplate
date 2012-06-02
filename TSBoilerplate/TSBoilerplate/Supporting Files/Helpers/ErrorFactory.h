//
//  ErrorFactory.h
//  SwitchedDig
//
//  Created by Tim Sawtell on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorFactory : NSObject

+ (NSError *)makeAnErrorWithDomain:(id)domain withCode:(int)errCode withText:(NSString *)errText;

@end
