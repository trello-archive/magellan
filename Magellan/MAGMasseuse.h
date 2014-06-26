//
//  MAGMasseuse.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMapper.h"

@protocol MAGProvider;

@interface MAGMasseuse : NSObject <MAGMapper>

+ (instancetype)masseuseWithProvider:(id <MAGProvider>)provider mapper:(id <MAGMapper>)mapper;

@property (nonatomic, strong, readonly) id <MAGProvider> provider;
@property (nonatomic, strong, readonly) id <MAGMapper> mapper;

@end

typedef MAGMasseuse MAGMasseur;

extern id <MAGProvider> MAGMassager(id <MAGProvider> provider, id <MAGMapper> massager);