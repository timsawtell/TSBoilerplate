//
//  iTunesSearchCommand.m
//  TSBoilerplate
//
//  Created by Tim Sawtell on 19/12/2013.
//
//

#import "iTunesSearchCommand.h"
#import "BookBuilder.h"

@implementation iTunesSearchCommand

- (void)execute
{
    __weak typeof(self) weakSelf = self;
    
    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        if (nil == weakSelf) return;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if(strongSelf.isCancelled) {
            [strongSelf finish];
            return;
        }
        
        NSError *error;
        NSDictionary *resultDictionay = [NSJSONSerialization JSONObjectWithData: [(NSString *)resultObject dataUsingEncoding:NSUTF8StringEncoding]
                                                                        options: NSJSONReadingMutableContainers
                                                                          error: &error];
        
        if (nil != error) {
            strongSelf.error = [NSError errorWithDomain:NSURLErrorDomain withCode:NSURLErrorCannotParseResponse withText:kUnableToParseMessageText];
            [strongSelf finish];
            return;
        }
        
        NSNumber *resultCount;
        ASSIGN_NOT_NIL(resultCount, [resultDictionay valueForKey:@"resultCount"]);
        if (resultCount.integerValue <= 0 ) {
            strongSelf.error = [NSError errorWithDomain:NSURLErrorDomain withCode:NSURLErrorCannotParseResponse withText:@"No results found"];
            [strongSelf finish];
            return;
        }
        
        NSArray *resultsArray;
        NSDictionary *bookDict;
        ASSIGN_NOT_NIL(resultsArray, [resultDictionay valueForKey:@"results"]);
        if (resultsArray.count > 0) {
            bookDict = [resultsArray objectAtIndex:0];
        }
        // phew finally we have the json
        Book *book = [BookBuilder objFromJSON:bookDict];
        [Model sharedModel].book = book;
        
        [strongSelf finish];
    };
    
     TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        if (nil == weakSelf) return;
         __strong typeof(weakSelf) strongSelf = weakSelf;
         strongSelf.error = error;
         [strongSelf finish];
         return;
     };
    [[TSNetworking foregroundSession] setBaseURLString:@"https://itunes.apple.com"];
    [[TSNetworking foregroundSession] performDataTaskWithRelativePath:@"/lookup"
                                                           withMethod:HTTP_METHOD_GET
                                                       withParameters:@{@"isbn" : @"055389692X"}
                                                 withAddtionalHeaders:nil
                                                          withSuccess:successBlock
                                                            withError:errorBlock];
}

@end
