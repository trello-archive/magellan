//
//  MAGMappers.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

@protocol MAGMapper, MAGConverter;
@class NSRelationshipDescription;

extern id <MAGMapper> MAGRelationshipMapper(NSRelationshipDescription *relationship, MAGConverter elementConverter, id <MAGMapper> mapper);
extern id <MAGMapper> MAGRelationshipUnionMapper(NSRelationshipDescription *relationship, MAGConverter elementConverter);
extern id <MAGMapper> MAGConvertInput(MAGConverter provider, id <MAGMapper> mapper);
extern id <MAGMapper> MAGConvertTarget(MAGConverter provider, id <MAGMapper> mapper);
