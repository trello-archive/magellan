//
//  MAGKeyExtractor.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGKeyExtractor.h"

@interface MAGKeyExtractor ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MAGKeyExtractor

- (id)massage:(id)source {
    return [source valueForKeyPath:self.keyPath];
}

+ (instancetype)keyExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MAGMapper>)mapper {
    MAGKeyExtractor *extractor = [[MAGKeyExtractor alloc] initWithMapper:mapper];
    extractor.keyPath = keyPath;
    return extractor;
}

@end
