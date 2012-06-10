//
//  GroupCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  Use this top left <class>Command class to do the creation of new groups

#import "Command.h"

@interface GroupCommand : Command

@property (nonatomic, strong) Group *group;
@property (nonatomic, copy) NSString *groupName;

@end
