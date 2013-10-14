//
//  ProgressDemoCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 15/10/13.
//
//

#import "ProgressDemoCommand.h"

@implementation ProgressDemoCommand

- (void)execute
{
    if (NULL != self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(0.1f);
        });
    }
    
    sleep(1);
    
    if (NULL != self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(0.3f);
        });
    }
    
    sleep(1);
    
    if (NULL != self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(0.7f);
        });
    }
    
    sleep(1);
    
    if (NULL != self.progressBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock(1.0f);
        });
    }
    
    
    [self finish];
}

@end
