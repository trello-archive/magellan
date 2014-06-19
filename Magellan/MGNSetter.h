//
//  MGNSetter.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MGNMapper.h"

@interface MGNSetter : NSObject <MGNMapper>

+ (instancetype)setterWithKeyPath:(NSString *)keyPath;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
