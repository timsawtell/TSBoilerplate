//
//  MemberCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MemberCommand.h"

@implementation MemberCommand

@synthesize name, member, group;

- (void)execute
{
    self.member = [Member new];
    self.member.name = self.name;
    
    if (self.group != nil) {
        if (self.group.members == nil) {
            self.group.members = [NSSet set];
        }
        self.group.members = [self.group.members setByAddingObject:self.member];
    }
    if (self.saveModel) {
        [[Model sharedModel] save];
    }
}

@end
