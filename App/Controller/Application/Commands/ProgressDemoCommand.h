//
//  ProgressDemoCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 15/10/13.
//
//

#import "AsynchronousCommand.h"

@interface ProgressDemoCommand : AsynchronousCommand

@property (nonatomic, copy) MKNKProgressBlock progressBlock;

@end
