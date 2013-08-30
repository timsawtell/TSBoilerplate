
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

#import "TweetsViewController.h"
#import "TwitterCommand.h"
#import "TweetCell.h"
#import "Tweet.h"

#define kScreenName @"devops_borat"
#define kNumTweets 10

@interface TweetsViewController ()
@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TweetsViewController

-(BOOL)wantsPullToRefresh
{
    return YES;
}

-(BOOL)wantsPullToRefreshFooter
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
}


- (void)fetchData
{
    [super fetchData];
    self.tweets = [[ModelAccessor sharedModelAccessor] getAllTweets];
    [self goGetTweets];
}

- (void)goGetTweets
{
    // Now run a command that uses MKNetorkKit to get a list of tweets for the chosen screenName
    __weak typeof(self) weakSelf = self;
    TwitterCommand *twitterCommand = [TwitterCommand new];
    twitterCommand.screenName = kScreenName;
    twitterCommand.includeRetweets = YES;
    twitterCommand.includeEntities = NO;
    twitterCommand.tweetCount = kNumTweets;
    twitterCommand.commandCompletionBlock = ^ (NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf hideActivityScreen];
        if (error != nil) {
            AlertViewController *avc = [AlertViewController new];
            [avc showForViewController:strongSelf
                             withTitle:@"Erorr"
                              withBody:[error localizedDescription]
                         buttonHandler:nil
                          buttonTitles:@"Damn", nil];
            return;
        }
        strongSelf.tweets = [[ModelAccessor sharedModelAccessor] getAllTweets];
        [strongSelf reloadData];
    };
    [self showActivityScreen];
    twitterCommand.saveModel = YES;
    [[TSCommandRunner sharedCommandRunner] executeCommand:twitterCommand];
}

#pragma mark - UITableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self tweets].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = kTweetCell;
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    cell.tweetTextLabel.text = tweet.text;
    return cell;
}

@end
