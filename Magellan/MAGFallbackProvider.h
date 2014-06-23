//
//  MAGFallbackProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

// TODO: I hate every name in this class

@interface MAGFallbackProvider : NSObject <MAGProvider>

+ (id)fallbackProviderWithPrimary:(id <MAGProvider>)primary secondary:(id <MAGProvider>)secondary;

@property (nonatomic, strong, readonly) id <MAGProvider> primary;
@property (nonatomic, strong, readonly) id <MAGProvider> secondary;

@end
