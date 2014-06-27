//
//  MAGMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMasseuse.h"

@interface MAGMasseuse ()

@property (nonatomic, strong) MAGProvider provider;
@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGMasseuse

+ (instancetype)masseuseWithProvider:(MAGProvider)provider mapper:(id<MAGMapper>)mapper {
    NSParameterAssert(provider != nil);
    NSParameterAssert(mapper != nil);
    MAGMasseuse *masseuse = [[MAGMasseuse alloc] init];
    masseuse.provider = provider;
    masseuse.mapper = mapper;
    return masseuse;
}

- (void)map:(id)input to:(id)target {
    [self.mapper map:self.provider(input) to:target];
}

@end
