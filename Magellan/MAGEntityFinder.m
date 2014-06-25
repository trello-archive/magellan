//
//  MAGEntityFinder.m
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import "MAGEntityFinder.h"
#import <CoreData/CoreData.h>

@interface MAGEntityFinder ()

@property (nonatomic, strong) NSEntityDescription *entityDescription;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation MAGEntityFinder

+ (instancetype)entityFinderWithEntityDescription:(NSEntityDescription *)entityDescription
                           inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSParameterAssert(entityDescription != nil);
    NSParameterAssert(managedObjectContext != nil);
    MAGEntityFinder *provider = [[self alloc] init];
    provider.entityDescription = entityDescription;
    provider.managedObjectContext = managedObjectContext;
    return provider;
}

- (NSManagedObject *)provideObjectFromObject:(NSPredicate *)predicate {
    NSParameterAssert([predicate isKindOfClass:[NSPredicate class]]);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityDescription.name];
    fetchRequest.predicate = predicate;
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
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
}


@end
