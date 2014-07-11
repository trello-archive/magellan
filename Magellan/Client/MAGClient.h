//
//  MAGClient.h
//  Magellan
//
//  Created by Ian Henry on 6/30/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMappingProvider.h"

@class AFHTTPRequestOperationManager, PMKPromise, NSManagedObjectContext, MAGRouter;

@interface MAGClient : NSObject

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                                    rootContext:(NSManagedObjectContext *)context
                                         router:(MAGRouter *)router
                                mappingProvider:(MAGMappingProvider *)mappingProvider;

@property (nonatomic, strong, readonly) MAGRouter *router;
@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong, readonly) NSManagedObjectContext *rootContext;
@property (nonatomic, strong, readonly) MAGMappingProvider *mappingProvider;

- (PMKPromise *)createObject:(NSManagedObject *)object;
- (PMKPromise *)mapPayload:(id)payload withConverter:(MAGManagedConverter)converter;
- (PMKPromise *)get:(NSString *)url withConverter:(MAGManagedConverter)converter;

@end
