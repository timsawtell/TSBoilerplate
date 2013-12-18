//
//  SubcommandsTest.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 18/12/2013.
//
//

#import "SubcommandsTest.h"
#import "AsynchronousCommand.h"
#import "TSCommandRunner.h"

@implementation SubcommandsTest

/**
 * Command C has subcommand B
 * Command B has subcommand A
 * C finishes, and when it does it cancels B
 * B should not run
 * B should be canceled, and in doing so, A should be canceled
 */
- (void)testSubCommands
{
    AsynchronousCommand *a = [AsynchronousCommand new];
    AsynchronousCommand *b = [AsynchronousCommand new];
    AsynchronousCommand *c = [AsynchronousCommand new];
    
    c.commandCompletionBlock = ^(NSError *error) {
        [b cancel];
    };;
    
    [c addSubCommand:b];
    [b addSubCommand:a];
    
    [[TSCommandRunner sharedCommandRunner] executeCommand:c];

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [c finish];
    });
    
    delayInSeconds = 2.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        XCTAssertTrue(b.isCancelled, @"b wasn't canceled");
        XCTAssertTrue(a.isCancelled, @"a wasn't canceled");
        dispatch_semaphore_signal(self.semaphore);
    });
    
    while (dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

@end
