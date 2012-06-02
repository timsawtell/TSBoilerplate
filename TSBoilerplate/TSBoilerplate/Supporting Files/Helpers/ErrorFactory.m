//
//  ErrorFactory.m
//  SwitchedDig
//
//  Created by Tim Sawtell on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ErrorFactory.h"

@implementation ErrorFactory

+ (NSError *)makeAnErrorWithDomain:(id)domain withCode:(int)errCode withText:(NSString *)errText
{
    NSString *description = NSLocalizedString(errText, @"");
    
    NSArray *objArray = [NSArray arrayWithObjects:description, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                      forKeys:keyArray];
    
    return ([[NSError alloc] initWithDomain:domain code:errCode userInfo:eDict]);    
}

@end
