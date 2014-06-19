//
//  MGNMappingSeries.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MGNMappingSeries.h"

@interface MGNMappingSeries ()

@property (nonatomic, copy) NSArray *mappers;

@end

@implementation MGNMappingSeries

+ (instancetype)mappingSeriesWithMappers:(NSArray *)mappers {
    MGNMappingSeries *mappingSeries = [[MGNMappingSeries alloc] init];
    mappingSeries.mappers = mappers;
    return mappingSeries;
}

- (MGNMappingResult)map:(id)source to:(id)dest {
    for (id <MGNMapper> mapper in self.mappers) {
        if ([mapper map:source to:dest] == MGNMappingResultFailure) {
            return MGNMappingResultFailure;
        }
    }
    return MGNMappingResultSuccess;
}

@end
