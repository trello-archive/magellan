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
    NSParameterAssert(mappers != nil);
    MAGMappingSeries *mappingSeries = [[MAGMappingSeries alloc] init];
    mappingSeries.mappers = mappers;
    return mappingSeries;
}

- (void)map:(id)input to:(id)target {
    for (id <MAGMapper> mapper in self.mappers) {
        [mapper map:input to:target];
    }
}

@end
