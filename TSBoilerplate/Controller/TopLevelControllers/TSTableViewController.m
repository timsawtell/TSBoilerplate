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

#import "TSTableViewController.h"

@interface TSTableViewController ()

@end

@implementation TSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    if (self.wantsPullToRefresh) {
        self.headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) forBottomOfView:NO];
        self.headerView.delegate = self;
        [self.tableView addSubview:self.headerView];
        
        if (self.wantsPullToRefreshFooter) {
            self.footerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.tableView.frame.size.height, self.view.frame.size.width, self.tableView.bounds.size.height) forBottomOfView:YES];
            self.footerView.delegate = self;
            self.footerView.hidden = YES;
            [self.tableView addSubview:self.footerView];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [super viewDidUnload];
}

- (void)reloadData
{
    [self.tableView reloadData];
    // any other things that need to be reloaded
    if (self.wantsPullToRefreshFooter) {
        self.footerView.hidden = NO;
        [self setupFooterView];
    }
    if ([self wantsPullToRefresh]) {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
    }
}

- (void)setupFooterView
{
    CGRect frameRect;
    if (self.tableView.contentSize.height < self.tableView.bounds.size.height) {
        frameRect = CGRectMake(self.footerView.frame.origin.x, self.tableView.bounds.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        self.footerView.frame = frameRect;
    } else {
        frameRect = CGRectMake(self.footerView.frame.origin.x, self.tableView.contentSize.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        self.footerView.frame = frameRect;
    }
}

- (BOOL)wantsPullToRefresh
{
    return NO; // by default, the VCs you subclass should return YES if needed
}

- (BOOL)wantsPullToRefreshFooter
{
    return NO; // by default, the VCs you subclass should return YES if needed
}

- (void)fetchData
{
    self.fetchingData = YES;
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	self.fetchingData = NO;
    [self.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [self.footerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self fetchData];
}

- (void)egoRefreshTableHeaderDidTriggerLoadMore:(EGORefreshTableHeaderView *)view
{
    [self fetchData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return self.fetchingData;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (self.wantsPullToRefresh) {
        // find out if the user is pulling on the top part (to refresh) or the bottom part (to load more)
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = MAX(scrollView.contentSize.height - scrollView.frame.size.height, 0);
        if (currentOffset < 0) {
            [self.headerView egoRefreshScrollViewDidScroll:scrollView];
        } else if (currentOffset > maximumOffset) {
            [self.footerView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (self.wantsPullToRefresh) {
        // find out if the user is pulling on the top part (to refresh) or the bottom part (to load more)
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = MAX(scrollView.contentSize.height - scrollView.frame.size.height, 0);
        if (currentOffset < 0) {
            [self.headerView egoRefreshScrollViewDidEndDragging:scrollView];
        } else if (currentOffset > maximumOffset) {
            [self.footerView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark - tableview headers
// when the keyboard shows we have to update the scroll position and the content inset for the tableview, such that it's resized to be above the keyboard
- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets;
    CGFloat distanceOfTableViewFromBottomOfWindow = self.view.frame.size.height - self.tableView.frame.origin.y - (self.tableView.frame.origin.y + self.tableView.frame.size.height);
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - self.tableView.frame.origin.y - distanceOfTableViewFromBottomOfWindow, 0.0f);
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

@end
