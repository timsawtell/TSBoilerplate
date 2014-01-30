//
//  FormExampleViewController.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 16/08/13.
//
//

#import "FormExampleViewController.h"
#import "iTunesSearchCommand.h"

@interface FormExampleViewController ()

@end

@implementation FormExampleViewController

- (IBAction)iTunesSearchTouched:(id)sender
{
    __weak typeof(self) weakSelf = self;
    commandCompletionBlock completionBlock = ^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideActivityScreen];
        if (nil != error) {
            AlertViewController *avc = [AlertViewController new];
            [avc showForViewController:strongSelf
                             withTitle:@"Uh Oh"
                              withBody:[error localizedDescription]
                         buttonHandler:nil
                          buttonTitles:@"Thanks", nil];
            return;
        }
        
        [strongSelf performSegueWithIdentifier:kFormToiTunesSegue sender:strongSelf];
    };
    
    [self showActivityScreen];
    iTunesSearchCommand *searchCmd = [iTunesSearchCommand new];
    searchCmd.commandCompletionBlock = completionBlock;
    [[TSCommandRunner sharedCommandRunner] executeCommand:searchCmd];
    
}
@end
