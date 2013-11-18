//
//  KCSRequest2.h
//  KinveyKit
//
//  Created by Michael Katz on 8/12/13.
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

#import <Foundation/Foundation.h>

#import "KinveyHeaderInfo.h"

KCS_CONSTANT KCSRequestOptionUseMock;
KCS_CONSTANT KCSRequestOptionClientMethod;

KCS_CONSTANT KCSRESTRouteAppdata;
KCS_CONSTANT KCSRESTRouteUser;
KCS_CONSTANT KCSRESTRouteRPC;
KCS_CONSTANT KCSRESTRouteBlob;
KCS_CONSTANT KCSRESTRoutePush;
KCS_CONSTANT KCSRestRouteTestReflection;

KCS_CONSTANT KCSRESTMethodDELETE;
KCS_CONSTANT KCSRESTMethodGET;
KCS_CONSTANT KCSRESTMethodPATCH;
KCS_CONSTANT KCSRESTMethodPOST;
KCS_CONSTANT KCSRESTMethodPUT;

#define KCSRequestMethodString [NSStringFromClass([self class]) stringByAppendingFormat:@" %@", NSStringFromSelector(_cmd)]
#define KCSRequestLogMethod KCSRequestOptionClientMethod : KCSRequestMethodString

#define kHeaderContentType   @"Content-Type"
#define kHeaderContentLength @"Content-Length"

@class KCSNetworkResponse;
@protocol KCSCredentials;
@protocol KCSNetworkOperation;

typedef void(^KCSRequestCompletionBlock)(KCSNetworkResponse* response, NSError*error);

@interface KCSRequest2 : NSObject
@property (nonatomic, copy) NSArray* path;
@property (nonatomic, weak) NSString* method;
@property (nonatomic, copy) NSDictionary* headers;
@property (nonatomic, copy) NSDictionary* body;


+ (instancetype) requestWithCompletion:(KCSRequestCompletionBlock)completion route:(NSString*)route options:(NSDictionary*)options credentials:(id)credentials;
- (id<KCSNetworkOperation>) start;

//for testing
- (NSMutableURLRequest*)urlRequest;
@end
