//
//  KinveyAnalytics.h
//  KinveyKit
//
//  Copyright (c) 2008-2011, Kinvey, Inc. All rights reserved.
//
//  This software contains valuable confidential and proprietary information of
//  KINVEY, INC and is subject to applicable licensing agreements.
//  Unauthorized reproduction, transmission or distribution of this file and its
//  contents is a violation of applicable laws.

#import <Foundation/Foundation.h>

/*! Interface to Kinvey Analytics Service.
 
 This objects is the single interface to all Kinvey Analytics services.  It should not be created directly, but should be used through
 the KCSClient property.
 */
@interface KCSAnalytics : NSObject

///---------------------------------------------------------------------------------------
/// @name User/Device Identification
///---------------------------------------------------------------------------------------

/*! The unique identifier for this device/user */
@property (retain, readonly) NSString *UUID;

/*! The Apple Provided UDID for this device, note Deprecated in iOS 5. */
@property (retain, readonly) NSString *UDID;

/*! Generate a UUID
 
 This UUID is not persistent, but is meant to be a one-time UUID.
 
 @return The generated UUID.
 */
- (NSString *)generateUUID;


@end