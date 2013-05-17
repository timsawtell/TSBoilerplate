//  _TwitterEntity.h
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TwitterEntity.h instead.

#import <Foundation/Foundation.h>
#import "ModelObject.h"


@class Tweet;

@protocol _TwitterEntity

@end

extern NSString * const kModelPropertyTwitterEntityName;
extern NSString * const kModelPropertyTwitterEntityScreen_name;

extern NSString * const kModelPropertyTwitterEntityTweets;

extern NSString * const kModelDictionaryTwitterEntityName;
extern NSString * const kModelDictionaryTwitterEntityScreen_name;

extern NSString * const kModelDictionaryTwitterEntityTweets;

@interface _TwitterEntity : ModelObject <NSCoding>
{
	NSString* name;
	NSString* screen_name;
	NSSet *tweets;
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* screen_name;@property (nonatomic, strong, readonly) NSSet *tweets;

- (void)addTweetsObject:(Tweet*)value_ settingInverse: (BOOL) setInverse;
- (void)addTweetsObject:(Tweet*)value_;
- (void)removeAllTweets;
- (void)removeTweetsObject:(Tweet*)value_ settingInverse: (BOOL) setInverse;
- (void)removeTweetsObject:(Tweet*)value_;

@end
