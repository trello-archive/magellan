//
//  MAGKeyExtractor.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMapperMasseuse.h"

@interface MAGKeyPathExtractor : MAGMapperMasseuse

+ (instancetype)keyPathExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MAGMapper>)mapper;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
