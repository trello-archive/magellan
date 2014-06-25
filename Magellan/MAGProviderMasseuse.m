//
//  MAGProviderMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGProviderMasseuse.h"
#import "MAGProvider.h"

@interface MAGProviderMasseuse ()

@property (nonatomic, strong) id <MAGProvider> provider;

@end

@implementation MAGProviderMasseuse

+ (instancetype)providerMasseuseWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper {
    NSParameterAssert(provider != nil);
    MAGProviderMasseuse *providerMasseuse = [[self alloc] initWithMapper:mapper];
    providerMasseuse.provider = provider;
    return providerMasseuse;
}

- (id)massage:(id)source {
    return [self.provider provideObjectFromObject:source];
}

@end
