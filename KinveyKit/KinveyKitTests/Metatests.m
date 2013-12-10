//
//  Metatests.m
//  KinveyKit
//
//  Created by Michael Katz on 7/31/12.
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


#import "Metatests.h"
#import <KinveyKit/KinveyKit.h>
#import "KCS_SBJson.h"

//#import "TestUtils.h"
#import "ASTTestClass.h"

// RectangleHolder.h
@interface RectangleHolder : NSObject <KCSPersistable>
@property (nonatomic) CGRect rect;
@end
// RectangleHolder.m
@interface RectangleHolder ()
@property (nonatomic, assign) NSArray* rectArray;
@end
@implementation RectangleHolder
@synthesize rect;
- (NSDictionary *)hostToKinveyPropertyMapping {
    return @{ @"rectArray" : @"rect"};
}
- (void) setRectArray:(NSArray *)rectArray {
    self.rect = CGRectMake([[rectArray objectAtIndex:0] floatValue], //x
                           [[rectArray objectAtIndex:1] floatValue], //y
                           [[rectArray objectAtIndex:2] floatValue], //w
                           [[rectArray objectAtIndex:3] floatValue]); //h
}
- (NSArray*) rectArray {
    return @[@(self.rect.origin.x), @(self.rect.origin.y), @(self.rect.size.width), @(self.rect.size.height)];
}

@end


typedef struct {
    int x;
    int y;
} XXY;

@implementation Metatests
- (void) testX
{

    ASTTestClass* t = [[ASTTestClass alloc] init];
    t.objId = @"A";
    t.objCount = 123;
    
    NSLog(@"bc");
    
}
@end

@class Employer;

//Person.h - entity in the 'People' collection
@interface Person : NSObject <KCSPersistable>
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) Person* spouse;
@property (nonatomic, retain) Employer* employer;
@end

//Person.m
@implementation Person
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{@"name" : @"name" , @"spouse" : @"spouse", @"employer" : @"employer"};
}
+(NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"employer" : @"Companies"};
}
@end

//Employer.h - entity in the 'Companies' collection
@interface Employer : NSObject <KCSPersistable>
@property (nonatomic, retain) NSString* companyName;
@property (nonatomic, retain) NSArray* employees;
@end

//Employer.m
@implementation Employer
@synthesize employees;
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{ @"employees" : @"employees", @"companyName" : @"name" };
}
+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"employees" : @"People"};
}
+ (NSDictionary *)kinveyObjectBuilderOptions
{
    return @{KCS_REFERENCE_MAP_KEY : @{@"employees" : [Person class]}};
}
@end

@interface Maybe :NSObject

@end

@implementation Maybe

- (void)ex1
{
    Person* john = [[Person alloc] init];
    john.name = @"John";
    
    Person* tony = [[Person alloc] init];
    tony.name = @"Tony";
    john.spouse = tony;
    tony.spouse = john;
    
    Employer* kinvey = [[Employer alloc] init];
    kinvey.companyName = @"Kinvey";
    kinvey.employees = @[john];
    
    KCSCollection* companies = [KCSCollection collectionFromString:@"Companies" ofClass:[Employer class]];
    KCSLinkedAppdataStore* store = [KCSLinkedAppdataStore storeWithCollection:companies options:nil];
    
    [store saveObject:kinvey withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //notify user save is complete
    } withProgressBlock:^(NSArray *objects, double percentComplete) {
        //show progress
    }];
    
    //query to find john and load its related objects
    //note: in this case the Employer object will be loaded with its data,
    //       but it will not resolve its "employees" array -
    //               it will be an array of NSDictionary reference values.
    KCSQuery* johnQuery = [KCSQuery queryOnField:@"name" withRegex:@"john" options:kKCSRegexpCaseInsensitive];
    [store queryWithQuery:johnQuery withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //do something with john
    } withProgressBlock:^(NSArray *objects, double percentComplete) {
        //show progress;
    }];
    //    [store loadObjectWithID:]
    
    [KCSUser getAccessDictionaryFromTwitterFromPrimaryAccount:^(NSDictionary *accessDictOrNil, NSError *errorOrNil) {
        if (accessDictOrNil) {
            [KCSUser loginWithWithSocialIdentity:KCSSocialIDTwitter accessDictionary:accessDictOrNil withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
                if (errorOrNil) {
                    //handle error
                }
            }];
        }
    }];
    
}

- (void) ex2
{

    //create a new user with username and password and verify the email
    [KCSUser userWithUsername:@"<#username#>" password:@"<#password#>" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (result == KCSUserCreated && errorOrNil == nil) {
            //user is created - now need to add email address and save to the backend
            user.email = @"<#email address#>"; //suggestion: use email address as user name
            [user saveToCollection:user.userCollection withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil ==  nil) {
                    [KCSUser sendEmailConfirmationForUser:user.username withCompletionBlock:^(BOOL emailSent, NSError *errorOrNil) {
                        if (errorOrNil != nil) {
                            //handle error
                        }
                    }];
                } else {
                    //handle error
                }
            } withProgressBlock:nil];
        } else {
            //handle error
        }
    }];
    
    KCSUser* currentUser = [[KCSClient sharedClient] currentUser];
    if (currentUser.emailVerified == NO) {
        //email has not yet been verified, show a button to resend
    }
    
    [KCSUser sendEmailConfirmationForUser:currentUser.username withCompletionBlock:^(BOOL emailSent, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //handle error
        }
    }];
    
}
#if NEVER
- (void) adf
{
    BOOL wasCancelled = NO;
    [_store queryWithQuery:[KCSQuery query] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (wasCancelled == NO) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                [_eventList setArray:objectsOrNil];
                [self.tableView reloadData];
            }
        } else
        {
            // do nothing
        }
    } withProgressBlock:nil];
}
#endif




@end



