//
//  GroupTest.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 8/10/13.
//
//

#import <XCTest/XCTest.h>
#import "GroupCommand.h"
#import "TSCommandRunner.h"
#import "MemberCommand.h"

@interface GroupTest : XCTestCase

@end

@implementation GroupTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAddGroupToModel
{
    GroupCommand *groupCommand = [GroupCommand new];
    groupCommand.groupName = @"The groupies";
    groupCommand.saveModel = YES; // at the end of the execute method, save the model.
    [[TSCommandRunner sharedCommandRunner] executeCommand:groupCommand];
    XCTAssertNotNil([Model sharedModel].group, @"oh no, the group isn't saved to the model");
    XCTAssertEqual([Model sharedModel].group.groupName, @"The groupies", @"oh no, the group doesn't have a member");
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
    [[TSCommandRunner sharedCommandRunner] executeCommand:memberCommand];
    XCTAssertEqual((NSInteger)[group.members count], 1, @"oh no, the group doesn't have a member");
}
@end
