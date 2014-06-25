//
//  MAGProviderMasseuse.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGProviderMasseuse : NSObject <MAGProvider>

- (instancetype)initWithProvider:(id <MAGProvider>)provider;

// protected
- (id)massage:(id)input;

@end

typedef MAGProviderMasseuse MAGProviderMasseur;