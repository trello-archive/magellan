//
//  MAGEntityProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@protocol MAGMapper;
@class NSManagedObjectContext, MAGEntityFinder;

@interface MAGEntityProvider : NSObject <MAGProvider>

+ (instancetype)entityProviderWithEntityFinder:(MAGEntityFinder *)entityFinder
                                        mapper:(id <MAGMapper>)mapper;

@property (nonatomic, strong, readonly) id <MAGMapper> mapper;

@end
