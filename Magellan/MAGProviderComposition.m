//
//  MAGProviderComposition.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGProviderComposition.h"

@interface MAGProviderComposition ()

@property (nonatomic, strong) id <MAGProvider> inner;
@property (nonatomic, strong) id <MAGProvider> outer;

@end

@implementation MAGProviderComposition

+ (instancetype)providerCompositionWithInner:(id <MAGProvider>)inner outer:(id <MAGProvider>)outer {
    NSParameterAssert(inner != nil);
    NSParameterAssert(outer != nil);
    MAGProviderComposition *composition = [[MAGProviderComposition alloc] init];
    composition.inner = inner;
    composition.outer = outer;
    return composition;
}

- (id)provideObjectFromObject:(id)input {
    return [self.outer provideObjectFromObject:[self.inner provideObjectFromObject:input]];
}

@end
