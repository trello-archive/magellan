//
//  MGNMappingSeries.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MGNMapper.h"

@interface MGNMappingSeries : NSObject <MGNMapper>

+ (instancetype)mappingSeriesWithMappers:(NSArray *)mappers;
@property (nonatomic, copy, readonly) NSArray *mappers;

@end
