//
//  MAGMappingSeries.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMappingSeries.h"

@interface MAGMappingSeries ()

@property (nonatomic, copy) NSArray *mappers;

@end

@implementation MAGMappingSeries

+ (instancetype)mappingSeriesWithMappers:(NSArray *)mappers {
    MAGMappingSeries *mappingSeries = [[MAGMappingSeries alloc] init];
    mappingSeries.mappers = mappers;
    return mappingSeries;
}

- (MAGMappingResult)map:(id)source to:(id)dest {
    for (id <MAGMapper> mapper in self.mappers) {
        if ([mapper map:source to:dest] == MAGMappingResultFailure) {
            return MAGMappingResultFailure;
        }
    }
    return MAGMappingResultSuccess;
}

@end
