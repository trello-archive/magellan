//
//  MAGCoreDataConverters.h
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

@class NSEntityDescription, NSManagedObjectContext;

extern MAGManagedConverter MAGEntityCreator(NSEntityDescription *entityDescription);
extern MAGManagedConverter MAGEntityFinder(NSEntityDescription *entityDescription);
extern MAGManagedConverter MAGEntityConverter(NSEntityDescription *entity, id <MAGMapper> identityMapper, id <MAGMapper> fieldsMapper);
