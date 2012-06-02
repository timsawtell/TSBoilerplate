// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.m instead.

#import "_Member.h"

const struct MemberAttributes MemberAttributes = {
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

- (id)init
{
	if((self = [super init]))
	{
		
		
	}
	
	return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    if ([[super class] instancesRespondToSelector: @selector(initWithCoder:)]) {
        self = [super initWithCoder: aDecoder];
    } else {
        self = [super init];
    }
    if (self) {
        
        self.name = [aDecoder decodeObjectForKey: @"name"];
        
        
        self.group = [aDecoder decodeObjectForKey: @"group"];
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [super encodeWithCoder: aCoder];
    
    [aCoder encodeObject: self.name forKey: @"name"];
    
    [aCoder encodeObject: self.group forKey: @"group"];
    
}

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
	

	return keyPaths;
}




@dynamic name;






@dynamic group;

	






@end
