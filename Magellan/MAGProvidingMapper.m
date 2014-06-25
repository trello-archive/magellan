//
//  MAGProvidingMapper.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGProvidingMapper.h"
#import "MAGProvider.h"

@interface MAGProvidingMapper ()

@property (nonatomic, strong) id <MAGProvider> provider;

@end

@implementation MAGProvidingMapper

+ (instancetype)providerMasseuseWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper {
    NSParameterAssert(provider != nil);
    MAGProvidingMapper *providerMasseuse = [[self alloc] initWithMapper:mapper];
    providerMasseuse.provider = provider;
    return providerMasseuse;
}

- (id)massage:(id)source {
    return [self.provider provideObjectFromObject:source];
}

@end
