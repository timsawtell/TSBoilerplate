//  _Tweet.h
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tweet.h instead.

#import <Foundation/Foundation.h>
#import "ModelObject.h"


@class TwitterEntity;

@protocol _Tweet

@end

extern NSString * const kModelPropertyTweetText;

extern NSString * const kModelPropertyTweetTwitterEntity;

extern NSString * const kModelDictionaryTweetText;

extern NSString * const kModelDictionaryTweetTwitterEntity;

@interface _Tweet : ModelObject <NSCoding>


@property (nonatomic, strong) NSString* text;
@property (nonatomic, weak, readwrite) TwitterEntity *twitterEntity;


- (void)setTwitterEntity: (TwitterEntity*) twitterEntity_ settingInverse: (BOOL) setInverse;


@end
