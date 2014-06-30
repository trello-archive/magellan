//
//  MAGNilGuard.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGGuard.h"

@interface MAGNilGuard : MAGGuard

+ (instancetype)nilGuardWithMapper:(id <MAGMapper>)mapper;

@end
