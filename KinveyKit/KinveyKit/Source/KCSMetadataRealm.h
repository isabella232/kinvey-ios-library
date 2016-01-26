//
//  KCSMetadataRealm.h
//  KinveyKit
//
//  Created by Victor Barros on 2015-11-24.
//  Copyright © 2015 Kinvey. All rights reserved.
//

@import Realm;

@interface KCSMetadataRealm : RLMObject

@property NSString* ect;
@property NSString* lmt;
@property NSDate* lrt;

@end