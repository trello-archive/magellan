//
//  MAGFallbackProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGFallbackProvider : NSObject <MAGProvider>

+ (instancetype)fallbackProviderWithPrimary:(id <MAGProvider>)primary secondary:(id <MAGProvider>)secondary;

@property (nonatomic, strong, readonly) id <MAGProvider> primary;
@property (nonatomic, strong, readonly) id <MAGProvider> secondary;

@end
