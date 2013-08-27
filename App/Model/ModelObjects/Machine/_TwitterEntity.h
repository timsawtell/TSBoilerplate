// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct TwitterEntityAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *screen_name;
} TwitterEntityAttributes;

extern const struct TwitterEntityRelationships {
	__unsafe_unretained NSString *tweets;
} TwitterEntityRelationships;

extern const struct TwitterEntityFetchedProperties {
} TwitterEntityFetchedProperties;

@class Tweet;




@interface TwitterEntityID : NSManagedObjectID {}
@end

@interface _TwitterEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TwitterEntityID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* screen_name;



//- (BOOL)validateScreen_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *tweets;

- (NSMutableSet*)tweetsSet;





@end

@interface _TwitterEntity (CoreDataGeneratedAccessors)

- (void)addTweets:(NSSet*)value_;
- (void)removeTweets:(NSSet*)value_;
- (void)addTweetsObject:(Tweet*)value_;
- (void)removeTweetsObject:(Tweet*)value_;

@end

@interface _TwitterEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveScreen_name;
- (void)setPrimitiveScreen_name:(NSString*)value;





- (NSMutableSet*)primitiveTweets;
- (void)setPrimitiveTweets:(NSMutableSet*)value;


@end
