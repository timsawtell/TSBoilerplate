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

#import "Model.h"
#import "TestModel.h"
#import "NSFileManager+DirectoryLocations.h"
// Edit Scheme, Run setting, Arguments tab, environment variables. Preprocessor macros do not work when the main target is built before the test target.
NSString * const kModelKey = @"model";

@implementation Model

#pragma mark - Data

+ (NSString*)savedDataPath
{
    NSString *appSupport = [[NSFileManager defaultManager] applicationSupportDirectory];
    return [appSupport stringByAppendingPathComponent: kModelSavedDataFileName];
}

+ (Model*)savedModel
{
    NSData *savedData = [NSData dataWithContentsOfFile:[Model savedDataPath]];
    Model *model = [CommandCenter securelyUnarchiveData:savedData withClass:[Model class] withKey:kModelKey];
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
            if (TestingModel()) {
                sharedModel = [TestModel new];
            } else {
                sharedModel = [Model savedModel];
            }
        }
    }
    return sharedModel;
}

- (void)save
{
    @try {
        @synchronized(self)
        {
            NSData *data = [CommandCenter securelyArchiveRootObject:self withKey:kModelKey];
            if (![data writeToFile:[Model savedDataPath] atomically:YES]) {
                [NSException raise:@"Model did not save" format:@"The data model did not save"];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exeption in save method: %@", exception);
    }
}


#pragma mark - initializing

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.book = [aDecoder decodeObjectOfClass:[Book class] forKey:@"book"];
        // if you have a collection of model objects as a property on this class, you must decode like this
        // assume you have an array of books
        // self.books = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [Book class], nil] forKey:@"books"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.book forKey:@"book"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
