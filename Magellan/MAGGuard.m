//
//  MAGGuard.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGGuard.h"

@interface MAGGuard ()

@property (nonatomic, strong) id <MAGMapper> mapper;

@end

@implementation MAGGuard

- (instancetype)initWithMapper:(id <MAGMapper>)mapper {
    NSParameterAssert(mapper != nil);
    if (self = [super init]) {
        self.mapper = mapper;
    }
    return self;
}

- (BOOL)shouldMap:(id)input {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is an abstract method", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (MAGMappingResult)map:(id)source to:(id)dest {
    if ([self shouldMap:source]) {
        return [self.mapper map:source to:dest];
    } else {
        return MAGMappingResultSuccess;
    }
}

@end
