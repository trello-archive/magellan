//
//  MAGBlockProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGBlockProvider : NSObject <MAGProvider>

+ (instancetype)providerWithBlock:(id(^)(id input))block;

@end
