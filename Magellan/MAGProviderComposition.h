//
//  MAGProviderComposition.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGProviderComposition : NSObject <MAGProvider>

+ (instancetype)providerCompositionWithInner:(id <MAGProvider>)inner outer:(id <MAGProvider>)outer;

@end
