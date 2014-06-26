//
//  MAGMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMasseuse.h"
#import "MAGProvider.h"

@interface MAGMasseuse ()

@property (nonatomic, strong) id <MAGProvider> provider;
@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGMasseuse

+ (instancetype)masseuseWithProvider:(id<MAGProvider>)provider mapper:(id<MAGMapper>)mapper {
    NSParameterAssert(provider != nil);
    NSParameterAssert(mapper != nil);
    MAGMasseuse *masseuse = [[MAGMasseuse alloc] init];
    masseuse.provider = provider;
    masseuse.mapper = mapper;
    return masseuse;
}

- (void)map:(id)source to:(id)dest {
    [self.mapper map:[self.provider provideObjectFromObject:source] to:dest];
}

@end
