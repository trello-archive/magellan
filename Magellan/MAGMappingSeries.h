//
//  MAGMappingSeries.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMapper.h"

@interface MAGMappingSeries : NSObject <MAGMapper>

+ (instancetype)mappingSeriesWithMappers:(NSArray *)mappers;
@property (nonatomic, copy, readonly) NSArray *mappers;

@end
