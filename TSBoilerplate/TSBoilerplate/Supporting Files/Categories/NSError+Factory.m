//
//  NSError+Factory.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSError+Factory.h"

@implementation NSError (Factory)

+ (NSError*)errorWithDomain:(id)domain withCode:(int)errCode withText:(NSString *)errText
{
    NSString *description = NSLocalizedString(errText, @"");
    
    NSArray *objArray = [NSArray arrayWithObjects:description, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
    
    return ([[NSError alloc] initWithDomain:domain code:errCode userInfo:eDict]);  
}

@end
