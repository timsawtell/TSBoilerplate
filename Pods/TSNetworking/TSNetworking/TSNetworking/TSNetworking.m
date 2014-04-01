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

#import "TSNetworking.h"
#import "Base64.h"
#import "NSError+Factory.h"
#import <Reachability.h>

typedef void(^URLSessionTaskCompletion)(NSData *data, NSURLResponse *response, NSError *error);
typedef void(^URLSessionDownloadTaskCompletion)(NSURL *location, NSError *error);

@interface TSNetworking()

@property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, strong) NSMutableDictionary *downloadProgressBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *downloadCompletedBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *uploadCompletedBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *uploadProgressBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *sessionHeaders; //because I don't feel like destroying the NSURLSession each time I need new headers in a request
@property (nonatomic, strong) NSMutableDictionary *downloadsToResume; // dictionary of nsdata for paused downloads (due to Reachability change)
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) BOOL isBackgroundConfig;
@property (nonatomic) NSUInteger activeTasks;

@end

@implementation TSNetworking

- (id)initWithBackground:(BOOL)background
{
    self = [super init];
    if (self) {
        if (background) {
            _defaultConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"au.com.sawtellsoftware.tsnetworking"];
        } else {
            _defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        }
        _defaultConfiguration.allowsCellularAccess = YES;
        _defaultConfiguration.timeoutIntervalForRequest = 30.0;
        _defaultConfiguration.timeoutIntervalForResource = 18000; // 5 hours to download a single resource should be enough. Right?
        _uploadCompletedBlocks = [NSMutableDictionary dictionary];
        _uploadProgressBlocks = [NSMutableDictionary dictionary];
        _downloadProgressBlocks = [NSMutableDictionary dictionary];
        _downloadCompletedBlocks = [NSMutableDictionary dictionary];
        
        _sharedURLSession = [NSURLSession sessionWithConfiguration:_defaultConfiguration
                                                      delegate:self
                                                 delegateQueue:nil];
        
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        _isBackgroundConfig = background;
        _sessionHeaders = [NSMutableDictionary dictionary];
        _downloadsToResume = [NSMutableDictionary dictionary];
        _activeTasks = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(handleNetworkChange:) name: kReachabilityChangedNotification object: nil];
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Reachability

/*
 * If the device goes online again, find any saved NSData from download operations and start them as 
 * new NSURLSessionDownloadTasks. Also copy across the download and progress blocks, then when they 
 * are all started again, clear out the NSData that was saved in self.downloadCompletedBlocks
 */

- (void)handleNetworkChange:(NSNotification *)notification
{
    Reachability *reachability = notification.object;
    if (NotReachable != reachability.currentReachabilityStatus) {
        [self resumePausedDownloads];
    }
}

- (NSUInteger)resumePausedDownloads
{
    NSUInteger count = self.downloadsToResume.count;
    for (NSString *key in self.downloadsToResume) {
        NSData *downloadedData = [self.downloadsToResume objectForKey:key];
        // get the old completion blocks and progress blocks
        NSNumber *dictKey = [NSNumber numberWithInteger:key.integerValue];
        TSNetworkDownloadTaskProgressBlock progress = [self.downloadProgressBlocks objectForKey:dictKey];
        URLSessionDownloadTaskCompletion completion = [self.downloadCompletedBlocks objectForKey:dictKey];
        [self.downloadProgressBlocks removeObjectForKey:dictKey];
        [self.downloadCompletedBlocks removeObjectForKey:dictKey];
        
        NSURLSessionDownloadTask *downloadTask = [self.sharedURLSession downloadTaskWithResumeData:downloadedData];
        dictKey = [NSNumber numberWithInteger:downloadTask.taskIdentifier];
        if (NULL != progress)
            [self.downloadProgressBlocks setObject:progress forKey:dictKey];
        if (NULL != completion)
            [self.downloadCompletedBlocks setObject:completion forKey:dictKey];
        [downloadTask resume];
    }
    self.downloadsToResume = [NSMutableDictionary dictionary]; // clear it out
    return count;
}

#pragma mark - Helpers

/**
 * Create a URLSessionTaskCompletion block based on the provided request, success and error block
 */
- (URLSessionTaskCompletion)taskCompletionBlockForRequest:(NSMutableURLRequest *)weakRequest
                                         withSuccessBlock:(TSNetworkSuccessBlock)successBlock
                                           withErrorBlock:(TSNetworkErrorBlock)errorBlock
{
    __weak typeof(self)weakSelf = self;
    URLSessionTaskCompletion completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (nil == weakRequest) return;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *contentType;
        strongSelf.activeTasks = MAX(strongSelf.activeTasks - 1, 0);
        if ([TSNetworking foregroundSession].activeTasks == 0 && [TSNetworking backgroundSession].activeTasks == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        NSStringEncoding stringEncoding = NSUTF8StringEncoding;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSDictionary *responseHeaders = [httpResponse allHeaderFields];
            ASSIGN_NOT_NIL(contentType, [responseHeaders valueForKey:@"Content-Type"]);
            if (nil != contentType) {
                contentType = [contentType lowercaseString];
                NSRange indexOfSemi = [contentType rangeOfString:@";"];
                if (indexOfSemi.location != NSNotFound) {
                    contentType = [contentType substringToIndex:indexOfSemi.location];
                }
            }
            
            if (response.textEncodingName) {
                CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
                if (encoding != kCFStringEncodingInvalidId) {
                    stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
                }
            }
        }
        // if there is no result data, and there is an error, make the parsed object the error's localizedDescription
        NSObject *parsedObject;
        if (nil != error && (nil == data || data.length <= 0)) {
            parsedObject = error.localizedDescription;
        } else {
            parsedObject = [strongSelf resultBasedOnContentType:contentType
                                                 withEncoding:stringEncoding 
                                                     fromData:data];
        }
        
        [strongSelf validateResponse:(NSHTTPURLResponse *)response error:&error];
        if (nil != error) {
            if (NULL != errorBlock) {
                errorBlock(parsedObject, error, weakRequest, response);
            }
            return;
        }
        if (NULL != successBlock) {
            successBlock(parsedObject, weakRequest, response);
        }
    };
    
    return completionBlock;
}

/**
 * Build an NSObject from the response data based on an optional content-type
 * return an NSDictionary for application/json
 * return an NSSting for text/
 */
- (NSObject *)resultBasedOnContentType:(NSString *)contentType
                          withEncoding:(NSStringEncoding)encoding
                              fromData:(NSData *)data
{
    if (nil == contentType) {
        contentType = @"text"; // just parse it as a string
    }
    
    NSRange indexOfSlash = [contentType rangeOfString:@"/"];
    NSString *firstComponent, *secondComponent;
    if (indexOfSlash.location != NSNotFound) {
        firstComponent = [[contentType substringToIndex:indexOfSlash.location] lowercaseString];
        secondComponent = [[contentType substringFromIndex:indexOfSlash.location + 1] lowercaseString];
    } else {
        firstComponent = [contentType lowercaseString];
    }
    
    NSError *parseError = nil;
    if ([firstComponent isEqualToString:@"application"]) {
        if ([secondComponent hasPrefix:@"json"]) {
            id parsedJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            return parsedJson;
        }
    } else if ([firstComponent isEqualToString:@"text"]) {
        NSString *parsedString;
        parsedString = [[NSString alloc] initWithData:data
                                             encoding:encoding];
        
        return parsedString;
    }
    
    return data;
}

- (void)addHeaders:(NSDictionary *)headers
         toRequest:(NSMutableURLRequest *)request
{
    if (nil != self.username && nil != self.password) {
        NSString *base64EncodedString = [[NSString stringWithFormat:@"%@:%@", self.username, self.password] base64EncodedString];
        NSString *valueString = [NSString stringWithFormat:@"Basic %@", base64EncodedString];
        [request setValue:valueString forHTTPHeaderField:@"Authorization"];
    }
 
    for (NSString *key in headers) {
        [request addValue:[headers valueForKey:key] forHTTPHeaderField:key];
    }
    
    for (NSString *key in self.sessionHeaders) {
        [request addValue:[self.sessionHeaders valueForKey:key] forHTTPHeaderField:key];
    }
}

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                   error:(NSError *__autoreleasing *)error
{
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode]) {
            NSString *text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%d)", @"TSNetworking", nil), [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], response.statusCode];
            if (error) {
                *error = [NSError errorWithDomain:NSURLErrorDomain
                                         withCode:(int)response.statusCode
                                         withText:text];
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - Singletons

+ (TSNetworking *)foregroundSession
{
    static dispatch_once_t once;
    static TSNetworking *sharedSession;
    dispatch_once(&once, ^{
        sharedSession = [[self alloc] initWithBackground:NO];
    });
    return sharedSession;
}

+ (TSNetworking *)backgroundSession
{
    static dispatch_once_t once;
    static TSNetworking *backgroundSession;
    dispatch_once(&once, ^{
        backgroundSession = [[self alloc] initWithBackground:YES];
    });
    return backgroundSession;
}

#pragma mark - Public Methods

- (void)setBaseURLString:(NSString *)baseURLString
{
    self.baseURL = [NSURL URLWithString:[baseURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (void)setBasicAuthUsername:(NSString *)username
                withPassword:(NSString *)password
{
    self.username = username;
    self.password = password;
}

- (void)addSessionHeaders:(NSDictionary *)headers
{
    [self.sessionHeaders addEntriesFromDictionary:headers];
}

- (void)removeAllSessionHeaders
{
    self.sessionHeaders = [NSMutableDictionary dictionary];
}

- (void)addDownloadProgressBlock:(TSNetworkDownloadTaskProgressBlock)progressBlock
          toExistingDownloadTask:(NSURLSessionDownloadTask *)task
{
    if (NSURLSessionTaskStateSuspended >= task.state) {
        if (NULL != progressBlock) {
            [self.downloadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInteger:task.taskIdentifier]];
        }
    }
}

- (void)addUploadProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
          toExistingUploadTask:(NSURLSessionUploadTask *)task
{
    if (NSURLSessionTaskStateSuspended >= task.state) {
        if (NULL != progressBlock) {
            [self.uploadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInteger:task.taskIdentifier]];
        }
    }
}

- (void)performDataTaskWithRelativePath:(NSString *)path
                             withMethod:(HTTP_METHOD)method
                         withParameters:(NSDictionary *)parameters
                   withAddtionalHeaders:(NSDictionary *)headers
                            withSuccess:(TSNetworkSuccessBlock)successBlock
                              withError:(TSNetworkErrorBlock)errorBlock
{
#ifdef DEBUG
    NSAssert(nil != self.baseURL, @"Base URL is nil");
    NSAssert(!self.isBackgroundConfig, @"Must be run in sharedSession, not backgroundSession");
#endif
    NSURL *requestURL = self.baseURL;
    if (nil != path) {
        requestURL = [self.baseURL URLByAppendingPathComponent:path];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:self.defaultConfiguration.timeoutIntervalForRequest];
    NSString *setMethod;
    switch (method) {
        case HTTP_METHOD_POST: setMethod = @"POST"; break;
        case HTTP_METHOD_GET: setMethod = @"GET"; break;
        case HTTP_METHOD_PUT: setMethod = @"PUT"; break;
        case HTTP_METHOD_HEAD: setMethod = @"HEAD"; break;
        case HTTP_METHOD_DELETE: setMethod = @"DELETE"; break;
        case HTTP_METHOD_TRACE: setMethod = @"TRACE"; break;
        case HTTP_METHOD_CONNECT: setMethod = @"CONNECT"; break;
        case HTTP_METHOD_PATCH: setMethod = @"PATCH"; break;
        default: setMethod = @"GET";break;
    }
    [request setHTTPMethod:setMethod];
    
    // parameters (for adding to the query string if GET, or adding to the body if POST
    if (nil != parameters) {
        switch (method) {
            case HTTP_METHOD_POST:
            case HTTP_METHOD_PUT:
            case HTTP_METHOD_PATCH:
            {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
                if (jsonData) {
                    [request setHTTPBody:jsonData];
                }
            }
            break;
                
            default:
            {
                NSString *urlString = [request.URL absoluteString];
                NSRange range = [urlString rangeOfString:@"?"];
                BOOL addQMark = (range.location == NSNotFound);
                for (NSString *key in parameters) {
                    if (addQMark) {
                        urlString = [urlString stringByAppendingFormat:@"?%@=%@", key, [parameters valueForKey:key]];
                        addQMark = NO;
                    } else {
                        urlString = [urlString stringByAppendingFormat:@"&%@=%@", key, [parameters valueForKey:key]];
                    }
                }
                [request setURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            }
            break;
        }
    }
    
    __weak typeof(request) weakRequest = request;
    URLSessionTaskCompletion completionBlock = [self taskCompletionBlockForRequest:weakRequest
                                                                  withSuccessBlock:successBlock
                                                                    withErrorBlock:errorBlock];
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionDataTask *task = [self.sharedURLSession dataTaskWithRequest:request
                                                          completionHandler:completionBlock];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeTasks++;
    [task resume];
}

- (NSURLSessionDownloadTask *)downloadFromFullPath:(NSString *)sourcePath
                                            toPath:(NSString *)destinationPath
                              withAddtionalHeaders:(NSDictionary *)headers
                                 withProgressBlock:(TSNetworkDownloadTaskProgressBlock)progressBlock
                                       withSuccess:(TSNetworkSuccessBlock)successBlock
                                         withError:(TSNetworkErrorBlock)errorBlock
{
#ifdef DEBUG
    NSAssert(nil != sourcePath, @"You need a sourcePath");
    NSAssert(nil != destinationPath, @"You need a destinationPath");
#endif
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[sourcePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.HTTPMethod = @"GET";
    
    __weak typeof(request) weakRequest = request;
    __weak typeof(self) weakSelf = self;
    // download completion blocks are different from data type completion blocks
    URLSessionDownloadTaskCompletion completionBlock = ^(NSURL *location, NSError *error) {
        if (nil == weakRequest) return;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.activeTasks = MAX(strongSelf.activeTasks - 1, 0);
        if ([TSNetworking foregroundSession].activeTasks == 0 && [TSNetworking backgroundSession].activeTasks == 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
        if (nil != error) {
            if (NULL != errorBlock) {
                errorBlock(nil, error, weakRequest, nil);
            }
            return;
        }
        
        // does this file exist?
        NSFileManager *fm = [NSFileManager new];
        if (![fm fileExistsAtPath:location.path isDirectory:NO]) {
            // aint this some shit, it finished without error, but the file is not available at location
            NSString *text = NSLocalizedStringFromTable(@"Unable to locate downloaded file", @"TSNetworking", nil);
            error = [NSError errorWithDomain:NSURLErrorDomain
                                    withCode:NSURLErrorCannotOpenFile
                                    withText:text];
            if (NULL != errorBlock) {
                errorBlock(nil, error, weakRequest, nil);
            }
            return;
        }
        
        // move the file to the programmers destination
        error = nil;
        if ([fm fileExistsAtPath:destinationPath isDirectory:NO]) {
            [fm removeItemAtPath:destinationPath error:&error];
        }
        
        if (nil != error) {
            // son of a bitch
            NSString *text = NSLocalizedStringFromTable(@"Download success, however destination path already exists, and that file was unable to be deleted", @"TSNetworking", nil);
            error = [NSError errorWithDomain:NSURLErrorDomain
                                    withCode:NSURLErrorCannotMoveFile
                                    withText:text];
            if (NULL != errorBlock) {
                errorBlock(nil, error, weakRequest, nil);
            }
            return;
        }
        
        [fm moveItemAtPath:location.path toPath:destinationPath error:&error];
        if (nil != error) {
            // double son of a bitch
            NSString *text = NSLocalizedStringFromTable(@"Download success, however unable to move downloaded file to the destination path.", @"TSNetworking", nil);
            error = [NSError errorWithDomain:NSURLErrorDomain
                                    withCode:NSURLErrorCannotMoveFile
                                    withText:text];
            if (NULL != errorBlock) {
                errorBlock(nil, error, weakRequest, nil);
            }
            return;
        }
        
        // all worked as intended
        if (NULL != successBlock) {
            successBlock(location, weakRequest, nil);
        }
    };
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionDownloadTask *downloadTask = [self.sharedURLSession downloadTaskWithRequest:request];
    /* There is no way to associate a progress block to a download task, all you can do
    * is respond to the protocol callback - and then what? How do you find the block of code to run for that task?
    * AND there is no way to receive the delegate callbacks (NSURLSessionDownloadDelegate) if you use a completionHandler block
    * when instantiating the task as above (downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void...).
    * We have to do this horrid collection of progress and completion blocks.
    */
    if (NULL != progressBlock) {
        [self.downloadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]];
    }
    [self.downloadCompletedBlocks setObject:completionBlock forKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeTasks++;
    [downloadTask resume];
    return downloadTask;
}

- (NSURLSessionUploadTask *)uploadInBackgroundFromLocalPath:(NSString *)sourcePath
                                                     toPath:(NSString *)destinationPath
                                       withAddtionalHeaders:(NSDictionary *)headers
                                          withProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
                                                withSuccess:(TSNetworkSuccessBlock)successBlock
                                                  withError:(TSNetworkErrorBlock)errorBlock
{
#ifdef DEBUG
    NSAssert(self.isBackgroundConfig, @"Must be run in backgroundSession, not sharedSession");
    NSAssert(nil != sourcePath, @"You need a sourcePath");
    NSAssert(nil != destinationPath, @"You need a destinationPath");
#endif
    NSFileManager *fm = [NSFileManager new];
    NSError *error;
    if (![fm fileExistsAtPath:sourcePath isDirectory:NO]) {
        // file to be uploaded not found
        NSString *text = NSLocalizedStringFromTable(@"Unable to locate file to upload", @"TSNetworking", nil);
        error = [NSError errorWithDomain:NSURLErrorDomain
                                withCode:NSURLErrorCannotOpenFile
                                withText:text];
        
        errorBlock(nil, error, nil, nil);
        return nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[destinationPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"POST"];
    __weak typeof(request) weakRequest = request;
    URLSessionTaskCompletion completionBlock = [self taskCompletionBlockForRequest:weakRequest
                                                                  withSuccessBlock:successBlock
                                                                    withErrorBlock:errorBlock];
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionUploadTask *uploadTask = [self.sharedURLSession uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:sourcePath]];
    if (NULL != progressBlock) {
        [self.uploadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInteger:uploadTask.taskIdentifier]];
    }
    if (NULL != completionBlock) {
        [self.uploadCompletedBlocks setObject:completionBlock forKey:[NSNumber numberWithInteger:uploadTask.taskIdentifier]];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeTasks++;
    [uploadTask resume];

    return uploadTask;
}

- (NSURLSessionUploadTask *)uploadInForegroundData:(NSData *)data
                                            toPath:(NSString *)destinationPath
                              withAddtionalHeaders:(NSDictionary *)headers
                                 withProgressBlock:(TSNetworkUploadTaskProgressBlock)progressBlock
                                       withSuccess:(TSNetworkSuccessBlock)successBlock
                                         withError:(TSNetworkErrorBlock)errorBlock
{
#ifdef DEBUG
    NSAssert(!self.isBackgroundConfig, @"Must be run in sharedSession, not backgroundSession");
    NSAssert(nil != data, @"You need source data");
    NSAssert(nil != destinationPath, @"You need a destinationPath");
#endif
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[destinationPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"POST"];
    __weak typeof(request) weakRequest = request;
    URLSessionTaskCompletion completionBlock = [self taskCompletionBlockForRequest:weakRequest
                                                                  withSuccessBlock:successBlock
                                                                    withErrorBlock:errorBlock];
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionUploadTask *uploadTask = [self.sharedURLSession uploadTaskWithRequest:request fromData:data];
    if (NULL != progressBlock) {
        [self.uploadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInteger:uploadTask.taskIdentifier]];
    }
    if (NULL != completionBlock) {
        [self.uploadCompletedBlocks setObject:completionBlock forKey:[NSNumber numberWithInteger:uploadTask.taskIdentifier]];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.activeTasks++;
    [uploadTask resume];
    return uploadTask;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *))completionHandler
{
    //todo: give a shit
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    TSNetworkUploadTaskProgressBlock progress;
    ASSIGN_NOT_NIL(progress, [self.uploadProgressBlocks objectForKey:[NSNumber numberWithInteger:task.taskIdentifier]]);
    if (NULL != progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(bytesSent, totalBytesSent, totalBytesExpectedToSend);
        });
    }
}

#pragma mark - NSURLSessionDownloadDelegate
/*
 * I have to listen to the 3 delegate methods for the downloadTask instead of assigning
 * a single completionblock when I created the downloadTask. I also have to keep a local
 * dictionary of progress and completion blocks due to this protocol
 */

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    // if it finishes with error, but has downloaded data, and we have network access: resume the download.
    // if it finishes with error, but has downloaded data, and we do not have network access: save the task (and data) to retry later
    if (nil != error) {
        NSData *downloadData = [error.userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
        if (nil != downloadData) {
            if (NotReachable != [[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
                [self.sharedURLSession downloadTaskWithResumeData:downloadData];
                return;
            } else {
                [self.downloadsToResume setObject:downloadData forKey:[NSNumber numberWithInteger:task.taskIdentifier]];
                return;
            }
        }
    }
    NSNumber *taskKey = [NSNumber numberWithInteger:task.taskIdentifier];
    [self.downloadsToResume removeObjectForKey:taskKey]; // it didn't fail, so remove the PausedDownloadTask if it existed in the downloadsToResume dict.
    
    if (nil != [self.uploadCompletedBlocks objectForKey:taskKey]) {
        // there is an upload completion blocks we need to run
        URLSessionTaskCompletion completionBlock = [self.uploadCompletedBlocks objectForKey:taskKey];
        completionBlock(nil, task.response, error);
        [self.uploadCompletedBlocks removeObjectForKey:taskKey];
        [self.uploadProgressBlocks removeObjectForKey:taskKey];
    } else if (nil != [self.downloadCompletedBlocks objectForKey:taskKey]) {
        // there is a download completion blocks we need to run
        URLSessionDownloadTaskCompletion completionBlock = [self.downloadCompletedBlocks objectForKey:taskKey];
        completionBlock(nil, error);
        [self.downloadCompletedBlocks removeObjectForKey:taskKey];
        [self.downloadCompletedBlocks removeObjectForKey:taskKey];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    TSNetworkDownloadTaskProgressBlock progress;
    ASSIGN_NOT_NIL(progress, [self.downloadProgressBlocks objectForKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]]);
    if (NULL != progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didFinishDownloadingToURL:(NSURL *)location
{
    URLSessionDownloadTaskCompletion completionBlock;
    ASSIGN_NOT_NIL(completionBlock, [self.downloadCompletedBlocks objectForKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]]);
    if (NULL != completionBlock) {
        completionBlock(location, nil);
    }
    [self.downloadProgressBlocks removeObjectForKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]];
    [self.downloadCompletedBlocks removeObjectForKey:[NSNumber numberWithInteger:downloadTask.taskIdentifier]];
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // todo: give a shit
}

#pragma mark - NSURLSessionDelegate

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    if (NULL != self.sessionCompletionHandler) {
        self.sessionCompletionHandler();
        self.sessionCompletionHandler = NULL;
    }
}

@end
