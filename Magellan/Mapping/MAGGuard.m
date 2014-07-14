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
    MAGThrowF(@"%s is an abstract method", __PRETTY_FUNCTION__);
}

- (void)map:(id)input to:(id)target {
    if ([self shouldMap:input]) {
        [self.mapper map:input to:target];
    }
}

@end
