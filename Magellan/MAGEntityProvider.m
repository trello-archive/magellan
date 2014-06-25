//
//  MAGEntityProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGEntityProvider.h"
#import "MAGFallbackProvider.h"
#import "MAGEntityFinder.h"
#import "MAGEntityCreator.h"
#import "MAGMapper.h"
#import "MAGMappedProvider.h"

id <MAGProvider> MAGEntityProvider(MAGEntityFinder *entityFinder, id <MAGMapper> mapper) {
    NSCParameterAssert(entityFinder != nil);
    NSCParameterAssert(mapper != nil);

    MAGEntityCreator *entityCreator = [MAGEntityCreator entityCreatorWithEntityDescription:entityFinder.entityDescription
                                                                    inManagedObjectContext:entityFinder.managedObjectContext];
    MAGFallbackProvider *fallbackProvider = [MAGFallbackProvider fallbackProviderWithPrimary:entityFinder
                                                                                   secondary:entityCreator];

    return [MAGMappedProvider mappedProviderWithProvider:fallbackProvider mapper:mapper];
}

