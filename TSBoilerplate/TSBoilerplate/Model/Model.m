//
//  Model.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "NSFileManager+DirectoryLocations.h"

@implementation Model

@synthesize group;

#pragma mark - Data

+ (NSString*) savedDataPath
{
    NSString *appSupport = [[NSFileManager defaultManager] applicationSupportDirectory];
    return [appSupport stringByAppendingPathComponent: kModelSavedDataFileName];
}

+ (Model*) savedModel
{
    Model *model = [NSKeyedUnarchiver unarchiveObjectWithFile: [Model savedDataPath]];
    if (!model) {
        return [Model new];
    }
    return model;
}

+ (Model*) sharedModel
{
    static Model* sharedModel = nil;
    @synchronized(self) {
        if (sharedModel == nil) {
            sharedModel = [Model savedModel];
        }
    }
    return sharedModel;
}

- (void) save
{
    @try {
        @synchronized(self)
        {
            [NSKeyedArchiver archiveRootObject: self toFile: [Model savedDataPath]];
        }
    } @catch (NSException *exception) {
    }
}

#pragma mark - initializing

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.group = [aDecoder decodeObjectForKey:@"group"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.group forKey:@"group"];
}

@end
