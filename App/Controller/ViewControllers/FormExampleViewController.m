//
//  FormExampleViewController.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 16/08/13.
//
//

#import "FormExampleViewController.h"
#import "ProgressDemoCommand.h"

@interface FormExampleViewController ()

@end

@implementation FormExampleViewController

- (IBAction)showProgressTouched:(id)sender
{
    [self showActivityScreenWithMessage:@"Show us ya progress" animated:YES withProgressView:YES];
    
    __weak typeof(self) weakSelf = self;
    MKNKProgressBlock progressBlock = ^(double progress) {
        if (nil == weakSelf) return;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.activityProgressView setProgress:progress animated:YES];
    };
    
    commandCompletionBlock completionBlock = ^(NSError *error) {
        if (nil == weakSelf) return;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideActivityScreen];
    };
    
    ProgressDemoCommand *demoCmd = [ProgressDemoCommand new];
    demoCmd.progressBlock = progressBlock;
    demoCmd.commandCompletionBlock = completionBlock;
    [[TSCommandRunner sharedCommandRunner] executeCommand:demoCmd];
}
@end
