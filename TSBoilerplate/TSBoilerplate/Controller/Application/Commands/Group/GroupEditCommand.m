//
//  GroupPersist.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupEditCommand.h"

@implementation GroupEditCommand

@synthesize group, groupName, members;

- (void)execute
{
    if (self.group == nil) {
        self.group = [Group new];
    }
    
    if (self.groupName != nil) {
        self.group.groupName = self.groupName;
    }
    
    if (self.members != nil) {
        self.group.members = self.members;
    }
    
    if (self.saveModel) {
        [[Model sharedModel] save];
    }
    
    [self finish];
}

@end
