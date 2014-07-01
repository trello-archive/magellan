//
//  MAGConverters.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

typedef MAGConverter(^MAGBindingBlock)(MAGManagedConverter managedConverter);

extern MAGManagedConverter MAGLift(MAGConverter a);
extern MAGConverter MAGBind(MAGManagedConverter converter, NSManagedObjectContext *moc);

extern MAGManagedConverter MAGDeferredBind(MAGConverter(^block)(MAGBindingBlock bind));

extern MAGConverter MAGCompose(MAGConverter inner, MAGConverter outer);
extern MAGConverter MAGFallback(MAGConverter primary, MAGConverter secondary);

extern MAGConverter MAGSubscripter(id <NSCopying> key);
extern MAGConverter MAGKeyPathExtractor(NSString *keyPath);
extern MAGConverter MAGPredicateConverter(id <MAGMapper> mapper);
extern MAGConverter MAGMappedConverter(MAGConverter converter, id <MAGMapper> mapper);
extern MAGConverter MAGCollectionConverter(MAGConverter elementConverter);
