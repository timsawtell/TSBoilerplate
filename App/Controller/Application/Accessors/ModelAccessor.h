//
//  ModelAccessor.h
//  TSBoilerplate
//
//  Created by Suneth Mendis on 28/08/13.
//
//

#import <Foundation/Foundation.h>

@interface ModelAccessor : NSObject
+ (ModelAccessor *) sharedModelAccessor;

- (NSArray *)getAllTweets;
@end
