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

#import "AppDelegate.h"
#import "Model.h"
#import "Group.h"
#import "Member.h"
#import "GroupCommand.h"
#import "GroupEditCommand.h"
#import "MemberCommand.h"
#import "MemberDisplayCommand.h" // a very trivial background command
#import "TwitterCommand.h"
#import "Tweet.h"
#import "TwitterEntity.h"
#import "TSCommandRunner.h"

#define kGroupName @"The Boilerplates"
#define kMemberStartOfName @"Comrade"
#define kTwitterScreenName @"ID_AA_Carmack" // coolest guy in the world
#define kTweetCount 10

static NSString* const kCmdMemberDisplay = @"MemberDisplayCommand";
static NSString* const kCmdMember = @"MemberCommand";
static NSString* const kCmdGroup = @"GroupCommand";
static NSString* const kCmdTwitter = @"TwitterCommand";

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.       

    [Model resetModel];    // Just for testing
    
    // Setup the commands that are available in the factory
    [TSCommandRunner registerCommand:[MemberDisplayCommand class] forKey:kCmdMemberDisplay];
    [TSCommandRunner registerCommand:[MemberCommand class] forKey:kCmdMember];
    [TSCommandRunner registerCommand:[GroupCommand class] forKey:kCmdGroup];
    [TSCommandRunner registerCommand:[TwitterCommand class] forKey:kCmdTwitter];

    // Setup the display of our member, note: the group is not known at this stage
    Command *memberDisplayCommand = [TSCommandRunner getCommand:kCmdMemberDisplay];
    memberDisplayCommand.completeOnMainThread = YES;    // Force the completion block on the main thread so that it can do UI updates
    memberDisplayCommand.commandCompletionBlock = ^ (NSError *error) {
        DLog(@"Your first completion block! I just displayed the members in the group. [%@]", 
             [NSThread isMainThread] ? @"main" : [[NSThread currentThread] name]);
        if (error != nil) {
            DLog(@":( Erorr says: %@", [error localizedDescription]);
        }
    };
    
    // Setup the completion block for when the groupCommand finishes
    commandCompletionBlock groupCommandComplete = ^(NSError *error) {
        if( error != nil ) return;
        if( [[Model sharedModel].group.members count] > 0 ) return;
        
        // Add 3 members to this group
        NSUInteger numberOfMembers = 100;
        for( NSUInteger count = 0; count < numberOfMembers; count++ ) {
            // another factory to create member instances and add them to a group
            // we are using the Model's group, so we save the model in the command
            // You can init all the params of the command when getting it
            Command *memberCommand = [TSCommandRunner getCommand:kCmdMember 
                                              withObjectsAndKeys:
                                        @"saveModel", [NSNumber numberWithBool:YES],
                                        [Model sharedModel].group.groupName, @"groupName",
                                        [NSString stringWithFormat:@"%@ %d", kMemberStartOfName, count], @"name",
                                        [NSNumber numberWithInteger:count], @"memberId",
                                        nil];

            // the member display command needs this command to be complete before it can execute
            [memberDisplayCommand addDependency:memberCommand];
            
            // execute the command
            [TSCommandRunner executeCommand:memberCommand];
        }

        // The member display needs the group to display
        // BUG: At this point in time we don't know what the members of the group are, we should really be just giving it the group id, 
        //      so that it can refetch the group
        //[memberDisplayCommand setValue:[Model sharedModel].group forKey:@"group"];  
        [memberDisplayCommand setValue:[Model sharedModel].group.groupName forKey:@"groupName"];
        
        // The command will not execute until all dependants are finished
        [TSCommandRunner executeCommand:memberDisplayCommand];
    };

    if ([Model sharedModel].group == nil) {
        // create a new group (kind of like a factory). The group is added to the model.
        Command *groupCommand = [TSCommandRunner getCommand:kCmdGroup];
        groupCommand.saveModel = YES; // at the end of the execute method, save the model.
        [groupCommand setValue:kGroupName forKey:@"groupName"];
        groupCommand.commandCompletionBlock = groupCommandComplete;
        [TSCommandRunner executeCommand:groupCommand];
    }
    else {
        // There is already a group, so just display it
        [memberDisplayCommand setValue:[Model sharedModel].group.groupName forKey:@"groupName"];
        [TSCommandRunner executeCommand:memberDisplayCommand];
    }
    
    // Now run an async command that uses MKNetorkKit to get a list of tweets for the chosen screenName
    TwitterCommand *twitterCommand = (TwitterCommand *)[TSCommandRunner getCommand:kCmdTwitter];  // You can always cast the result if you want
    twitterCommand.screenName = kTwitterScreenName;
    twitterCommand.includeRetweets = YES;
    twitterCommand.includeEntities = NO;
    twitterCommand.tweetCount = kTweetCount;
    twitterCommand.twitterCommandCompletionBlock = ^ (NSArray *tweets, NSError *error) {
        if (error != nil) {
            DLog(@":( Erorr says: %@", [error localizedDescription]);
        } else {
            // if we have a list of tweets, show them 
            for (Tweet *tweet in tweets) {
                DLog(@"%@ - %@", tweet.user.name, tweet.text);
            }
        }
    };
    [TSCommandRunner executeCommand:twitterCommand];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
