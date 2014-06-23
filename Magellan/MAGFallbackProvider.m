//
//  MAGFallbackProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import "MAGFallbackProvider.h"

@interface MAGFallbackProvider ()

@property (nonatomic, strong) id <MAGProvider> primary;
@property (nonatomic, strong) id <MAGProvider> secondary;

@end

@implementation MAGFallbackProvider

+ (id)fallbackProviderWithPrimary:(id <MAGProvider>)primary secondary:(id <MAGProvider>)secondary {
    NSParameterAssert(primary != nil);
    NSParameterAssert(secondary != nil);
    MAGFallbackProvider *provider = [[MAGFallbackProvider alloc] init];
    provider.primary = primary;
    provider.secondary = secondary;
    return provider;
}

- (id)provideObjectFromObject:(id)object {
    return [self.primary provideObjectFromObject:object] ?: [self.secondary provideObjectFromObject:object];
}

@end
