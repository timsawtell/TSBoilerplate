//
//  GroupCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 10/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupCommand.h"

@implementation GroupCommand

@synthesize group, groupName;

- (void)execute
{
    self.group = [Group new]; 
    self.group.groupName = self.groupName;
    
    if (self.saveModel) {
        //add the group to the model. You don't have to do this assignment here. You
        //could reference the command's group iVar later and use that in another command
        
        [Model sharedModel].group = self.group;
        [[Model sharedModel] save];
    }
}

@end
