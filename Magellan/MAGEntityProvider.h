//
//  MAGEntityProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

@protocol MAGMapper, MAGProvider;
@class MAGEntityFinder;

id <MAGProvider> extern MAGEntityProvider(MAGEntityFinder *entityFinder, id <MAGMapper> mapper);
