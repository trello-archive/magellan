//
//  MAGProvidingMapper.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGMasseuse.h"

@protocol MAGProvider, MAGMapper;

@interface MAGProvidingMapper : MAGMasseuse

+ (instancetype)providerMasseuseWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper;

@end
