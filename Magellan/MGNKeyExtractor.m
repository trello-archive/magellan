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
@property (nonatomic, retain) id <MGNMapper> mapper;

@end

@implementation MGNKeyExtractor

- (MGNMappingResult)map:(id)source to:(id)dest {
    return [self.mapper map:[source valueForKeyPath:self.keyPath] to:dest];
}

+ (instancetype)keyExtractorWithKeyPath:(NSString *)keyPath mapper:(id <MGNMapper>)mapper {
    MGNKeyExtractor *extractor = [[MGNKeyExtractor alloc] init];
    extractor.keyPath = keyPath;
    extractor.mapper = mapper;
    return extractor;
}

@end
