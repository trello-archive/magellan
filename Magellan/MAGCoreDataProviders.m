//
//  MAGCoreDataProviders.m
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

#import "MAGCoreDataProviders.h"
#import "MAGProviders.h"
#import <CoreData/CoreData.h>

extern MAGProvider MAGEntityCreator(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext) {
    NSCParameterAssert(entityDescription != nil);
    NSCParameterAssert(managedObjectContext != nil);
    return ^(id input) {
        return [NSEntityDescription insertNewObjectForEntityForName:entityDescription.name
                                             inManagedObjectContext:managedObjectContext];
    };
}


extern MAGProvider MAGEntityFinder(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext) {
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

MAGProvider MAGEntityProvider(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> mapper) {
    NSCParameterAssert(entity != nil);
    NSCParameterAssert(moc != nil);
    NSCParameterAssert(identityMapper != nil);
    NSCParameterAssert(mapper != nil);

    MAGProvider entityFinder = MAGCompose(MAGPredicateProvider(identityMapper),
                                          MAGEntityFinder(entity, moc));

    return MAGMappedProvider(MAGFallback(entityFinder,
                                         MAGEntityCreator(entity, moc)),
                             mapper);
}

