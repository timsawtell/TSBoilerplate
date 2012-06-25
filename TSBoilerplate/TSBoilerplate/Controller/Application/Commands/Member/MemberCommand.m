/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.
 */

#import "MemberCommand.h"
#import "Model.h"
#import "MKNetworkKit.h"    // DLog definition

@implementation MemberCommand

@synthesize name, member, group, memberId, groupName;

- (BOOL)runInBackground
{
    return YES;
}

- (NSError *)execute
{
    DLog( @"MemberCommand: is%@ running on main thread: adding %@", [NSThread isMainThread] ? @"" : @"n't", self.name );
    self.member = [Member new];
    self.member.name = self.name;
    self.member.memberId = [NSNumber numberWithInteger:self.memberId];
    
    // in reality we should load the group by it's name
    // DEV NOTE: We need to synchronize the group, so only one thread has access to change it at a time
    @synchronized( [Model sharedModel].group ) {
        Group *theGroup = [Model sharedModel].group;
        
        if (theGroup != nil) {
            if (theGroup.members == nil) {
                theGroup.members = [NSSet set];
            }
            theGroup.members = [theGroup.members setByAddingObject:self.member];
        }
    }
    if (self.saveModel) {
        [[Model sharedModel] save];
    }
    return nil;
}

@end
