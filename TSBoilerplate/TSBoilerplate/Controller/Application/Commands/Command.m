//
//  Command.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

@implementation Command

@synthesize subCommands, error, saveModel;

- (void)execute
{
    self.error = nil;
    //do processing here. Add any commands that you generate to your subCommands property
}

@end
