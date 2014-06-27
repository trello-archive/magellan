//
//  MAGCoreDataProviders.h
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

@class NSEntityDescription, NSManagedObjectContext;

extern MAGProvider MAGEntityCreator(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext);
extern MAGProvider MAGEntityFinder(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext);
extern MAGProvider MAGEntityProvider(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> fieldsMapper);
