//
//  TSCommandRunner.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"
#import "AsynchronousCommand.h"

@interface TSCommandRunner : NSObject

+ (TSCommandRunner *)sharedCommandRunner;
- (void)executeSynchronousCommand:(Command *)command;
- (void)executeAsynchronousCommand:(AsynchronousCommand *)asynchornousCommand;

@end
