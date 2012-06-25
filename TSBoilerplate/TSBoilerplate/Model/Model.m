/*
 Copyright (c) 2012 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 IN THE SOFTWARE.
 */

#import "Model.h"
#import "NSFileManager+DirectoryLocations.h"
#import "Constants.h"

@implementation Model

@synthesize group;

#pragma mark - Data

+ (NSString*)savedDataPath
{
    NSString *appSupport = [[NSFileManager defaultManager] applicationSupportDirectory];
    return [appSupport stringByAppendingPathComponent: kModelSavedDataFileName];
}

+ (Model*)savedModel
{
    Model *model = [NSKeyedUnarchiver unarchiveObjectWithFile: [Model savedDataPath]];
    if (!model) {
        return [Model new];
    }
    return model;
}

+ (Model*)sharedModel
{
    static Model* sharedModel = nil;
    @synchronized(self) {
        if (sharedModel == nil) {
            sharedModel = [Model savedModel];
        }
    }
    return sharedModel;
}

+ (void)resetModel
{
    NSString *path = [[self class] savedDataPath];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
}

- (void)save
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
