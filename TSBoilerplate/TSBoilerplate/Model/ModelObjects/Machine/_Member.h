// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.h instead.

#import <CoreData/CoreData.h>


extern const struct MemberAttributes {
	__unsafe_unretained NSString *name;
} MemberAttributes;

extern const struct MemberRelationships {
	__unsafe_unretained NSString *group;
} MemberRelationships;

extern const struct MemberFetchedProperties {
} MemberFetchedProperties;

@class Group;



@interface MemberID : NSManagedObjectID {}
@end

@interface _Member : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MemberID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Group *group;

//- (BOOL)validateGroup:(id*)value_ error:(NSError**)error_;





@end

@interface _Member (CoreDataGeneratedAccessors)

@end

@interface _Member (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (Group*)primitiveGroup;
- (void)setPrimitiveGroup:(Group*)value;


@end
