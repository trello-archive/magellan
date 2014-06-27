//
//  MAGMappers.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

@protocol MAGMapper, MAGProvider;
@class NSRelationshipDescription;

extern id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, MAGProvider elementProvider);
