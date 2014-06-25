//
//  MAGPredicateProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGProviderMasseuse.h"

@protocol MAGMapper;

@interface MAGPredicateProvidingMasseuse : MAGProviderMasseuse

+ (instancetype)predicateProvidingMasseuseWithMapper:(id <MAGMapper>)mapper
                                            provider:(id <MAGProvider>)provider;

@end
