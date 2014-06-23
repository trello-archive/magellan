//
//  MGNKeyExtractor.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MGNMasseuse.h"

@interface MGNKeyExtractor : MGNMasseuse

+ (instancetype)keyExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MGNMapper>)mapper;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
