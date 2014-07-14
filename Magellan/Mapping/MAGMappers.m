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
    MAGThrowF(@"Can't coerce %@ into an ordered set", input);
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
    MAGThrowF(@"Can't coerce %@ into a set", input);
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

static MAGConverter MAGRelationshipExtractor(NSRelationshipDescription *relationship) {
    return ^id(NSManagedObject *input) {
        if (relationship.isOrdered) {
            return [input mutableOrderedSetValueForKeyPath:relationship.name];
        } else {
            return [input mutableSetValueForKeyPath:relationship.name];
        }
    };
}

id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, MAGConverter elementConverter) {
    return MAGRelationshipMapper(relationship, elementConverter, relationship.isOrdered ? MAGOrderedSetUnioner() : MAGSetUnioner());
}

id <MAGMapper> MAGRelationshipMapper(NSRelationshipDescription *relationship, MAGConverter elementConverter, id <MAGMapper> mapper) {
    NSCAssert(relationship.isToMany, @"MAGRelationshipMapper is only suitable for to-many relationships. For to-one, just use MAGConvertInput + MAGSetter.");
    NSCParameterAssert(relationship != nil);
    NSCParameterAssert(elementConverter != nil);
    NSCParameterAssert(mapper != nil);
    return [MAGNilGuard nilGuardWithMapper:MAGConvertInput(MAGCompose(MAGCollectionConverter(elementConverter), ^id(id input) {
        if (relationship.isOrdered) {
            return coerceToOrderedSet(input);
        } else {
            return coerceToSet(input);
        }
    }), MAGConvertTarget(MAGRelationshipExtractor(relationship), mapper))];
}

id <MAGMapper> MAGConvertInput(MAGConverter converter, id <MAGMapper> mapper) {
    NSCParameterAssert(mapper != nil);
    NSCParameterAssert(converter != nil);
    return [MAGBlockMapper mapperWithBlock:^(id input, id target) {
        [mapper map:converter(input) to:target];
    }];
}

id <MAGMapper> MAGConvertTarget(MAGConverter converter, id <MAGMapper> mapper) {
    NSCParameterAssert(mapper != nil);
    NSCParameterAssert(converter != nil);
    return [MAGBlockMapper mapperWithBlock:^(id input, id target) {
        [mapper map:input to:converter(target)];
    }];
}
