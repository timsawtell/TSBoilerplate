//
//  NSError+Factory.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Factory)

+ (NSError*)errorWithDomain:(id)domain withCode:(int)errCode withText:(NSString *)errText;

@end
