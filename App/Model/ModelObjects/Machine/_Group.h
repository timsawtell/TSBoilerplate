// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Group.h instead.

#import <CoreData/CoreData.h>


extern const struct GroupAttributes {
	__unsafe_unretained NSString *groupName;
} GroupAttributes;

extern const struct GroupRelationships {
	__unsafe_unretained NSString *members;
} GroupRelationships;

extern const struct GroupFetchedProperties {
} GroupFetchedProperties;

@class Member;



@interface GroupID : NSManagedObjectID {}
@end

@interface _Group : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (GroupID*)objectID;





@property (nonatomic, strong) NSString* groupName;



//- (BOOL)validateGroupName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *members;

- (NSMutableSet*)membersSet;





@end

@interface _Group (CoreDataGeneratedAccessors)

- (void)addMembers:(NSSet*)value_;
- (void)removeMembers:(NSSet*)value_;
- (void)addMembersObject:(Member*)value_;
- (void)removeMembersObject:(Member*)value_;

@end

@interface _Group (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveGroupName;
- (void)setPrimitiveGroupName:(NSString*)value;





- (NSMutableSet*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet*)value;


@end
