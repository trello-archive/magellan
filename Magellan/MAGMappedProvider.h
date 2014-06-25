//
//  MAGMappedProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@protocol MAGMapper;

@interface MAGMappedProvider : NSObject <MAGProvider>

+ (instancetype)mappedProviderWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper;

@end
