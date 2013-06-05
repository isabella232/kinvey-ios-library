//
//  KCSCustomEndpointTests.m
//  KinveyKit
//
//  Created by Michael Katz on 5/30/13.
//  Copyright (c) 2013 Kinvey. All rights reserved.
//

#import "KCSCustomEndpointTests.h"

#import "TestUtils.h"
#import "KCSCustomEndpoints.h"

@implementation KCSCustomEndpointTests

- (void)setUp
{
    BOOL loaded = [TestUtils setUpKinveyUnittestBackend];
    STAssertTrue(loaded, @"should be loaded");
}

- (void) testCustomEndpoint
{
    self.done = NO;
    [KCSCustomEndpoints callEndpoint:@"bltest" params:nil completionBlock:^(id results, NSError *errorOrNil) {
        STAssertNoError;
        NSDictionary* expBody = @{@"a":@1,@"b":@2};
        STAssertEqualObjects(expBody, results, @"bodies should match");
        self.done = YES;
    }];
    [self poll];
}

@end