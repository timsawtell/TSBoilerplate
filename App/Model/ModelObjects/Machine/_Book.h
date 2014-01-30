//  _Book.h
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.h instead.

#import <Foundation/Foundation.h>
#import "ModelObject.h"



@protocol _Book

@end

extern NSString * const kModelPropertyBookAuthor;
extern NSString * const kModelPropertyBookBlurb;
extern NSString * const kModelPropertyBookPrice;
extern NSString * const kModelPropertyBookTitle;


extern NSString * const kModelDictionaryBookAuthor;
extern NSString * const kModelDictionaryBookBlurb;
extern NSString * const kModelDictionaryBookPrice;
extern NSString * const kModelDictionaryBookTitle;


@interface _Book : ModelObject <NSCoding>


@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* blurb;
@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSString* title;


@end
