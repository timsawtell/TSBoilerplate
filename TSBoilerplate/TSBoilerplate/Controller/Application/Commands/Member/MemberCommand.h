//
//  MemberCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"
#import "Member.h"
#import "Group.h"

@interface MemberCommand : Command

@property (nonatomic, strong) Member *member;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) Group *group;

@end

