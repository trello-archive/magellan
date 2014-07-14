//
//  MAGMappingSugar.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGMappingSugar.h"
#import "MAGMapping.h"
#import <CoreData/CoreData.h>

extern id <MAGMapper> MAGMakeMapper(id obj) {
    if ([obj conformsToProtocol:@protocol(MAGMapper)]) {
        return obj;
    }

    if ([obj isKindOfClass:[NSDictionary class]]) {
        return MAGMakeMapperWithFields(obj);
    }

    if ([obj isKindOfClass:[NSString class]]) {
        return [MAGSetter setterWithKeyPath:obj];
    }

    MAGThrowF(@"Don't know how to make a mapper out of %@", obj);
}

extern id <MAGMapper> MAGMakeMapperWithFields(NSDictionary *fields) {
    NSMutableArray *mappers = [[NSMutableArray alloc] init];

    [fields enumerateKeysAndObjectsUsingBlock:^(id <NSCopying> key, id obj, BOOL *stop) {
        [mappers addObject:MAGConvertInput(MAGSubscripter(key), [MAGNilGuard nilGuardWithMapper:MAGMakeMapper(obj)])];
    }];

    return [MAGMappingSeries mappingSeriesWithMappers:mappers];
}

extern MAGEntityBlock MAGEntityMaker(NSManagedObjectContext *moc) {
    return ^(Class c) {
        NSArray *entities = moc.persistentStoreCoordinator.managedObjectModel.entities;
        NSPredicate *entityPredicate = [NSPredicate predicateWithFormat:@"managedObjectClassName = %@", NSStringFromClass(c)];
        return [entities filteredArrayUsingPredicate:entityPredicate].firstObject;
    };
}