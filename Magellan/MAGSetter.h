//
//  MAGSetter.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMapper.h"

@interface MAGSetter : NSObject <MAGMapper>

+ (instancetype)setterWithKeyPath:(NSString *)keyPath;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
