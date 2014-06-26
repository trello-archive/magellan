//
//  MAGBlockMapper.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGBlockMapper.h"

@interface MAGBlockMapper ()

@property (nonatomic, copy) void(^block)(id input, id target);

@end

@implementation MAGBlockMapper

+ (instancetype)mapperWithBlock:(void(^)(id input, id target))block {
    MAGBlockMapper *mapper = [[MAGBlockMapper alloc] init];
    mapper.block = block;
    return mapper;
}

- (void)map:(id)input to:(id)target {
    self.block(input, target);
}

@end
