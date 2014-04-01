/*
 Copyright (c) 2013 Tim Sawtell
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <AFSecurityPolicy.h>

#define ASSIGN_NOT_NIL(property, val) ({id __val = (val); if (__val != [NSNull null] && __val != nil) { property = val;}})
typedef void(^TSNetworkSuccessBlock)(NSObject *resultObject, NSMutableURLRequest *request, NSURLResponse *response);
typedef void(^TSNetworkErrorBlock)(NSObject *resultObject, NSError *error, NSMutableURLRequest *request, NSURLResponse *response);
typedef void(^TSNetworkDownloadTaskProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void(^TSNetworkUploadTaskProgressBlock)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);

typedef enum {
    HTTP_METHOD_POST = 0,
    HTTP_METHOD_GET,
    HTTP_METHOD_PUT,
    HTTP_METHOD_HEAD,
    HTTP_METHOD_DELETE,
    HTTP_METHOD_TRACE,
    HTTP_METHOD_CONNECT,
    HTTP_METHOD_PATCH,
} HTTP_METHOD;


@interface TSNetworking : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy; //The security policy used by created request operations to evaluate server trust for secure connections.

@property (nonatomic, strong) NSURLSession *sharedURLSession;

@property (copy) void (^sessionCompletionHandler)(); // For your AppDelegate to run when it gets notified of application:handleEventsForBackgroundURLSession:completionHandler

+ (TSNetworking*)foregroundSession; // for regular get / post requests 

+ (TSNetworking *)backgroundSession; // for uploads and downloads

- (void)setBaseURLString:(NSString *)baseURLString;

- (void)setBasicAuthUsername:(NSString *)username
                withPassword:(NSString *)password;

- (void)addSessionHeaders:(NSDictionary *)headers;

- (void)removeAllSessionHeaders;

- (NSUInteger)resumePausedDownloads; // returns the number of downloads that were resumed

- (void)addDownloadProgressBlock:(TSNetworkDownloadTaskProgressBlock)progressBlock
          toExistingDownloadTask:(NSURLSessionDownloadTask *)task;

- (void)addUploadProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
          toExistingUploadTask:(NSURLSessionUploadTask *)task;

/*
 * Perform a HTTP task, i.e. POST, GET, DELETE.
 * These tasks do not run in the background, they are run with session type defaultSessionConfiguration
 */
- (void)performDataTaskWithRelativePath:(NSString *)path
                             withMethod:(HTTP_METHOD)method
                         withParameters:(NSDictionary *)parameters
                   withAddtionalHeaders:(NSDictionary *)headers
                            withSuccess:(TSNetworkSuccessBlock)successBlock
                              withError:(TSNetworkErrorBlock)errorBlock;

/*
 * Download a file from sourcePath to destinationPath. Because it uses a background style task
 * we need to implement the delegate callback methodology in order to use the progress block,
 * ergo, the successblock passed here will be called inside another block we have to create
 * in this method. see: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSessionConfiguration_class/Reference/Reference.html#//apple_ref/occ/clm/NSURLSessionConfiguration/backgroundSessionConfiguration:
 
 */
- (NSURLSessionDownloadTask *)downloadFromFullPath:(NSString *)sourcePath
                                            toPath:(NSString *)destinationPath
                              withAddtionalHeaders:(NSDictionary *)headers
                                 withProgressBlock:(TSNetworkDownloadTaskProgressBlock)progressBlock
                                       withSuccess:(TSNetworkSuccessBlock)successBlock
                                         withError:(TSNetworkErrorBlock)errorBlock;

/*
 * Upload a file from the device to a URL. Because it uses a background style task
 * we need to implement the delegate callback methodology in order to use the progress block,
 * ergo, the successblock passed here will be called inside another block we have to create
 * in this method. see: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSessionConfiguration_class/Reference/Reference.html#//apple_ref/occ/clm/NSURLSessionConfiguration/backgroundSessionConfiguration:
 */
- (NSURLSessionUploadTask *)uploadInBackgroundFromLocalPath:(NSString *)sourcePath
                                                     toPath:(NSString *)destinationPath
                                       withAddtionalHeaders:(NSDictionary *)headers
                                          withProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
                                                withSuccess:(TSNetworkSuccessBlock)successBlock
                                                  withError:(TSNetworkErrorBlock)errorBlock;

/*
 * Upload NSData to a URL. This is NOT a background task. If you want to upload
 * as a background task, please use the uploadInBackgroundFromLocalPath:... method, as that
 * will guarantee a background upload
 */
- (NSURLSessionUploadTask *)uploadInForegroundData:(NSData *)data
                                            toPath:(NSString *)destinationPath
                              withAddtionalHeaders:(NSDictionary *)headers
                                 withProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
                                       withSuccess:(TSNetworkSuccessBlock)successBlock
                                         withError:(TSNetworkErrorBlock)errorBlock;

@end

