//
//  MAGClient.h
//  Magellan
//
//  Created by Ian Henry on 6/30/14.
//
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperationManager, PMKPromise, NSManagedObjectContext;

@interface MAGClient : NSObject

- (instancetype)initWithRequestOperationManager:(AFHTTPRequestOperationManager *)requestOperationManager
                                    rootContext:(NSManagedObjectContext *)context;

- (PMKPromise *)mapPayload:(id)payload withConverter:(MAGManagedConverter)converter;

@end
