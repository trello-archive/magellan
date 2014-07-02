//
//  MAGClient.h
//  Magellan
//
//  Created by Ian Henry on 6/30/14.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager, PMKPromise, NSManagedObjectContext, MAGRouter;

@interface MAGClient : NSObject

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                                    rootContext:(NSManagedObjectContext *)context
                                         router:(MAGRouter *)router;

- (PMKPromise *)createObject:(NSManagedObject *)object;

- (PMKPromise *)mapPayload:(id)payload withConverter:(MAGManagedConverter)converter;

@end
