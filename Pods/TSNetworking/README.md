TSNetworking
============

Because I wanted to see how NSURLSession worked.

## Using cocoapods?

    platform :ios, '7.0'
    pod 'TSNetworking'


## AppDelegate.m

Be sure to add this to your app delegate. It will ensure that your uploads/downloads that finish when the app has been suspended run their completion blocks.


    #import "TSNetworking.h"
    
    - (void)application:(UIApplication *)application
    handleEventsForBackgroundURLSession:(NSString *)identifier
    completionHandler:(void (^)())completionHandler
    {
      [TSNetworking backgroundSession].sessionCompletionHandler = completionHandler;
    }


## Initialising:

    [[TSNetworking foregroundSession] setBaseURLString:kBaseURLString];
    [[TSNetworking foregroundSession] setBasicAuthUsername:nil withPassword:nil];
    [[TSNetworking foregroundSession] addSessionHeaders:@{@"all":@"nightlong"}]; // sticks around forever, used in each request
These settings last for the app's run lifetime

## Maintaining:

    [[TSNetworking foregroundSession] removeAllSessionHeaders];

## Which one to use?
    [TSNetworking foregroundSession] /* for all your regular GETs, POSTs. You are given an NSObject as the result. 
    OR for uploading NSData in the foreground.  */
    - OR -
    [TSNetworking backgroundSession] /* for all your background downloads and (local NSURL) uploads. Uses funky new NSURLSession features to run while your apps if minimized, no need to pause and serialise your downloads on applicationDidEnterBackground */

## Warning

The success and error blocks are executed on whatever thread apple decides.
I suggest if you're doing UI changes in these blocks that you dispatch_async and get the main queue.
Warning for young players: never reference self inside a block, use this style to avoid retain cycles
    
    __weak typeof(self) weakSelf = self;
    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sendAMessage];
    };

## Get:

    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        NSLog(@"We got ourselves a: %@", resultObject);
    };
    
    TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        switch (error.code) {
            case 401:
                NSLog(@"Mannn");
                break;
                
            default:
                break;
        }
    };

    [[TSNetworking foregroundSession] performDataTaskWithRelativePath:nil
                                                       withMethod:HTTP_METHOD_GET
                                                   withParameters:nil
                                             withAddtionalHeaders:@{@"Content-Type":@"application/json"}
                                                      withSuccess:successBlock
                                                        withError:errorBlock];

## Post:

    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        // resultObject will probably be a JSON dictionary 
    };
    
    TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        NSLog(@"%@", error.localizedDescription); // tells you what the problem was, i.e. offline
    };
    
    [[TSNetworking foregroundSession] performDataTaskWithRelativePath:nil
                                                       withMethod:HTTP_METHOD_POST
                                                   withParameters:@{@"key": @"value"}
                                             withAddtionalHeaders:nil
                                                      withSuccess:successBlock
                                                        withError:errorBlock];

## Download:

    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        // sweet, resultObject is a (local) NSURL for what we just downloaded
    };
    
    TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        //same old handling
    };
    
    TSNetworkDownloadTaskProgressBlock progressBlock = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"Download written: %lld, total written: %lld, total expected: %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    NSURLSessionDownloadTask *task = [[TSNetworking backgroundSession] downloadFromFullPath:@"https://archive.org/download/1mbFile/1mb.mp4"
                                                                                     toPath:destinationPath
                                                                       withAddtionalHeaders:nil
                                                                          withProgressBlock:progressBlock
                                                                                withSuccess:successBlock
                                                                                  withError:errorBlock];
                                                 
## Upload:

    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ourLord" ofType:@"jpg"];
    
    TSNetworkSuccessBlock successBlock = ^(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response) {
        //resultObject is whatever the server responded with, could be JSON, HTML, whatever
    };
    
    TSNetworkErrorBlock errorBlock = ^(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response) {
        //same old handling
    };
    
    TSNetworkDownloadTaskProgressBlock progressBlock = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"uploaded: %lld, total written: %lld, total expected: %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    
    NSURLSessionUploadTask *uploadTask = [[TSNetworking backgroundSession] uploadInBackgroundFromLocalPath:sourcePath
                                                                                                    toPath:kMultipartUpload
                                                                                      withAddtionalHeaders:nil
                                                                                         withProgressBlock:progressBlock
                                                                                               withSuccess:successBlock
                                                                                                 withError:errorBlock];

    // or

    NSFileManager *fm = [NSFileManager new];
    NSData *data = [fm contentsAtPath:sourcePath];
    
    [[TSNetworking foregroundSession] uploadInForegroundData:data
                                                  toPath:kMultipartUpload
                                    withAddtionalHeaders:nil
                                       withProgressBlock:progressBlock
                                             withSuccess:successBlock
                                               withError:errorBlock];