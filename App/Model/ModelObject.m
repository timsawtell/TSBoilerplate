/*
 Copyright 2011 Marko Karppinen & Co. LLC.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 ModelObject.m
 mogenerator / PONSO
 Created by Nikita Zhuk on 22.1.2011.
 */

#import "ModelObject.h"

@implementation ModelObject

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super init];
    if (self) {
        // Superclass implementation:
        // If we add ivars/properties, here's where we'll load them
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    // Superclass implementation:
    // If we add ivars/properties, here's where we'll save them
}

+ (id)modelObjectWithClass:(Class)aClass FromObject:(ModelObject *)object
{
    if (object == nil || ![aClass isSubclassOfClass:[ModelObject class]]) {
        return [[aClass alloc] init];
    } else {
        NSDictionary *dict = [object dictionaryRepresentation];
        ModelObject *newObject = [[aClass alloc] initWithDictionaryRepresentation:dict];
        return newObject;
    }
}

+ (id)modelObjectFromObject:(ModelObject *)object
{
    return [self modelObjectWithClass:[self class] FromObject:object];
}


- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
	if((self = [super init]))
	{
		self.sourceDictionaryRepresentation = dictionary;
	}
	
	return self;
}

- (NSDictionary *)dictionaryRepresentation
{
	return [NSDictionary dictionary];
}

+ (NSSet *)dictionaryRepresentationKeys
{
    return [NSSet set];
}

- (void)awakeFromDictionaryRepresentationInit
{
	self.sourceDictionaryRepresentation = nil;
}

- (BOOL) isPopulated
{
    return YES;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
	// Note: ModelObject is not autoreleased because we are in copy method.
	ModelObject *copy = [[[self class] alloc] initWithDictionaryRepresentation:[self dictionaryRepresentation]];
	[copy awakeFromDictionaryRepresentationInit];
	
	return copy;
}

@synthesize sourceDictionaryRepresentation;

@end


@implementation NSMutableDictionary (PONSONSMutableDictionaryAdditions)

- (void)setObjectIfNotNil:(id)obj forKey:(NSString *)key
{
    @synchronized(self)
    {
        if(obj == nil)
            return;
        
        [self setObject:obj forKey:key];
    }
}

@end
