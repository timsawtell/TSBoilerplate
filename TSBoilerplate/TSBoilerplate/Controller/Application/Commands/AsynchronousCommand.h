//
//  AsynchronousCommand.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 8/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

typedef void(^commandCompletionBlock)(NSError *error);

@interface AsynchronousCommand : Command

@property (nonatomic, copy) commandCompletionBlock commandCompletionBlock;
@property (nonatomic, assign, getter = isMultiThreaded) BOOL multiThreaded;
// these getters are used to tell NSOperationQueue that the task has actually finished
@property (nonatomic, assign, getter = isFinished) BOOL finished;
@property (nonatomic, assign, getter = isExecuting) BOOL executing;

- (void)cancel;
- (void)finish;

@end
