//
//  MAGClient.m
//  Magellan
//
//  Created by Ian Henry on 6/30/14.
//
//

#import "MAGClient.h"
#import <AFNetworking/AFNetworking.h>
#import <CoreData/CoreData.h>
#import <PromiseKit/PromiseKit.h>

@interface MAGClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong) NSManagedObjectContext *rootContext;

@end

@implementation MAGClient

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                                    rootContext:(NSManagedObjectContext *)rootContext {
    NSParameterAssert(requestOperationManager != nil);
    NSParameterAssert(rootContext != nil);
    NSAssert(rootContext.concurrencyType == NSMainQueueConcurrencyType, @"Currently the rootContext must be a main queue context. Thinking about how to fix that.");
    if (self = [super init]) {
        self.requestOperationManager = requestOperationManager;
        self.rootContext = rootContext;
    }
    return self;
}

- (PMKPromise *)putObject:(id)object {
    id <MAGMapper> serializationMapper = nil;
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [serializationMapper map:object to:body];

    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.requestOperationManager PUT:@"http://www.example.org/objects/123"
                               parameters:body
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      fulfiller(responseObject);
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      rejecter(error);
                                  }];
    }];
}

- (PMKPromise *)mapPayload:(id)payload withConverter:(MAGManagedConverter)converter {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context performBlock:^{
            context.parentContext = self.rootContext;
            NSManagedObject *result = converter(payload, context);
            NSAssert([result isKindOfClass:NSManagedObject.class], @"converter must return an NSManagedObject");
            NSError *error = nil;
            if (![context save:&error]) {
                rejecter(error);
            } else {
                fulfiller(result.objectID);
            }
        }];
    }].then(^(NSManagedObjectID *objectID) {
        return [self.rootContext objectWithID:objectID];
    });
}

@end
