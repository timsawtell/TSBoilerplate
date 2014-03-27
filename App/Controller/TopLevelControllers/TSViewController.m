/*
 Copyright (c) 2013 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "TSViewController.h"
#import "FFCircularProgressView.h"
#import "UIColor+Extensions.h"

static NSString * const kHideActivitySuperview  = @"hideActivitySuperview";
static NSString * const kFontToUse              = @"Helvetica-Bold";

static CGFloat const kFontSize                  = 16.0f;

@interface TSViewController ()
@property (nonatomic, assign) BOOL overrideShowingActivityScreen;
@property (nonatomic, strong) UIView *activitySuperview;
@property (nonatomic, weak) UIResponder *activeControl;

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
- (void)fetchData;
- (void)closeKeyboard;
- (void)prevInput;
- (void)nextInput;
@end

@implementation TSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.inputFields.count > 0) {
        self.inputFields = [self.inputFields sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
            if ([label1 frame].origin.y < [label2 frame].origin.y) return NSOrderedAscending;
            else if ([label1 frame].origin.y > [label2 frame].origin.y) return NSOrderedDescending;
            else return NSOrderedSame;
        }];
        
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.opaque = NO;
        toolbar.translucent = YES;
        
        UISegmentedControl *nextPrev = [[UISegmentedControl alloc] initWithItems:@[@"Previous", @"Next"]];
        nextPrev.momentary = YES;
        nextPrev.highlighted = YES;
        [nextPrev addTarget:self action:@selector(nextPrevChanged:) forControlEvents:UIControlEventValueChanged];
        UIBarButtonItem *nextPrevItem = [[UIBarButtonItem alloc] initWithCustomView:nextPrev];
        toolbar.items = [NSArray arrayWithObjects:
                         nextPrevItem,
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyboard)],
                         nil];
        [toolbar sizeToFit];
        for (UIResponder *control in self.inputFields) {
            if ([control isKindOfClass:[UITextView class]]) {
                UITextView *tv = (UITextView *)control;
                tv.inputAccessoryView = toolbar;
            } else if ([control isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)control;
                tf.inputAccessoryView = toolbar;
            }
        }
    }
    
    if (nil != self.scrollViewToResizeOnKeyboardShow) {
        self.scrollViewToResizeOnKeyboardShow.contentInset = UIEdgeInsetsZero;
        self.scrollViewToResizeOnKeyboardShow.contentSize = self.scrollViewToResizeOnKeyboardShow.frame.size;
        if (self.wantsPullToRefresh) {
            self.headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.scrollViewToResizeOnKeyboardShow.bounds.size.height, self.scrollViewToResizeOnKeyboardShow.bounds.size.width, self.scrollViewToResizeOnKeyboardShow.bounds.size.height) forBottomOfView:NO];
            self.headerView.delegate = self;
            [self.scrollViewToResizeOnKeyboardShow addSubview:self.headerView];
            
            if (self.wantsPullToRefreshFooter) {
                self.footerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, self.scrollViewToResizeOnKeyboardShow.frame.size.height, self.view.frame.size.width, self.scrollViewToResizeOnKeyboardShow.bounds.size.height) forBottomOfView:YES];
                self.footerView.delegate = self;
                self.footerView.hidden = YES;
                [self.scrollViewToResizeOnKeyboardShow addSubview:self.footerView];
            }
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)viewDidUnload
{
    if (nil != self.scrollViewToResizeOnKeyboardShow) {
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
        [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    }
    [super viewDidUnload];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self respondsToSelector:@selector(specialLayout)]) {
        [self performSelector:@selector(specialLayout) withObject:nil afterDelay:0.1];
    }
}

/* any layout code that needs to be run after view did layout subviews. This is needed for scrollviews (contentsize) because
 * of autolayout insanity. */
- (void)specialLayout
{
    if (self.scrollViewToResizeOnKeyboardShow.contentSize.height < self.scrollViewToResizeOnKeyboardShow.bounds.size.height) {
        self.scrollViewToResizeOnKeyboardShow.contentSize = [self scrollViewContentSize];
    }
}

- (CGSize)scrollViewContentSize
{
    return self.scrollViewToResizeOnKeyboardShow.bounds.size;
}

- (void)nextPrevChanged:(id)sender
{
    UISegmentedControl *nextPrev = (UISegmentedControl *)sender;
    switch (nextPrev.selectedSegmentIndex) {
        case 0:
            [self prevInput];
            break;
        case 1:
            [self nextInput];
            break;
        default:
            break;
    }
}

// from the inputAccessoryView
-(void)closeKeyboard
{
    [self.activeControl resignFirstResponder];
}

// from the inputAccessoryView
- (void)nextInput
{
    if (self.inputFields.count < 2) return;
    for (NSInteger i = 0; i < self.inputFields.count; i++) {
        if ([self.inputFields objectAtIndex:i] == self.activeControl) {
            UIControl *nextControl;
            if (i < self.inputFields.count - 1) {
                nextControl = [self.inputFields objectAtIndex:i+1];
            } else {
                nextControl = [self.inputFields objectAtIndex:0];
            }
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollViewToResizeOnKeyboardShow scrollRectToVisible:nextControl.frame animated:NO];
                [self.scrollViewToResizeOnKeyboardShow flashScrollIndicators];
            } completion:^(BOOL finished) {
                [nextControl becomeFirstResponder];
            }];
            break;
        }
    }
}

// from the inputAccessoryView
- (void)prevInput
{
    if (self.inputFields.count < 2) return;
    for (NSInteger i = self.inputFields.count - 1; i >= 0; i--) {
        if ([self.inputFields objectAtIndex:i] == self.activeControl) {
            UIControl *nextControl;
            if (i == 0) {
                nextControl = [self.inputFields objectAtIndex:self.inputFields.count-1];
            } else {
                nextControl = [self.inputFields objectAtIndex:i - 1];
            }
            [UIView animateWithDuration:0.2 animations:^{
                [self.scrollViewToResizeOnKeyboardShow scrollRectToVisible:nextControl.frame animated:NO];
                [self.scrollViewToResizeOnKeyboardShow flashScrollIndicators];
            } completion:^(BOOL finished) {
                [nextControl becomeFirstResponder];
            }];
            
            break;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.inputFields containsObject:textField]) {
        self.activeControl = textField;
    } else {
        self.activeControl = nil;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.inputFields containsObject:textView]) {
        self.activeControl = textView;
    } else {
        self.activeControl = nil;
    }
}

// when the keyboard shows we have to update the scroll position and the content inset for the scrollView, such that it's resized to be above the keyboard
- (void)keyboardDidShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    
    UIEdgeInsets contentInsets;
    CGFloat viewHeight = self.view.frame.size.height;
    // bug with the notification being the wrong size when in landscape
    if (isLandscape) {
        CGFloat kbSizeHeight = MIN(kbSize.width, kbSize.height);
        CGFloat kbSizeWidth = MAX(kbSize.width, kbSize.height);
        kbSize = CGSizeMake(kbSizeWidth, kbSizeHeight);
        viewHeight = MIN(self.view.frame.size.height, self.view.frame.size.width);// just querying self.view.frame.size.height won't work as it reports a portrait size with a rotation transform applied to the layer
    }
    CGFloat distanceOfScrollViewFromBottomOfWindow = MAX(0, viewHeight - self.scrollViewToResizeOnKeyboardShow.frame.origin.y - (self.scrollViewToResizeOnKeyboardShow.frame.origin.y + self.scrollViewToResizeOnKeyboardShow.frame.size.height));

    CGFloat adjustForTabBar = (nil == self.tabBarController) ? 0 : self.tabBarController.tabBar.frame.size.height;
    
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - self.scrollViewToResizeOnKeyboardShow.frame.origin.y - distanceOfScrollViewFromBottomOfWindow - adjustForTabBar, 0.0f);
    
    self.scrollViewToResizeOnKeyboardShow.scrollIndicatorInsets = contentInsets;
    self.scrollViewToResizeOnKeyboardShow.contentInset = contentInsets;
    
    if (nil != self.activeControl) {
        UIView *view = (UIView *)self.activeControl;
        if (nil != self.activeControl) {
            CGRect rect = view.frame;
            if (! [self.scrollViewToResizeOnKeyboardShow.subviews containsObject:self.activeControl]) {
                CGPoint p = [view convertPoint:view.frame.origin toView:self.scrollViewToResizeOnKeyboardShow];
                rect = CGRectMake(1, p.y + view.frame.size.height, 1, 1);
            }
            [self.scrollViewToResizeOnKeyboardShow scrollRectToVisible:rect animated:YES];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewToResizeOnKeyboardShow.scrollIndicatorInsets = contentInsets;
    self.scrollViewToResizeOnKeyboardShow.contentInset = contentInsets;
}

- (void)showActivityScreen
{
    [self showActivityScreenWithMessage:@"Loading"];
}

- (void)showActivityScreenWithMessage:(NSString*)message
{
    if (self.overrideShowingActivityScreen == YES) {
        return;
    }
    
	if (self.activitySuperview) {
		[self.activitySuperview removeFromSuperview];
		self.activitySuperview = nil;
	}
    
	self.activitySuperview = [[UIView alloc] initWithFrame: self.view.bounds];
	[self.activitySuperview setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self.view addSubview: self.activitySuperview];
    
	UIView *dimmerView = [[UIView alloc] initWithFrame: self.activitySuperview.bounds];
	[dimmerView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	dimmerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 1.0];
	dimmerView.alpha = 0.6;
	[self.activitySuperview addSubview: dimmerView];
	
	CGRect containerBG = CGRectRoundToInt(CGRectMake((self.activitySuperview.bounds.size.width / 2) - (250.0 / 2),
                                                     (self.activitySuperview.bounds.size.height / 2) - (250.0 / 2), 250.0, 250.0));
	
	UIView *containerView = [[UIView alloc] initWithFrame:containerBG];
	containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	[containerView setBackgroundColor:[UIColor clearColor]];
	[self.activitySuperview addSubview:containerView];
    
	CGRect spinnerBG = CGRectRoundToInt(CGRectMake((containerBG.size.width / 2) - (90.0 / 2),
                                                   (containerBG.size.height / 2) - (90.0 / 2), 90.0, 90.0));
	UIView *activitySpinnerBackground = [[UIView alloc] initWithFrame: spinnerBG];
	activitySpinnerBackground.backgroundColor = [UIColor colorWithHexString:@"5266A4"];
	activitySpinnerBackground.opaque = NO;
	activitySpinnerBackground.layer.cornerRadius = 45;
	
	[containerView addSubview: activitySpinnerBackground];
	
	if(NSStringIsSane(message) == YES) {
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, spinnerBG.origin.y-50, (containerView.bounds.size.width-40), 70)];
        messageLabel.text = message;
        [messageLabel setNumberOfLines:1];
		[messageLabel setFont:[UIFont fontWithName:kFontToUse size:kFontSize]];
		[messageLabel setShadowColor:[UIColor blackColor]];
		[messageLabel setShadowOffset:CGSizeMake(0, 1)];
		[messageLabel setTextColor:[UIColor whiteColor]];
		[messageLabel setBackgroundColor:[UIColor clearColor]];
		[messageLabel setTextAlignment:NSTextAlignmentCenter];
		[containerView addSubview:messageLabel];
	}
	
    CGRect progressFrame = CGRectMake(spinnerBG.size.width / 2 - 25, spinnerBG.size.height / 2 - 25, 50, 50);
	FFCircularProgressView *progressView = [[FFCircularProgressView alloc] initWithFrame:progressFrame];
    progressView.iconLayer.hidden = YES;
    [progressView setTintColor:[UIColor whiteColor]];
    [activitySpinnerBackground addSubview:progressView];
    [progressView startSpinProgressBackgroundLayer];
    
    [UIView beginAnimations:@"fadeglow" context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:HUGE_VAL];
    activitySpinnerBackground.alpha = 0.8;
    [UIView commitAnimations];
    
    self.activitySuperview.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.activitySuperview.alpha = 1.0;
    }];
}

- (void)hideActivityScreen
{
	self.activitySuperview.alpha = 1.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.activitySuperview.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.activitySuperview removeFromSuperview];
		self.activitySuperview = nil;
    }];
}

#pragma mark - EgoHeaderview

- (void)setupFooterView
{
    CGRect frameRect;
    if (self.scrollViewToResizeOnKeyboardShow.contentSize.height < self.scrollViewToResizeOnKeyboardShow.bounds.size.height) {
        frameRect = CGRectMake(self.footerView.frame.origin.x, self.scrollViewToResizeOnKeyboardShow.bounds.size.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
        self.footerView.frame = frameRect;
    } else {
        frameRect = CGRectMake(self.footerView.frame.origin.x, self.scrollViewToResizeOnKeyboardShow.contentSize.height, self.footerView.frame.size.width, self.footerView.frame.size.height);
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

- (void)doneLoadingData
{
	//  model should call this when its done loading
	self.fetchingData = NO;
    [self.headerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollViewToResizeOnKeyboardShow];
    [self.footerView egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollViewToResizeOnKeyboardShow];
}

- (void)reloadData
{
    // any other things that need to be reloaded
    if (self.wantsPullToRefreshFooter) {
        self.footerView.hidden = NO;
        [self setupFooterView];
    }
    if ([self wantsPullToRefresh]) {
        [self performSelector:@selector(doneLoadingData) withObject:nil afterDelay:0.1];
    }
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

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

@end
