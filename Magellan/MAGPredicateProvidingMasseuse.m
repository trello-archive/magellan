//
//  MAGPredicateProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGPredicateProvidingMasseuse.h"
#import "MAGMutablePredicateProxy.h"
#import "MAGMapper.h"

@interface MAGPredicateProvidingMasseuse ()

@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGPredicateProvidingMasseuse

+ (instancetype)predicateProvidingMasseuseWithMapper:(id <MAGMapper>)mapper provider:(id <MAGProvider>)provider {
    NSParameterAssert(mapper != nil);
    MAGPredicateProvidingMasseuse *masseuse = [[MAGPredicateProvidingMasseuse alloc] initWithProvider:provider];
    masseuse.mapper = mapper;
    return masseuse;
}

- (id)massage:(id)input {
    MAGMutablePredicateProxy *proxy = [[MAGMutablePredicateProxy alloc] init];
    [self.mapper map:input to:proxy];
    return proxy.predicate;
}

@end
