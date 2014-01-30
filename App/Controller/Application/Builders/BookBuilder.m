//
//  BookBuilder.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 31/01/2014.
//
//

#import "BookBuilder.h"

@implementation BookBuilder

+ (Book *)objFromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    Book *book = [Book new];
    [BookBuilder updateObj:book fromJSON:json];
    return book;
}

+ (void)updateObj:(Book *)book fromJSON:(id)json
{
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *jsonDict = (NSDictionary *)json;
    ASSIGN_NOT_NIL(book.author, [jsonDict valueForKey:@"artistName"]);
    ASSIGN_NOT_NIL(book.title, [jsonDict valueForKey:@"trackCensoredName"]);
    NSNumber *bookPrice;
    ASSIGN_NOT_NIL(bookPrice, [jsonDict valueForKey:@"price"]);
    book.price = [NSString stringWithFormat:@"%@.02", bookPrice];
    ASSIGN_NOT_NIL(book.blurb, [jsonDict valueForKey:@"description"]);
}

@end
