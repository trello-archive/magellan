//
//  MAGMappers.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGMappers.h"
#import "MAGMapping.h"
#import <CoreData/CoreData.h>

static NSOrderedSet *coerceToOrderedSet(id input) {
    if ([input isKindOfClass:[NSOrderedSet class]]) {
        return input;
    }
    if ([input isKindOfClass:[NSArray class]]) {
        return [NSOrderedSet orderedSetWithArray:input];
    }
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Can't coerce %@ into a set", input]
                                 userInfo:nil];
}

static NSSet *coerceToSet(id input) {
    if ([input isKindOfClass:[NSSet class]]) {
        return input;
    }
    if ([input isKindOfClass:[NSOrderedSet class]]) {
        return [input set];
    }
    if ([input isKindOfClass:[NSArray class]]) {
        return [NSSet setWithArray:input];
    }
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Can't coerce %@ into a set", input]
                                 userInfo:nil];
}

id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, id <MAGProvider> provider) {
    NSCParameterAssert(relationship != nil);
    NSCParameterAssert(provider != nil);
    return [MAGNilGuard nilGuardWithMapper:[MAGMasseuse masseuseWithProvider:[MAGProviderComposition providerCompositionWithInner:[MAGCollectionProvider collectionProviderWithElementProvider:provider]
                                                                                                                            outer:[MAGBlockProvider providerWithBlock:^id(id input) {
        if (relationship.isOrdered) {
            return coerceToOrderedSet(input);
        } else {
            return coerceToSet(input);
        }
    }]] mapper:[MAGBlockMapper mapperWithBlock:^(id input, id target) {
        if (relationship.isOrdered) {
            [[target mutableOrderedSetValueForKeyPath:relationship.name] unionOrderedSet:input];
        } else {
            [[target mutableSetValueForKeyPath:relationship.name] unionSet:input];
        }
    }]]];
}
