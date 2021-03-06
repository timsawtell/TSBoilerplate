/*
 Copyright (c) 2014 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "CommandCenter.h"

@implementation CommandCenter

+ (NSData *)securelyArchiveRootObject:(id)object withKey:(NSString *)key
{
    //Use secure encoding because files could be transfered from anywhere by anyone
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    //Ensure that secure encoding is used
    [archiver setRequiresSecureCoding:YES];
    @try {
        [archiver encodeObject:object forKey:key];
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    } @finally {
        [archiver finishEncoding];
    }
    
    return data;
}

+ (id)securelyUnarchiveData:(NSData *)data
                  withClass:(Class)class
                    withKey:(NSString *)key
{
    id returnObject = nil;
    if (nil == data) return nil;
    @try {
        //Use secure encoding because files could be transfered from anywhere by anyone
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //Ensure that secure encoding is used
        [unarchiver setRequiresSecureCoding:YES];
        returnObject = [unarchiver decodeObjectOfClass:class forKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@ failed to unarchive PicketList: %@", NSStringFromSelector(_cmd), exception);
    }
    
    return returnObject;
}

@end
