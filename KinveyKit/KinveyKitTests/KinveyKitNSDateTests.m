//
//  KinveyKitNSDateTests.m
//  KinveyKit
//
//  Copyright (c) 2012-2013 Kinvey. All rights reserved.
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


#import "KinveyKitNSDateTests.h"
#import "NSDate+ISO8601.h"
#import "NSDate+KinveyAdditions.h"
#import "KCSLogManager.h"
#import "KCSClient.h"

@implementation KinveyKitNSDateTests

// All code under test must be linked into the Unit Test bundle
- (void)testDates
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *ISO = [now stringWithISO8601Encoding];
    NSDate *then = [NSDate dateFromISO8601EncodedString:ISO];
    
    NSTimeInterval deltaDate = [now timeIntervalSinceDate:then];
    
    NSLog(@"Then: %@, Now: %@, delta: %f, inRange? %@", then, now, deltaDate, (fabs(deltaDate) < 0.001)?@"YES":@"NO");
    
    STAssertTrue(abs(deltaDate) < 0.001, @"should be within the delta");
}

- (NSString *)nomillis:(NSString *)rfc3339DateTimeString
{
    NSDateFormatter *   rfc3339DateFormatter;
    NSLocale *          enUSPOSIXLocale;
    NSDate *            date;
    rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    date = [rfc3339DateFormatter dateFromString:rfc3339DateTimeString];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    
    return [rfc3339DateFormatter stringFromDate:date];
}


- (void)testMillis
{
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *ISO = [now stringWithISO8601Encoding];
    NSString *noM = [self nomillis:ISO];
    NSDate *then = [NSDate dateFromISO8601EncodedString:noM];
    
    NSTimeInterval deltaDate = [now timeIntervalSinceDate:then];
    
    NSLog(@"Then: %@, Now: %@, delta: %f, inRange? %@", then, now, deltaDate, (fabs(deltaDate) < 1)?@"YES":@"NO");
    STAssertTrue(abs(deltaDate) < 1, @"should be within the delta");
}


- (void) testLaterThan
{
    NSDate* origDate = [NSDate date];
    NSDate* sameDate = [origDate copy];
    
    NSDate* earlierDate = [origDate dateByAddingTimeInterval:-1000];
    NSDate* laterDate = [origDate dateByAddingTimeInterval:1000];
    
    STAssertTrue([origDate isLaterThan:earlierDate], @"");
    STAssertFalse([origDate isLaterThan:laterDate], @"");
    STAssertFalse([origDate isLaterThan:sameDate], @"");
    
    STAssertFalse([origDate isEarlierThan:earlierDate], @"");
    STAssertTrue([origDate isEarlierThan:laterDate], @"");
    STAssertFalse([origDate isEarlierThan:sameDate], @"");
}
@end
