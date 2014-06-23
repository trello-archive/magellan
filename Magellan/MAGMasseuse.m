//
//  MAGMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGMasseuse.h"

@interface MAGMasseuse ()

@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGMasseuse

- (instancetype)initWithMapper:(id <MAGMapper>)mapper {
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

- (MAGMappingResult)map:(id)source to:(id)dest {
    return [self.mapper map:[self massage:source] to:dest];
}

@end
