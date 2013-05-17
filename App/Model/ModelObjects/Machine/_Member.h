//  _Member.h
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.h instead.

#import <Foundation/Foundation.h>
#import "ModelObject.h"


@class Group;

@protocol _Member

@end

extern NSString * const kModelPropertyMemberMemberId;
extern NSString * const kModelPropertyMemberName;

extern NSString * const kModelPropertyMemberGroup;

extern NSString * const kModelDictionaryMemberMemberId;
extern NSString * const kModelDictionaryMemberName;

extern NSString * const kModelDictionaryMemberGroup;

@interface _Member : ModelObject <NSCoding>
{
	NSNumber* memberId;
	NSString* name;
	
	Group *group;
}

@property (nonatomic, strong) NSNumber* memberId;@property int32_t memberIdValue;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign, readwrite) Group *group;


- (void)setGroup: (Group*) group_ settingInverse: (BOOL) setInverse;


@end
