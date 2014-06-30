//
//  MAGCoreDataConverters.m
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

#import "MAGCoreDataConverters.h"
#import "MAGConverters.h"
#import "MAGMappingSeries.h"
#import <CoreData/CoreData.h>

extern MAGConverter MAGEntityCreator(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext) {
    NSCParameterAssert(entityDescription != nil);
    NSCParameterAssert(managedObjectContext != nil);
    return ^(id input) {
        return [NSEntityDescription insertNewObjectForEntityForName:entityDescription.name
                                             inManagedObjectContext:managedObjectContext];
    };
}


extern MAGConverter MAGEntityFinder(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext) {
    NSCParameterAssert(entityDescription != nil);
    NSCParameterAssert(managedObjectContext != nil);
    return ^id(id predicate) {
        NSCParameterAssert([predicate isKindOfClass:[NSPredicate class]]);
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
        fetchRequest.predicate = predicate;
        NSError *error = nil;
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:error.localizedFailureReason
                                         userInfo:@{@"error": error}];
        }

        if (results.count == 0) {
            return nil;
        } else if (results.count == 1) {
            return results.firstObject;
        } else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"More than one object matches the identity predicate"
                                         userInfo:nil];
        }

    };
}

MAGConverter MAGEntityConverter(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> fieldsMapper) {
    NSCParameterAssert(entity != nil);
    NSCParameterAssert(moc != nil);
    NSCParameterAssert(identityMapper != nil);
    NSCParameterAssert(fieldsMapper != nil);

    MAGConverter entityFinder = MAGCompose(MAGPredicateConverter(identityMapper),
                                          MAGEntityFinder(entity, moc));

    return MAGMappedConverter(MAGFallback(entityFinder,
                                         MAGMappedConverter(MAGEntityCreator(entity, moc),
                                                           identityMapper)),
                             fieldsMapper);
}
