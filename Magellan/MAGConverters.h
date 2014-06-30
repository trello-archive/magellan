//
//  MAGConverters.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

extern MAGConverter MAGCompose(MAGConverter inner, MAGConverter outer);
extern MAGConverter MAGFallback(MAGConverter primary, MAGConverter secondary);
extern MAGConverter MAGSubscripter(id <NSCopying> key);
extern MAGConverter MAGKeyPathExtractor(NSString *keyPath);
extern MAGConverter MAGPredicateConverter(id <MAGMapper> mapper);
extern MAGConverter MAGMappedConverter(MAGConverter provider, id <MAGMapper> mapper);
extern MAGConverter MAGCollectionConverter(MAGConverter elementConverter);