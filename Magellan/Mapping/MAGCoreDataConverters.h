//
//  MAGCoreDataConverters.h
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

@class NSEntityDescription, NSManagedObjectContext;

extern MAGConverter MAGEntityCreator(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext);
extern MAGConverter MAGEntityFinder(NSEntityDescription *entityDescription, NSManagedObjectContext *managedObjectContext);
extern MAGConverter MAGEntityConverter(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> fieldsMapper);
