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

#import "TSViewController.h"

static NSString * const kHideActivitySuperview  = @"hideActivitySuperview";
static NSString * const kFontToUse              = @"Helvetica-Bold";

static CGFloat const kCornerRadius              = 10.0f;
static CGFloat const kFontSize                  = 16.0f;

@interface TSViewController ()
@property (nonatomic, assign) BOOL overrideShowingActivityScreen;
@property (nonatomic, strong) UIView *activitySuperview;
- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation TSViewController

- (void) showActivityScreen
{
    [self showActivityScreenWithMessage:@"Loading..." animated:YES];
}

- (void) showActivityScreenWithMessage:(NSString*)message animated:(BOOL)animated
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
    
	CGRect spinnerBG = CGRectRoundToInt(CGRectMake((containerBG.size.width / 2) - (111.0 / 2),
                                                   (containerBG.size.height / 2) - (111.0 / 2), 111.0, 111.0));
	UIView *activitySpinnerBackground = [[UIView alloc] initWithFrame: spinnerBG];
	activitySpinnerBackground.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.6];
	activitySpinnerBackground.opaque = NO;
	activitySpinnerBackground.alpha = 1.0;
	activitySpinnerBackground.layer.cornerRadius = kCornerRadius;
	activitySpinnerBackground.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
	
	[containerView addSubview: activitySpinnerBackground];
	
	if(NSStringIsSane(message) == YES)
	{
		UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, spinnerBG.origin.y-50-20, (containerView.bounds.size.width-40), 70)];
        [messageLabel setNumberOfLines:2];
		messageLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		[messageLabel setFont:[UIFont fontWithName:kFontToUse size:kFontSize]];
		[messageLabel setShadowColor:[UIColor blackColor]];
		[messageLabel setShadowOffset:CGSizeMake(0, 1)];
		[messageLabel setTextColor:[UIColor whiteColor]];
		[messageLabel setBackgroundColor:[UIColor clearColor]];
		[messageLabel setTextAlignment:UITextAlignmentCenter];
		messageLabel.text = message;
		[containerView addSubview:messageLabel];
	}
	
	UIActivityIndicatorView *activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
	[activitySpinnerBackground addSubview: activitySpinner];
	[activitySpinner setFrame: CGRectMake(37, 37, 37, 37)];
	[activitySpinner startAnimating];
	
	if (animated) {
		self.activitySuperview.alpha = 0.0;
		[UIView beginAnimations: nil context: nil];
		[UIView setAnimationDuration: 0.3];
		self.activitySuperview.alpha = 1.0;
		[UIView commitAnimations];
	}
}

- (void) hideActivityScreen
{
    [self hideActivityScreenAnimated:YES];
}

- (void) hideActivityScreenAnimated:(BOOL)animated
{
	if (!animated) {
		[self.activitySuperview removeFromSuperview];
		self.activitySuperview = nil;
		return;
	}
	self.activitySuperview.alpha = 1.0;
	[UIView beginAnimations:kHideActivitySuperview context: nil];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(animationDidStop:finished:context:)];
	self.activitySuperview.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:kHideActivitySuperview]) {
		[self.activitySuperview removeFromSuperview];
		self.activitySuperview = nil;
	}
}

@end
