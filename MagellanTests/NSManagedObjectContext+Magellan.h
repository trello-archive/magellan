//
//  NSManagedObjectContext+Magellan.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Magellan)

- (NSError *)mag_deleteAllEntities;

@end
