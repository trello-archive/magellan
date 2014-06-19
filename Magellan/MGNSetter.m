//
//  MGNSetter.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MGNSetter.h"

@interface MGNSetter ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MGNSetter

+ (instancetype)setterWithKeyPath:(NSString *)keyPath {
    MGNSetter *setter = [[MGNSetter alloc] init];
    setter.keyPath = keyPath;
    return setter;
}

- (MGNMappingResult)map:(id)source to:(id)dest {
    [dest setValue:source forKeyPath:self.keyPath];
    return MGNMappingResultSuccess;
}

@end
