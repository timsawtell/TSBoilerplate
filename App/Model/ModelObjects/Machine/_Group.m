// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.m instead.

#import "_Group.h"

const struct GroupAttributes GroupAttributes = {
	.groupName = @"groupName",
};

const struct GroupRelationships GroupRelationships = {
	.members = @"members",
};

const struct GroupFetchedProperties GroupFetchedProperties = {
};

@implementation GroupID
@end

@implementation _Group

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Group";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Group" inManagedObjectContext:moc_];
}

- (GroupID*)objectID {
	return (GroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic groupName;






@dynamic members;

	
- (NSMutableSet*)membersSet {
	[self willAccessValueForKey:@"members"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];
  
	[self didAccessValueForKey:@"members"];
	return result;
}
	






@end
