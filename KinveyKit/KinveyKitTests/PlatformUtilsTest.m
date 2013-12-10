//
//  PlatformUtilsTest.m
//  KinveyKit
//
//  Created by Michael Katz on 7/30/13.
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


#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>


//! should not have any other dependencies
#import "KCSPlatformUtils.h"

@interface PlatformUtilsTest : SenTestCase

@end

@implementation PlatformUtilsTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNSURLSessionSupport
{
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
        STAssertFalse([KCSPlatformUtils supportsNSURLSession], @"No support pre iOS7");
    } else {
        STAssertTrue([KCSPlatformUtils supportsNSURLSession], @"Support iOS7 + ");
    }
}

@end
