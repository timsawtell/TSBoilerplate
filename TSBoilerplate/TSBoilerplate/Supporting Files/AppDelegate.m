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

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.       
    if ([Model sharedModel].group == nil) {
        // create a new group (kind of like a factory). The group is added to the model.
        GroupCommand *groupCommand = [GroupCommand new];
        groupCommand.groupName = kGroupName;
        groupCommand.saveModel = YES; // at the end of the execute method, save the model.
        [TSCommandRunner executeCommand:groupCommand];
    }
    
    if ([[Model sharedModel].group.members count] <= 0) {
        // if no members in this group, add 3 of them
        for (NSUInteger count = 0; count < 3; count++) {
            // another factory to create member instances and add them to a group
            // we are using the Model's group, so we save the model in the command
            MemberCommand *memberCommand = [MemberCommand new];
            memberCommand.name = [NSString stringWithFormat:@"%@ %d", kMemberStartOfName, count];
            memberCommand.memberId = count;
            memberCommand.group = [Model sharedModel].group;
            memberCommand.saveModel = YES; // trade off to your liking. Save with each command execution or call [[Model sharedModel] save] yourself later.
            [TSCommandRunner executeCommand:memberCommand];
        }
    }
    
    // Run a trivial background command to display the group's members
    MemberDisplayCommand *memberDisplayCommand = [MemberDisplayCommand new];
    memberDisplayCommand.group = [Model sharedModel].group;
    memberDisplayCommand.completeOnMainThread = YES;    // Force the completion block on the main thread so that it can do UI updates
    memberDisplayCommand.commandCompletionBlock = ^ (NSError *error) {
        DLog(@"Your first completion block! I just displayed the members in the group. [%@]", [NSThread isMainThread] ? @"main" : [[NSThread currentThread] name]);
        if (error != nil) {
            DLog(@":( Erorr says: %@", [error localizedDescription]);
        }
    };
    [TSCommandRunner executeCommand:memberDisplayCommand];
    
    // Now run a command that uses MKNetorkKit to get a list of tweets for the chosen screenName
    TwitterCommand *twitterCommand = [TwitterCommand new];
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
