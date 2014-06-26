//
//  MAGPredicateProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@protocol MAGMapper;

@interface MAGPredicateProvider : NSObject <MAGProvider>

+ (instancetype)predicateProviderWithMapper:(id <MAGMapper>)mapper;

@end
