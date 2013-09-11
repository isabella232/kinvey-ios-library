//
//  KCSNetworkResponse.m
//  KinveyKit
//
//  Created by Michael Katz on 8/23/13.
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


#import "KCSNetworkResponse.h"
#import "KinveyCoreInternal.h"

@interface KCSNetworkResponse ()
@end

@implementation KCSNetworkResponse

+ (instancetype) MockResponseWith:(NSInteger)code data:(id)data
{
    KCSNetworkResponse* response = [[KCSNetworkResponse alloc] init];
    response.code = code;
    response.jsonData = data;
    return response;
}

- (BOOL)isKCSError
{
    return self.code >= 400;
}

- (NSError*) errorObject
{
    NSDictionary* kcsErrorDict = [self jsonData];
    NSError* error = [NSError createKCSError:kcsErrorDict[@"description"] code:self.code userInfo:kcsErrorDict];
    return error;
}

@end
