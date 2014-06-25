//
//  MAGNilGuard.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGNilGuard.h"

@implementation MAGNilGuard

+ (instancetype)nilGuardWithMapper:(id <MAGMapper>)mapper {
    return [[self alloc] initWithMapper:mapper];
}

- (BOOL)shouldMap:(id)input {
    return input != nil;
}

@end
