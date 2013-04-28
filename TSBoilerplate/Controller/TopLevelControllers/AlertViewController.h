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