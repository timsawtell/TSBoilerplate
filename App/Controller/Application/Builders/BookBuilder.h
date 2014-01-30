//
//  BookBuilder.h
//  TSBoilerplate
//
//  Created by Tim Sawtell on 31/01/2014.
//
//

#import <Foundation/Foundation.h>

@interface BookBuilder : NSObject

+ (Book *)objFromJSON:(id)json;
+ (void)updateObj:(Book *)tweet fromJSON:(id)json;

@end
