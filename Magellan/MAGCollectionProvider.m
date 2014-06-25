//
//  MAGCollectionProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGCollectionProvider.h"

@interface MAGCollectionProvider ()

@property (nonatomic, strong) id <MAGProvider> elementProvider;

@end

@implementation MAGCollectionProvider

+ (instancetype)collectionProviderWithElementProvider:(id <MAGProvider>)elementProvider {
    NSParameterAssert(elementProvider != nil);

    MAGCollectionProvider *collectionProvider = [[MAGCollectionProvider alloc] init];
    collectionProvider.elementProvider = elementProvider;
    return collectionProvider;
}

- (id)provideObjectFromObject:(id <NSObject, NSFastEnumeration>)collection {
    NSParameterAssert([collection conformsToProtocol:@protocol(NSFastEnumeration)]);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (id element in collection) {
        [result addObject:[self.elementProvider provideObjectFromObject:element]];
    }
    return result;
}

@end
