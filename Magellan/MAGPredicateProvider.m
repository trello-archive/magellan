//
//  MAGPredicateProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGPredicateProvider.h"
#import "MAGMutablePredicateProxy.h"
#import "MAGMapper.h"

@interface MAGPredicateProvider ()

@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGPredicateProvider

+ (instancetype)predicateProviderWithMapper:(id <MAGMapper>)mapper {
    NSParameterAssert(mapper != nil);
    MAGPredicateProvider *masseuse = [[MAGPredicateProvider alloc] init];
    masseuse.mapper = mapper;
    return masseuse;
}

- (id)provideObjectFromObject:(id)input {
    MAGMutablePredicateProxy *proxy = [[MAGMutablePredicateProxy alloc] init];
    [self.mapper map:input to:proxy];
    return proxy.predicate;
}

@end
