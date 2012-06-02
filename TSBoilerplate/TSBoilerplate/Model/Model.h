//
//  Model.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 2/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Group.h"
#import "Member.h"

@interface Model : NSObject

@property (nonatomic, strong) Group *group;
+ (Model*) sharedModel;
- (void)save;
@end
