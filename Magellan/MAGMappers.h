//
//  MAGMappers.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

@protocol MAGMapper, MAGProvider;
@class NSRelationshipDescription;

extern id <MAGMapper> MAGRelationshipMapper(NSRelationshipDescription *relationship, MAGProvider elementProvider, id <MAGMapper> mapper);
extern id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, MAGProvider elementProvider);
extern id <MAGMapper> MAGConvertInput(id <MAGMapper> mapper, MAGProvider provider);
extern id <MAGMapper> MAGConvertTarget(id <MAGMapper> mapper, MAGProvider provider);
