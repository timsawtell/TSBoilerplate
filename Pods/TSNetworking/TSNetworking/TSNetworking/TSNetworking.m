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

typedef void(^URLSessionTaskCompletion)(NSData *data, NSURLResponse *response, NSError *error);
typedef void(^URLSessionDownloadTaskCompletion)(NSURL *location, NSError *error);

@interface TSNetworking()

@property (nonatomic, strong) NSURLSessionConfiguration *defaultConfiguration;
@property (nonatomic, strong) NSURLSession *sharedURLSession;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, strong) NSMutableDictionary *downloadTaskProgressBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *downloadCompletedBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *uploadCompletedBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *uploadProgressBlocks; //blame c̶a̶n̶a̶d̶a̶ apple
@property (nonatomic, strong) NSMutableDictionary *sessionHeaders; //because I don't feel like destroying the NSURLSession each time I need new headers in a request
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic) BOOL isBackgroundConfig;

@end

@implementation TSNetworking

- (id)initWithBackground:(BOOL)background
{
    self = [super init];
    if (self) {
        if (background) {
            _defaultConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"backgroundSession"];
            _defaultConfiguration.HTTPMaximumConnectionsPerHost = 2;
            _downloadTaskProgressBlocks = [NSMutableDictionary dictionary];
            _downloadCompletedBlocks = [NSMutableDictionary dictionary];
            _uploadCompletedBlocks = [NSMutableDictionary dictionary];
            _uploadProgressBlocks = [NSMutableDictionary dictionary];
        } else {
            _defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            _defaultConfiguration.HTTPMaximumConnectionsPerHost = 1;
        }
        _defaultConfiguration.allowsCellularAccess = YES;
        _defaultConfiguration.timeoutIntervalForRequest = 30.0;
        _defaultConfiguration.timeoutIntervalForResource = 30.0;
        
        _sharedURLSession = [NSURLSession sessionWithConfiguration:_defaultConfiguration
                                                      delegate:self
                                                 delegateQueue:nil];
        
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        _isBackgroundConfig = background;
        _sessionHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 * Build an NSObject from the response data based on an optional content-type
 * return an NSDictionary for application/json
 * return an NSSting for text/
 */
- (NSObject *)resultBasedOnContentType:(NSString *)contentType
                              fromData:(NSData *)data
{
    if (nil == contentType) {
        contentType = @"text"; // just parse it as a string
    }
    
    NSRange indexOfSlash = [contentType rangeOfString:@"/"];
    NSString *firstComponent, *secondComponent;
    if (indexOfSlash.location != NSNotFound) {
        firstComponent = [contentType substringToIndex:indexOfSlash.location];
        secondComponent = [contentType substringFromIndex:indexOfSlash.location + 1];
    } else {
        firstComponent = contentType;
    }
    
    NSError *parseError = nil;
    if ([firstComponent isEqualToString:@"application"]) {
        if ([secondComponent isEqualToString:@"json"]) {
            id parsedJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            return parsedJson;
        }
    } else if ([firstComponent isEqualToString:@"text"]) {
        NSString *parsedString = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        return parsedString;
    }
    
    return data;
}

- (void)addHeaders:(NSDictionary *)headers
         toRequest:(NSMutableURLRequest *)request
{
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
                                         withCode:response.statusCode
                                         withText:text];
            }
            return NO;
        }
    }
    return YES;
}

#pragma mark - Singletons

+ (TSNetworking *)sharedSession
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
    self.baseURL = [NSURL URLWithString:baseURLString];
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

- (void)performDataTaskWithRelativePath:(NSString *)path
                             withMethod:(HTTP_METHOD)method
                         withParameters:(NSDictionary *)parameters
                   withAddtionalHeaders:(NSDictionary *)headers
                            withSuccess:(TSNetworkSuccessBlock)successBlock
                              withError:(TSNetworkErrorBlock)errorBlock
{
    NSAssert(nil != self.baseURL, @"Base URL is nil");
    NSAssert(!self.isBackgroundConfig, @"Must be run in sharedSession, not backgroundSession");
    NSAssert(NULL != successBlock, @"You need a success block");
    NSAssert(NULL != errorBlock, @"You need an error block");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.baseURL
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
                [request setURL:[NSURL URLWithString:urlString]];
            }
                break;
        }
    }
    
    if (nil != self.username && nil != self.password) {
        NSString *base64EncodedString = [[NSString stringWithFormat:@"%@:%@", self.username, self.password] base64EncodedString];
        NSString *valueString = [NSString stringWithFormat:@"Basic %@", base64EncodedString];
        [request setValue:valueString forHTTPHeaderField:@"Authorization"];
    }
    __weak typeof(request) weakRequest = request;
    __weak typeof(self) weakSelf = self;
    URLSessionTaskCompletion completion = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *contentType;
        
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
        }
        // if there is no result data, and there is an error, make the parsed object the error's localizedDescription
        NSObject *parsedObject;
        if (nil != error && (nil == data || data.length <= 0)) {
            parsedObject = error.localizedDescription;
        } else {
            parsedObject = [weakSelf resultBasedOnContentType:contentType
                                                 fromData:data];
        }
        
        [weakSelf validateResponse:(NSHTTPURLResponse *)response error:&error];
        if (nil != error) {
            errorBlock(parsedObject, error, weakRequest, response);
            return;
        }
        
        successBlock(parsedObject, weakRequest, response);
    };
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionDataTask *task = [self.sharedURLSession dataTaskWithRequest:request
                                                          completionHandler:completion];
    [task resume];
}

- (NSURLSessionDownloadTask *)downloadFromFullPath:(NSString *)sourcePath
                                            toPath:(NSString *)destinationPath
                              withAddtionalHeaders:(NSDictionary *)headers
                                 withProgressBlock:(TSNetworkDownloadTaskProgressBlock)progressBlock
                                       withSuccess:(TSNetworkSuccessBlock)successBlock
                                         withError:(TSNetworkErrorBlock)errorBlock
{
    NSAssert(nil != sourcePath && nil != destinationPath, @"paths were not set up");
    NSAssert(nil != sourcePath, @"You need a source path");
    NSAssert(nil != destinationPath, @"You need a source path");
    NSAssert(NULL != successBlock, @"You need a success block");
    NSAssert(NULL != errorBlock, @"You need an error block");
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:sourcePath]];
    request.HTTPMethod = @"GET";
    
    if (nil != self.username && nil != self.password) {
        NSString *base64EncodedString = [[NSString stringWithFormat:@"%@:%@", self.username, self.password] base64EncodedString];
        NSString *valueString = [NSString stringWithFormat:@"Basic %@", base64EncodedString];
        [request setValue:valueString forHTTPHeaderField:@"Authorization"];
    }
    
    __weak typeof(request) weakRequest = request;
    URLSessionDownloadTaskCompletion completionBlock = ^(NSURL *location, NSError *error) {
        if (nil != error) {
            errorBlock(nil, error, weakRequest, nil);
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
            
            errorBlock(nil, error, weakRequest, nil);
            return;
        }
        
        // move the file to the programmers destination
        error = nil;
        [fm moveItemAtPath:location.path toPath:destinationPath error:&error];
        if (nil != error) {
            // son of a bitch
            NSString *text = NSLocalizedStringFromTable(@"Unable to move file", @"TSNetworking", nil);
            error = [NSError errorWithDomain:NSURLErrorDomain
                                    withCode:NSURLErrorCannotMoveFile
                                    withText:text];
            
            errorBlock(nil, error, weakRequest, nil);
            return;
        }
        
        // all worked as intended
        successBlock(location, weakRequest, nil);
    };
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionDownloadTask *downloadTask = [self.sharedURLSession downloadTaskWithRequest:request
                                                                          completionHandler:nil];
    // Thanks for fucking nothing apple. There is no way to associate a progress block to a download task, all you can do
    // is listen to the callback - and then what? How do you find the block of code to run for that task?
    // AND there is no way to get the delegate callbacks (NSURLSessionDownloadDelegate) if you use a completionHandler block
    // when instantiating the task as above. Fuck you. Have to do this horrid collection of progress and completion blocks.
    [self.downloadTaskProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]];
    [self.downloadCompletedBlocks setObject:completionBlock forKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]];
    [downloadTask resume];
    return downloadTask;
}

- (NSURLSessionUploadTask *)uploadFromFullPath:(NSString *)sourcePath
                                        toPath:(NSString *)destinationPath
                          withAddtionalHeaders:(NSDictionary *)headers
                             withProgressBlock:(id)progressBlock
                                   withSuccess:(TSNetworkSuccessBlock)successBlock
                                     withError:(TSNetworkErrorBlock)errorBlock
{
    NSAssert(self.isBackgroundConfig, @"Must be run in backgroundSession, not sharedSession");
    NSAssert(nil != sourcePath, @"You need a source path");
    NSAssert(nil != destinationPath, @"You need a source path");
    NSAssert(NULL != successBlock, @"You need a success block");
    NSAssert(NULL != errorBlock, @"You need an error block");
    
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:destinationPath]];
    [request setHTTPMethod:@"POST"];
    
    __weak typeof(request) weakRequest = request;
    __weak typeof(self) weakSelf = self;
    URLSessionTaskCompletion completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *contentType;
        
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
        }
        // if there is no result data, and there is an error, make the parsed object the error's localizedDescription
        NSObject *parsedObject;
        if (nil != error && (nil == data || data.length <= 0)) {
            parsedObject = error.localizedDescription;
        } else {
            parsedObject = [weakSelf resultBasedOnContentType:contentType
                                                     fromData:data];
        }
        
        [weakSelf validateResponse:(NSHTTPURLResponse *)response error:&error];
        if (nil != error) {
            errorBlock(parsedObject, error, weakRequest, response);
            return;
        }
        
        successBlock(parsedObject, weakRequest, response);
    };
    
    [self addHeaders:headers toRequest:request];
    NSURLSessionUploadTask *uploadTask = [self.sharedURLSession uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:sourcePath]];
    [self.uploadProgressBlocks setObject:progressBlock forKey:[NSNumber numberWithInt:uploadTask.taskIdentifier]];
    [self.uploadCompletedBlocks setObject:completionBlock forKey:[NSNumber numberWithInt:uploadTask.taskIdentifier]];
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
    ASSIGN_NOT_NIL(progress, [self.uploadProgressBlocks objectForKey:[NSNumber numberWithInt:task.taskIdentifier]]);
    if (NULL != progress) {
        progress(bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        URLSessionDownloadTaskCompletion completionBlock;
        ASSIGN_NOT_NIL(completionBlock, [self.downloadCompletedBlocks objectForKey:[NSNumber numberWithInt:task.taskIdentifier]]);
        if (NULL != completionBlock) {
            completionBlock(nil, error);
        }
    } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        URLSessionTaskCompletion completionBlock;
        ASSIGN_NOT_NIL(completionBlock, [self.uploadCompletedBlocks objectForKey:[NSNumber numberWithInt:task.taskIdentifier]]);
        if (NULL != completionBlock) {
            completionBlock(nil, task.response, error);
        }
    } else {
        return;
    }
    
    
    if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        [self.downloadCompletedBlocks removeObjectForKey:[NSNumber numberWithInt:task.taskIdentifier]];
        [self.downloadCompletedBlocks removeObjectForKey:[NSNumber numberWithInt:task.taskIdentifier]];
    } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        [self.uploadCompletedBlocks removeObjectForKey:[NSNumber numberWithInt:task.taskIdentifier]];
        [self.uploadProgressBlocks removeObjectForKey:[NSNumber numberWithInt:task.taskIdentifier]];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // thanks to apple being idiots I have to listen to the 3 delegate methods for the downloadTask instead of assigning
    // a single completionblock when I created the downloadTask. I also have to keep a local list of progress and completion
    // blocks due to this protocol
    TSNetworkDownloadTaskProgressBlock progress;
    ASSIGN_NOT_NIL(progress, [self.downloadTaskProgressBlocks objectForKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]]);
    if (NULL != progress) {
        progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"finished download");
    URLSessionDownloadTaskCompletion completionBlock;
    ASSIGN_NOT_NIL(completionBlock, [self.downloadCompletedBlocks objectForKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]]);
    if (NULL != completionBlock) {
        completionBlock(location, nil);
    }
    [self.downloadTaskProgressBlocks removeObjectForKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]];
    [self.downloadCompletedBlocks removeObjectForKey:[NSNumber numberWithInt:downloadTask.taskIdentifier]];
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // the hills are alive with the sound of the fucks I don't give
}

@end
