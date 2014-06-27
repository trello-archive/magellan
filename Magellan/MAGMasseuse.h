//
//  MAGMasseuse.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>

@interface MAGMasseuse : NSObject <MAGMapper>

+ (instancetype)masseuseWithProvider:(MAGProvider)provider mapper:(id <MAGMapper>)mapper;

@end

typedef MAGMasseuse MAGMasseur;
