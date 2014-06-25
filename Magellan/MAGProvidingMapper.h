//
//  MAGProvidingMapper.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGMapperMasseuse.h"

@protocol MAGProvider, MAGMapper;

@interface MAGProvidingMapper : MAGMapperMasseuse

+ (instancetype)providerMasseuseWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper;

@end
