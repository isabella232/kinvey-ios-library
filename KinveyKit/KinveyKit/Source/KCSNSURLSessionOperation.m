//
//  KCSNSURLSessionOperation.m
//  KinveyKit
//
//  Created by Michael Katz on 9/11/13.
//  Copyright (c) 2013 Kinvey. All rights reserved.
//
// This software is licensed to you under the Kinvey terms of service located at
// http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
// software, you hereby accept such terms of service  (and any agreement referenced
// therein) and agree that you have read, understand and agree to be bound by such
// terms of service and are of legal age to agree to such terms with Kinvey.
//
// This software contains valuable confidential and proprietary information of
// KINVEY, INC and is subject to applicable licensing agreements.
// Unauthorized reproduction, transmission or distribution of this file and its
// contents is a violation of applicable laws.
//


#import "KCSNSURLSessionOperation.h"

#import "KCS_SBJson.h"

@interface KCSNSURLSessionOperation () <NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest* request;
@property (nonatomic, strong) NSMutableData* downloadedData;
@property (nonatomic, strong) NSURLSessionDataTask* dataTask;
@property (nonatomic) BOOL done;
@property (nonatomic, strong) KCSNetworkResponse* response;
@property (nonatomic, strong) NSError* error;
@end

@implementation KCSNSURLSessionOperation

- (NSURLSession*) session
{
//    static NSURLSession* session;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
    NSURLSession* session;
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    //    });
    return session;
}


- (instancetype) initWithRequest:(NSMutableURLRequest*) request
{
    self = [super init];
    if (self) {
        _request = request;
    }
    return self;
}

-(void)start {
    @autoreleasepool {
        [super start];
        
        //        [[NSThread currentThread] setName:@"KinveyKit"];
        
        //        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        NSLog(@"started");
        self.downloadedData = [NSMutableData data];
        self.dataTask = [[self session] dataTaskWithRequest:self.request];
        [self.dataTask resume];
//        _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
//        // [connection setDelegateQueue:[NSOperationQueue currentQueue]];
//        [_connection scheduleInRunLoop:runLoop forMode:NSRunLoopCommonModes];
//        [_connection start];
//        [runLoop run];
    }
}

- (BOOL)isFinished
{
    return _done;
}

-(BOOL)isExecuting
{
    return YES;
}

- (BOOL)isReady
{
    return YES;
}

- (void) complete:(NSError*) error
{
    _done = YES;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    self.error = error;
    //TODO?
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    id obj = [[[KCS_SBJsonParser alloc] init] objectWithData:self.downloadedData];
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
        NSString* appHello = obj[@"kinvey"];
        NSString* kcsVersion = obj[@"version"];
        NSLog(@"%@-%@", appHello, kcsVersion);
        
        
        [self complete:nil];
    } else {
        //TODO: is an error
        NSError* error = nil;
        [self complete:error];
    }
}

#pragma mark - completion


@end
