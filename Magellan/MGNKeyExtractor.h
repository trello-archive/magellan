//
//  MGNKeyExtractor.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MGNMapper.h"

@interface MGNKeyExtractor : NSObject <MGNMapper>

+ (instancetype)keyExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MGNMapper>)mapper;

@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, retain, readonly) id <MGNMapper> mapper;

@end
