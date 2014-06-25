//
//  MAGSetter.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MAGSetter.h"

@interface MAGSetter ()

@property (nonatomic, copy) NSString *keyPath;

@end

@implementation MAGSetter

+ (instancetype)setterWithKeyPath:(NSString *)keyPath {
    MAGSetter *setter = [[MAGSetter alloc] init];
    setter.keyPath = keyPath;
    return setter;
}

- (void)map:(id)source to:(id)dest {
    [dest setValue:source forKeyPath:self.keyPath];
}

@end
