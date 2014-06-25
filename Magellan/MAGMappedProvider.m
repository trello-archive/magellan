//
//  MAGMappedProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGMappedProvider.h"
#import "MAGMapper.h"

@interface MAGMappedProvider ()

@property (nonatomic, strong) id <MAGProvider> provider;
@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGMappedProvider

+ (instancetype)mappedProviderWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper {
    NSParameterAssert(provider != nil);
    NSParameterAssert(mapper != nil);
    MAGMappedProvider *mappedProvider = [[self alloc] init];
    mappedProvider.provider = provider;
    mappedProvider.mapper = mapper;
    return mappedProvider;
}

- (id)provideObjectFromObject:(id)input {
    id object = [self.provider provideObjectFromObject:input];
    [self.mapper map:input to:object];
    return object;
}

@end
