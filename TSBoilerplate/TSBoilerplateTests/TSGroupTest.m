/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.¨
 */

#import "TSGroupTest.h"
#import "Group.h"
#import "TSCommandRunner.h"
#import "GroupCommand.h"
#import "Member.h"
#import "MemberCommand.h"
#import "GroupEditCommand.h"

#define kGroupName @"TestGroup"

@implementation TSGroupTest

- (void)setUp
{
    [super setUp];
}

- (void)testAddGroupToModel
{
    GroupCommand *groupCommand = [GroupCommand new];
    groupCommand.groupName = kGroupName;
    groupCommand.saveModel = YES; // at the end of the execute method, save the model.
    [[TSCommandRunner sharedCommandRunner] executeSynchronousCommand:groupCommand];
    STAssertNotNil([Model sharedModel].group, @"oh no, the group isn't saved to the model");
    STAssertEquals([Model sharedModel].group.groupName, kGroupName, @"oh no, the group doesn't have a member");
}

- (void)testAddMember
{
    Group *group = [Group new];
    group.groupName = @"Test group";
    MemberCommand *memberCommand = [MemberCommand new];
    memberCommand.name = [NSString stringWithFormat:@"Test Guy"];
    memberCommand.memberId = 1;
    memberCommand.group = group;
    memberCommand.saveModel = NO;
    [[TSCommandRunner sharedCommandRunner] executeSynchronousCommand:memberCommand];
    STAssertEquals((NSInteger)[group.members count], 1, @"oh no, the group doesn't have a member");
}

@end
