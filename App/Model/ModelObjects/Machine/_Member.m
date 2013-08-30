// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.m instead.

#import "_Member.h"

const struct MemberAttributes MemberAttributes = {
	.memberId = @"memberId",
	.name = @"name",
};

const struct MemberRelationships MemberRelationships = {
	.group = @"group",
};

const struct MemberFetchedProperties MemberFetchedProperties = {
};

@implementation MemberID
@end

@implementation _Member

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Member";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Member" inManagedObjectContext:moc_];
}

- (MemberID*)objectID {
	return (MemberID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"memberIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"memberId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic memberId;



- (int32_t)memberIdValue {
	NSNumber *result = [self memberId];
	return [result intValue];
}

- (void)setMemberIdValue:(int32_t)value_ {
	[self setMemberId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMemberIdValue {
	NSNumber *result = [self primitiveMemberId];
	return [result intValue];
}

- (void)setPrimitiveMemberIdValue:(int32_t)value_ {
	[self setPrimitiveMemberId:[NSNumber numberWithInt:value_]];
}





@dynamic name;






@dynamic group;

	






@end
