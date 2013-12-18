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

/**
 * A view controller that will present a view that shows a message, and dismisses in a sexy kinda way.
 * The rules are:
 * add a dimmer view if the caller doesn't have one.
 * create an alertview and layout its subviews so that we know the frame size
 * center the alerview in the callers view
 * add the alertview to the caller as a subview
 *
 * On close: find any other alertviews
 * if there are more alert views on the caller, do not remove the dimmer view
 * animate the alertView off the screen
 * remove alertView from caller
 * if no more alertViews, remove the dimmerView
 */

#import "TSViewController.h"
#import "AlertView.h"


@interface AlertViewController : TSViewController

typedef void ((^AlertViewHandlerBlock)(AlertViewController *alertViewController, NSInteger buttonIndex));

@property (nonatomic, copy) AlertViewHandlerBlock handlerBlock;

/**
 * Add an AlertView to the caller (controller)'s view.
 * @param UIViewController controller - The view controller that wants to display an alert
 * @param NSString title - the alert title
 * @param NSString body - the alert message text
 * @param AlertViewHandlerBlock handler - the block of code to execute when a button is pressed
 * @param NSString NS_REQUIRES_NIL_TERMINATION buttonTitles - list of button titles, these get turned into buttons
 */
- (void)showForViewController:(__weak UIViewController *)controller
                    withTitle:(NSString *)title
                     withBody:(NSString *)body
                buttonHandler:(AlertViewHandlerBlock)handler
                 buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;


@end