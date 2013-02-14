//
//  MasterEngine.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 20/12/12.
//
//

#import "MKNetworkEngine.h"

typedef void(^_serviceCompletionBlock)(id result, NSError *error); // this is for the class to use, not the programmer

@interface MasterEngine : MKNetworkEngine

- (void)executeOperation:(MKNetworkOperation *)operation withCompletion:(_serviceCompletionBlock)completionBlock;

@end
