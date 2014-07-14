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

extern MAGManagedConverter MAGEntityCreator(NSEntityDescription *entityDescription) {
    NSCParameterAssert(entityDescription != nil);
    return ^(id input, NSManagedObjectContext *moc) {
        return [NSEntityDescription insertNewObjectForEntityForName:entityDescription.name
                                             inManagedObjectContext:moc];
    };
}


extern MAGManagedConverter MAGEntityFinder(NSEntityDescription *entityDescription) {
    NSCParameterAssert(entityDescription != nil);
    return ^id(id predicate, NSManagedObjectContext *moc) {
        NSCParameterAssert([predicate isKindOfClass:[NSPredicate class]]);
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
        fetchRequest.predicate = predicate;
        NSError *error = nil;
        NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
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
            MAGThrow(@"More than one object matches the identity predicate");
        }
    };
}

MAGManagedConverter MAGEntityConverter(NSEntityDescription *entity, id <MAGMapper> identityMapper, id <MAGMapper> fieldsMapper) {
    NSCParameterAssert(entity != nil);
    NSCParameterAssert(identityMapper != nil);
    NSCParameterAssert(fieldsMapper != nil);

    return MAGDeferredBind(^(MAGBindingBlock bind) {
        MAGConverter entityFinder = MAGCompose(MAGPredicateConverter(identityMapper),
                                               bind(MAGEntityFinder(entity)));

        return MAGMappedConverter(MAGFallback(entityFinder,
                                              MAGMappedConverter(bind(MAGEntityCreator(entity)),
                                                                 identityMapper)),
                                  fieldsMapper);
    });
}
