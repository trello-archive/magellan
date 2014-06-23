//
//  MGNKeyExtractor.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MGNKeyExtractor.h"

@interface MGNKeyExtractor ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MGNKeyExtractor

- (id)massage:(id)source {
    return [source valueForKeyPath:self.keyPath];
}

+ (instancetype)keyExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MGNMapper>)mapper {
    MGNKeyExtractor *extractor = [[MGNKeyExtractor alloc] initWithMapper:mapper];
    extractor.keyPath = keyPath;
    return extractor;
}

@end
