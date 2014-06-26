//
//  MAGSubscripter.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGSubscripter.h"

@interface MAGSubscripter ()

@property (nonatomic, copy) id <NSCopying> key;

@end

@implementation MAGSubscripter

+ (instancetype)subscripterWithKey:(id <NSCopying>)key {
    MAGSubscripter *subscripter = [[self alloc] init];
    subscripter.key = key;
    return subscripter;
}

- (id)provideObjectFromObject:(id)input {
    return [input objectForKeyedSubscript:self.key];
}

@end
