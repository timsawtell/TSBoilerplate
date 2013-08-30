//
//  ModelAccessor.m
//  TSBoilerplate
//
//  Created by Suneth Mendis on 28/08/13.
//
//

#import "ModelAccessor.h"

@implementation ModelAccessor

+ (ModelAccessor *) sharedModelAccessor {
    __strong static ModelAccessor *sharedModelAccessor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedModelAccessor = [ModelAccessor new];
    });
    return sharedModelAccessor;
}


- (NSArray *)getAllTweets {
    return [Tweet MR_findAllInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}

@end
