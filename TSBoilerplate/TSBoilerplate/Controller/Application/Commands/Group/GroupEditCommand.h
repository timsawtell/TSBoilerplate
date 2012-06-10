//
//  GroupPersist.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousCommand.h"
#import "Group.h"

@interface GroupEditCommand : AsynchronousCommand

@property (nonatomic, strong) Group *group;

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSSet *members;

@end
