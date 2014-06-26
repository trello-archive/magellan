//
//  MAGBlockProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGBlockProvider.h"

@interface MAGBlockProvider ()

@property (nonatomic, copy) id(^block)(id input);

@end


@implementation MAGBlockProvider

+ (instancetype)providerWithBlock:(id(^)(id input))block {
    MAGBlockProvider *provider = [[MAGBlockProvider alloc] init];
    provider.block = block;
    return provider;
}

- (id)provideObjectFromObject:(id)input {
    return self.block(input);
}

@end
