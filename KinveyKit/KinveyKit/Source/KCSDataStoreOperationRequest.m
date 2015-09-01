//
//  KCSDataStoreOperationRequest.m
//  KinveyKit
//
//  Created by Victor Barros on 2015-08-31.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

#import "KCSDataStoreOperationRequest.h"

@interface KCSDataStoreOperationRequest ()

@property BOOL _cancelled;

@end

@implementation KCSDataStoreOperationRequest

+(instancetype)requestWithDataStoreOperation:(DataStoreOperation *)dataStoreOperation
{
    return [[self alloc] initWithDataStoreOperation:dataStoreOperation];
}

-(instancetype)initWithDataStoreOperation:(DataStoreOperation *)dataStoreOperation
{
    self = [super init];
    if (self) {
        self.dataStoreOperation = dataStoreOperation;
        [self addObserver:self
               forKeyPath:@"request"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self) {
        if ([keyPath isEqualToString:@"request"]) {
            if (self.dataStoreOperation.isCancelled) {
                KCSRequest* request = change[NSKeyValueChangeNewKey];
                [request cancel];
            }
        }
    }
}

-(void)dealloc
{
    [self removeObserver:self
              forKeyPath:@"request"];
}

-(BOOL)isCancelled
{
    @synchronized (self) {
        return self._cancelled || self.dataStoreOperation.isCancelled || self.request.isCancelled;
    }
}

-(void)cancel
{
    @synchronized (self) {
        self.dataStoreOperation.completionBlock = nil;
        [self.dataStoreOperation cancel];
        
        [self.request cancel];
        
        [super cancel];
        
        self._cancelled = YES;
    }
}

@end
