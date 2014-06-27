//
//  MAGProviders.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

extern MAGProvider MAGCompose(MAGProvider inner, MAGProvider outer);
extern MAGProvider MAGFallback(MAGProvider primary, MAGProvider secondary);
extern MAGProvider MAGSubscripter(id <NSCopying> key);
extern MAGProvider MAGKeyPathExtractor(NSString *keyPath);
extern MAGProvider MAGPredicateProvider(id <MAGMapper> mapper);
extern MAGProvider MAGMappedProvider(MAGProvider provider, id <MAGMapper> mapper);
extern MAGProvider MAGCollectionProvider(MAGProvider elementProvider);