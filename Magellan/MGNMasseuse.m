//
//  MGNMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MGNMasseuse.h"

@interface MGNMasseuse ()

@property (nonatomic, strong) id <MGNMapper> mapper;

@end

@implementation MGNMasseuse

- (instancetype)initWithMapper:(id <MGNMapper>)mapper {
    if (self = [super init]) {
        self.mapper = mapper;
    }
    return self;
}

- (id)massage:(id)source {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is an abstract method", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (MGNMappingResult)map:(id)source to:(id)dest {
    return [self.mapper map:[self massage:source] to:dest];
}

@end
