//
//  MAGKeyPathProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGKeyPathProvider.h"

@interface MAGKeyPathProvider ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MAGKeyPathProvider

+ (instancetype)keyPathProviderWithKeyPath:(NSString *)keyPath {
    MAGKeyPathProvider *this = [[MAGKeyPathProvider alloc] init];
    this.keyPath = keyPath;
    return this;
}

- (id)provideObjectFromObject:(id)input {
    return [input valueForKeyPath:self.keyPath];
}

@end
