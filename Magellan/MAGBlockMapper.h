//
//  MAGBlockMapper.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>

@interface MAGBlockMapper : NSObject <MAGMapper>

+ (instancetype)mapperWithBlock:(void(^)(id input, id target))block;

@end
