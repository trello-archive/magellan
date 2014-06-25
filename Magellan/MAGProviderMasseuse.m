//
//  MAGProviderMasseuse.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGProviderMasseuse.h"

@interface MAGProviderMasseuse ()

@property (nonatomic, strong) id <MAGProvider> provider;

@end

@implementation MAGProviderMasseuse

- (instancetype)initWithProvider:(id <MAGProvider>)provider {
    NSParameterAssert(provider != nil);
    if (self = [super init]) {
        self.provider = provider;
    }
    return self;
}

- (id)massage:(id)input {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%s is an abstract method", __PRETTY_FUNCTION__]
                                 userInfo:nil];
}

- (id)provideObjectFromObject:(id)input {
    return [self.provider provideObjectFromObject:[self massage:input]];
}

@end
