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
#import "MAGRouter.h"

@interface MAGClient ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong) NSManagedObjectContext *rootContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundContext;
@property (nonatomic, strong) MAGRouter *router;

@end

@implementation MAGClient

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                                    rootContext:(NSManagedObjectContext *)rootContext
                                         router:(MAGRouter *)router {
    NSParameterAssert(requestOperationManager != nil);
    NSParameterAssert(rootContext != nil);
    NSParameterAssert(router != nil);
    NSAssert(rootContext.concurrencyType == NSMainQueueConcurrencyType, @"Currently the rootContext must be a main queue context. Thinking about how to fix that.");
    if (self = [super init]) {
        self.requestOperationManager = requestOperationManager;
        self.rootContext = rootContext;
        self.router = router;
        self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [self.backgroundContext performBlockAndWait:^{
            self.backgroundContext.parentContext = self.rootContext;
        }];
    }
    return self;
}

- (PMKPromise *)createObject:(NSManagedObject *)managedObject {
    NSParameterAssert(managedObject != nil);
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.requestOperationManager POST:[self.router routeObject:managedObject method:@"POST"]
                                parameters:[self serializeObject:managedObject]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       fulfiller(responseObject);
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       rejecter(error);
                                   }];
    }].then(^(id payload) {
        return [self mapPayload:payload
                  withConverter:[self converterForObject:managedObject]];
    });
}

- (PMKPromise *)mapPayload:(id)payload withConverter:(MAGManagedConverter)converter {
    NSParameterAssert(payload != nil);
    NSParameterAssert(converter != nil);
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.backgroundContext performBlock:^{
            NSManagedObject *result = converter(payload, self.backgroundContext);
            NSAssert([result isKindOfClass:NSManagedObject.class], @"converter must return an NSManagedObject");
            NSError *error = nil;
            if (![self.backgroundContext save:&error]) {
                rejecter(error);
            } else {
                fulfiller(result.objectID);
            }
        }];
    }].then(^(NSManagedObjectID *objectID) {
        return [self.rootContext objectWithID:objectID];
    });
}

- (id)serializeObject:(NSManagedObject *)managedObject {
    NSParameterAssert(managedObject != nil);
    id <MAGMapper> serializationMapper = nil;
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [serializationMapper map:managedObject to:body];
    return body;
}

- (MAGManagedConverter)converterForObject:(NSManagedObject *)object {
    NSParameterAssert(object != nil);
    NSManagedObjectID *objectID = object.objectID;
    return ^(id foo, NSManagedObjectContext *moc){
        return [moc objectWithID:objectID];
    };
}

@end
