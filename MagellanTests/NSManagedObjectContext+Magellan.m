//
//  NSManagedObjectContext+Magellan.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "NSManagedObjectContext+Magellan.h"

@implementation NSManagedObjectContext (Magellan)

- (NSError *)mag_deleteAllEntities {
    for (NSEntityDescription *entity in self.persistentStoreCoordinator.managedObjectModel.entities) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entity.name];
        request.includesPropertyValues = NO;
        request.includesSubentities = NO;
        NSError *error = nil;
        NSArray *results = [self executeFetchRequest:request error:&error];
        if (error) {
            return error;
        }
        for (NSManagedObject *object in results) {
            [self deleteObject:object];
        }
    }

    return nil;
}

@end
