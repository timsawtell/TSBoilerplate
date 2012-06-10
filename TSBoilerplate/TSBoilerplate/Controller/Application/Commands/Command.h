//
//  Command.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSOperation

@property (nonatomic, strong) NSMutableArray *subCommands;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL saveModel; //flag to save the model, intended to be used at the end of the execute method. Sublasses set this.

- (void)execute;

@end
