//
//  MAGKeyExtractor.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGKeyPathExtractor.h"

@interface MAGKeyPathExtractor ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MAGKeyPathExtractor

+ (instancetype)keyPathExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MAGMapper>)mapper {
    MAGKeyPathExtractor *extractor = [[self alloc] initWithMapper:mapper];
    extractor.keyPath = keyPath;
    return extractor;
}

- (id)massage:(id)source {
    return [source valueForKeyPath:self.keyPath];
}

@end
