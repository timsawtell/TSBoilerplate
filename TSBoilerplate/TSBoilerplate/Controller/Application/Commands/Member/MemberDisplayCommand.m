//
//  MemberDisplayCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberDisplayCommand.h"
#import "Member.h"

@implementation MemberDisplayCommand

@synthesize group;

- (void)execute
{
    if (self.group != nil) {
        DLog(@"Your first Asynchronous command!");
        //always take a copy because the assignment is weak and other threads might change the nsset data
        NSSet *members = [self.group.members copy];
        for (Member *member in members) {
            DLog(@"Member is called: %@ in group: %@", member.name, self.group.groupName);
        }
    }
    [self finish];
}

@end
