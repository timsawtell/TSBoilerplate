// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.m instead.

#import "_Tweet.h"

const struct TweetAttributes TweetAttributes = {
	.text = @"text",
};

const struct TweetRelationships TweetRelationships = {
	.twitterEntity = @"twitterEntity",
};

const struct TweetFetchedProperties TweetFetchedProperties = {
};

@implementation TweetID
@end

@implementation _Tweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc_];
}

- (TweetID*)objectID {
	return (TweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic text;






@dynamic twitterEntity;

	






@end
