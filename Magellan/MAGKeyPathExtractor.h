//
//  MAGKeyExtractor.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMasseuse.h"

@interface MAGKeyPathExtractor : MAGMasseuse

+ (instancetype)keyPathExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MAGMapper>)mapper;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
