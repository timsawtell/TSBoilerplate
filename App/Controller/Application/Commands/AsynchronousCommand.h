/*
 Copyright (c) 2013 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "Command.h"

typedef void(^commandCompletionBlock)(NSError *error);

/*
 * A command (which is an NSOperation) which will be put onto an NSOperationQueue by TSCommandRunner. The queue will either be a differnet thread to main or the main thread based on multiThreaded
 */

@interface AsynchronousCommand : Command

/** The block of code to run after this command has finished */
@property (nonatomic, copy) commandCompletionBlock commandCompletionBlock;

/** if YES then SPCommandRunner will put this command onto a shared NSOperationQueue (not main). If NO then it will go onto [NSOperationQueue mainQueue] */
@property (nonatomic, assign, getter = isMultiThreaded) BOOL multiThreaded;

/** A reference to the parent command that owns this command. */
@property (nonatomic, strong) AsynchronousCommand *parentCommand;

/** these getters are used to tell NSOperationQueue that the task has actually finished */
@property (nonatomic, assign, getter = isFinished) BOOL finished;

/** these getters are used to tell NSOperationQueue that the task is executing */
@property (nonatomic, assign, getter = isExecuting) BOOL executing;

/** the task id for when this is backgrounded **/
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundUpdateTaskId;

/** allows the command to run for up to 10 while the app is in the background */
@property (nonatomic) BOOL isBackgroundExecutable;

/** Add a command as a subcommand
 * @param Command command - the command to add as a subcommand
 */
- (void)addSubCommand:(Command *)command;

/** Remove a subcommand
 * @param Command command - the command to remove as a subcommand
 */
- (void)removeSubCommand:(Command *)command;

/** the array of subCommands for this command*/
- (NSArray *)subCommands;

/** Tell the command to cancel (won't guarantee the command will stop dead in its tracks) */
- (void)cancel;

/** Finish processing and let the NSOperationQueue remove this command */
- (void)finish;


@end
