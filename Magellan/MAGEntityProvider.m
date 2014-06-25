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
#import "MAGPredicateProvidingMasseuse.h"

id <MAGProvider> extern MAGEntityProvider(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> mapper) {
    NSCParameterAssert(entity != nil);
    NSCParameterAssert(moc != nil);
    NSCParameterAssert(identityMapper != nil);
    NSCParameterAssert(mapper != nil);

    id <MAGProvider> entityFinder = [MAGEntityFinder entityFinderWithEntityDescription:entity
                                                                inManagedObjectContext:moc];

    entityFinder = [MAGPredicateProvidingMasseuse predicateProvidingMasseuseWithMapper:identityMapper
                                                                              provider:entityFinder];

    MAGEntityCreator *entityCreator = [MAGEntityCreator entityCreatorWithEntityDescription:entity
                                                                    inManagedObjectContext:moc];

    MAGFallbackProvider *fallbackProvider = [MAGFallbackProvider fallbackProviderWithPrimary:entityFinder
                                                                                   secondary:entityCreator];

    return [MAGMappedProvider mappedProviderWithProvider:fallbackProvider mapper:mapper];
}

