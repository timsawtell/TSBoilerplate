//  AlertViewController.m
//  BrisbaneAirport
//  Created by Local Dev User on 17/10/12.
//  Copyright (c) 2012 Speedwell. All rights reserved.

#import "AlertViewController.h"
#import <objc/runtime.h>

static NSString * const kUIAlertViewBlocksAssociationKey = @"UIAlertViewBlocksAssociationKey";
static NSInteger const kDimmerViewTag = 999999990;

@interface AlertViewController()
/** Need a (non retaining) reference back to the owner so that this class can remove the dimmer view if there are no more alertViews to show. */
@property (nonatomic, weak) UIViewController *owner;
@end

@implementation AlertViewController

@synthesize owner, handlerBlock;

#pragma mark - View Lifecycle

- (void)showForViewController:(__weak UIViewController *)controller
                    withTitle:(NSString *)title
                     withBody:(NSString *)body
                buttonHandler:(AlertViewHandlerBlock) handler
                 buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    AlertView *alertView = (AlertView *)self.view;
    alertView.titleLabel.text = title;
    alertView.contentLabel.text = body;
    alertView.alpha = 0;
    self.owner = controller;
    self.handlerBlock = handler;
    self.view.autoresizesSubviews = NO; // we let the container view do the auto resizing
    
    BOOL foundExistingDimmerView = NO;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView.tag == kDimmerViewTag) {
            foundExistingDimmerView = YES;
            break;
        }
    }
    
    UIView *dimmerView = [[UIView alloc] initWithFrame:controller.view.bounds];
    if (!foundExistingDimmerView) {
        // add a light gray see through view to cover the view of the owner.
        dimmerView.backgroundColor = [UIColor blackColor];
        dimmerView.alpha = 0; // will animate this up to 0.7
        dimmerView.tag = kDimmerViewTag;
        dimmerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [controller.view addSubview:dimmerView];
    }
    
    // add a shadow
    alertView.layer.shadowColor = [UIColor whiteColor].CGColor;
    alertView.layer.shadowRadius = 2.0f;
    alertView.layer.shadowOpacity = 0.15f;
    alertView.layer.shadowOffset = CGSizeMake(4.0f, 4.0f);
    
    //add the buttons
    NSMutableArray *buttonsArray = [NSMutableArray array];
    
    NSString *eachItem;
    va_list argumentList;
    if (buttonTitles) {
        [buttonsArray addObject: buttonTitles];
        va_start(argumentList, buttonTitles);
        while((eachItem = va_arg(argumentList, NSString*))) {
            [buttonsArray addObject: eachItem];
        }
        va_end(argumentList);
    }
    
    //add the button titles as new buttons to the buttonsView on the alertView
    NSInteger buttonsCount = [buttonsArray count];
    for (NSInteger i = 0; i < buttonsCount; i++) {
        NSString *buttonTitle = [buttonsArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitle:buttonTitle forState:UIControlStateHighlighted];
        button.titleLabel.font = [Appearances fontForButtonsOnAlertView];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.tag = i;
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button addTarget:self action:@selector(closeTouched:) forControlEvents:UIControlEventTouchUpInside];
        [alertView.buttonsView addSubview:button];
    }
    
    // add self as a child view contoller to controller. This is an arc / ios 6 thing and ensures that this instance is not dealloc'd
    [controller addChildViewController:self];
    [controller.view addSubview:alertView];
    [alertView layoutSubviews]; // need to do this so that we know how big the alert view is.
    alertView.frame = CGRectSetHeight(alertView.frame, alertView.containerView.frame.size.height);
    if (alertView.containerView.frame.size.width > alertView.frame.size.width) {
        alertView.frame = CGRectSetWidth(alertView.frame, alertView.containerView.frame.size.width);
    }
    // make sure that the alert view will always be visible so that the user can close the alert
    if (alertView.frame.size.height > controller.view.frame.size.height) {
        alertView.frame = CGRectSetHeight(alertView.frame, controller.view.frame.size.height - 44.0f);
    }
    alertView.frame = CGRectCenteredInsideRect(controller.view.frame, alertView.frame);
    [UIView animateWithDuration:0.3 animations:^{
        dimmerView.alpha = 0.7;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            alertView.alpha = 1;
        }];
    }];
}

- (void)closeTouched:(id)sender
{
    // find any other alertViews. Rules are: only remove the dimmerView if there are no other alertViews showing on self.owner
    BOOL foundOtherAlertViews = NO;
    for (UIView *testView in self.owner.view.subviews) {
        if ([testView isKindOfClass:[self.view class]] && testView != self.view) {
            foundOtherAlertViews = YES;
            break;
        }
    }
    
    // find the dimmer view
    UIView *dimmerView = nil;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView.tag == kDimmerViewTag) {
            dimmerView = testView;
            break;
        }
    }
    
    UIView *selfRef = nil;
    for (UIView *testView in self.owner.view.subviews) {
        if (testView == self.view) {
            selfRef = testView;
            break;
        }
    }
    
    // animate the alert view off the screen
    if (nil != selfRef) {
        [UIView animateWithDuration:0.8f animations:^{
            selfRef.alpha = 0.0f;
            if (nil != dimmerView && !foundOtherAlertViews) {
                dimmerView.alpha = 0.0f;
            }
        } completion:^(BOOL finished) {
            [selfRef removeFromSuperview];
            if (nil != dimmerView && !foundOtherAlertViews) {
                [dimmerView removeFromSuperview];
            }
            // finally remove self from the caller. (the counterpart is [controller addChildViewController:self];)
            [self removeFromParentViewController];
            if (self.handlerBlock && [sender respondsToSelector:@selector(tag)]) {
                self.handlerBlock(self, [sender tag]);
            }
        }];
    } else {
        [self removeFromParentViewController];
        if (self.handlerBlock && [sender respondsToSelector:@selector(tag)]) {
            self.handlerBlock(self, [sender tag]);
        }
    }
}
@end