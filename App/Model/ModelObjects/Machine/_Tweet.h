// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.

#import <CoreData/CoreData.h>


extern const struct TweetAttributes {
	__unsafe_unretained NSString *text;
} TweetAttributes;

extern const struct TweetRelationships {
	__unsafe_unretained NSString *twitterEntity;
} TweetRelationships;

extern const struct TweetFetchedProperties {
} TweetFetchedProperties;

@class TwitterEntity;



@interface TweetID : NSManagedObjectID {}
@end

@interface _Tweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TweetID*)objectID;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) TwitterEntity *twitterEntity;

//- (BOOL)validateTwitterEntity:(id*)value_ error:(NSError**)error_;





@end

@interface _Tweet (CoreDataGeneratedAccessors)

@end

@interface _Tweet (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (TwitterEntity*)primitiveTwitterEntity;
- (void)setPrimitiveTwitterEntity:(TwitterEntity*)value;


@end
