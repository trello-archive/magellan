//
//  MAGSubscripter.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGMasseuse.h"

@interface MAGSubscripter : MAGMasseuse

+ (instancetype)subscripterWithKey:(id <NSCopying>)key mapper:(id <MAGMapper>)mapper;

@property (nonatomic, copy, readonly) id <NSCopying> key;

@end
