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

static id <MAGMapper> MAGSetUnioner() {
    return [MAGBlockMapper mapperWithBlock:^(NSSet *input, NSMutableSet *target) {
        NSCParameterAssert([target isKindOfClass:NSMutableSet.class]);
        NSCParameterAssert([input isKindOfClass:NSSet.class]);
        [target unionSet:input];
    }];
}

static id <MAGMapper> MAGOrderedSetUnioner() {
    return [MAGBlockMapper mapperWithBlock:^(NSOrderedSet *input, NSMutableOrderedSet *target) {
        NSCParameterAssert([target isKindOfClass:NSMutableOrderedSet.class]);
        NSCParameterAssert([input isKindOfClass:NSOrderedSet.class]);
        [target unionOrderedSet:input];
    }];
}

static MAGProvider MAGRelationshipExtractor(NSRelationshipDescription *relationship) {
    return ^id(NSManagedObject *input) {
        if (relationship.isOrdered) {
            return [input mutableOrderedSetValueForKeyPath:relationship.name];
        } else {
            return [input mutableSetValueForKeyPath:relationship.name];
        }
    };
}

id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, MAGProvider elementProvider) {
    return MAGRelationshipMapper(relationship, elementProvider, relationship.isOrdered ? MAGOrderedSetUnioner() : MAGSetUnioner());
}

id <MAGMapper> MAGRelationshipMapper(NSRelationshipDescription *relationship, MAGProvider elementProvider, id <MAGMapper> mapper) {
    NSCAssert(relationship.isToMany, @"MAGRelationshipMapper is only suitable for to-many relationships. For to-one, just use a setter with an entity providing masseuse.");
    NSCParameterAssert(relationship != nil);
    NSCParameterAssert(elementProvider != nil);
    NSCParameterAssert(mapper != nil);
    return [MAGNilGuard nilGuardWithMapper:[MAGMasseuse masseuseWithProvider:MAGCompose(MAGCollectionProvider(elementProvider), ^id(id input) {
        if (relationship.isOrdered) {
            return coerceToOrderedSet(input);
        } else {
            return coerceToSet(input);
        }
    }) mapper:MAGConvertTarget(mapper, MAGRelationshipExtractor(relationship))]];
}

extern id <MAGMapper> MAGConvertInput(id <MAGMapper> mapper, MAGProvider provider) {
    return [MAGMasseuse masseuseWithProvider:provider mapper:mapper];
}

extern id <MAGMapper> MAGConvertTarget(id <MAGMapper> mapper, MAGProvider provider) {
    return [MAGBlockMapper mapperWithBlock:^(id input, id target) {
        [mapper map:input to:provider(target)];
    }];
}