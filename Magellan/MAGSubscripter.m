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

+ (instancetype)subscripterWithKey:(id <NSCopying>)key mapper:(id <MAGMapper>)mapper {
    MAGSubscripter *subscripter = [[self alloc] initWithMapper:mapper];
    subscripter.key = key;
    return subscripter;
}

- (id)massage:(id)source {
    return [source objectForKeyedSubscript:self.key];
}

@end
