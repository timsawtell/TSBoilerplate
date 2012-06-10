//
//  MemberDisplayCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousCommand.h"
#import "Group.h"

@interface MemberDisplayCommand : AsynchronousCommand

@property (nonatomic, weak) Group *group;

@end
