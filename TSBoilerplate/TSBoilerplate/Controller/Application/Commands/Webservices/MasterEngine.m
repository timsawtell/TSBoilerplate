//
//  MasterEngine.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import "MasterEngine.h"

@implementation MasterEngine

- (void)executeOperation:(MKNetworkOperation *)operation withCompletion:(_serviceCompletionBlock)completionBlock
{
    MKNKResponseBlock responseBlock = ^(MKNetworkOperation *completedOperation) {
        // loop through the JSON to build up a TwitterEntity object for each Tweet object. Add the Tweet to the array in the completion block
        id jsonResponse = [completedOperation responseJSON];
        completionBlock(jsonResponse, nil); // call the completion block
    };
    
    MKNKErrorBlock errorBlock = ^(NSError *error) {
        completionBlock(nil, error); // call the completion block
    };
    
    [operation onCompletion:responseBlock onError:errorBlock];
    [self enqueueOperation:operation];
}

@end
