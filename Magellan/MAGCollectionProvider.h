//
//  MAGCollectionProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGCollectionProvider : NSObject <MAGProvider>

+ (instancetype)collectionProviderWithElementProvider:(id <MAGProvider>)provider;

@end
