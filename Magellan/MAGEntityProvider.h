//
//  MAGEntityProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

@protocol MAGMapper, MAGProvider;
@class NSEntityDescription, NSManagedObjectContext;

id <MAGProvider> extern MAGEntityProvider(NSEntityDescription *entity, NSManagedObjectContext *moc, id <MAGMapper> identityMapper, id <MAGMapper> mapper);
