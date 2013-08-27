// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterEntity.m instead.

#import "_TwitterEntity.h"

const struct TwitterEntityAttributes TwitterEntityAttributes = {
	.name = @"name",
	.screen_name = @"screen_name",
};

const struct TwitterEntityRelationships TwitterEntityRelationships = {
	.tweets = @"tweets",
};

const struct TwitterEntityFetchedProperties TwitterEntityFetchedProperties = {
};

@implementation TwitterEntityID
@end

@implementation _TwitterEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TwitterEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TwitterEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TwitterEntity" inManagedObjectContext:moc_];
}

- (TwitterEntityID*)objectID {
	return (TwitterEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic screen_name;






@dynamic tweets;

	
- (NSMutableSet*)tweetsSet {
	[self willAccessValueForKey:@"tweets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"tweets"];
  
	[self didAccessValueForKey:@"tweets"];
	return result;
}
	






@end
