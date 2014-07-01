//
//  MAGConverters.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGConverters.h"
#import "MAGMutablePredicateProxy.h"

#define MAGCombinator(name, body) \
MAGConverter MAG##name(MAGConverter a, MAGConverter b) { \
NSCParameterAssert(a != nil); \
NSCParameterAssert(b != nil); \
return ^(id input) { \
return body; \
}; \
}


MAGCombinator(Compose, b(a(input)))
MAGCombinator(Fallback, a(input) ?: b(input))

extern MAGManagedConverter MAGLift(MAGConverter converter) {
    return ^(id input, NSManagedObjectContext *moc) {
        return converter(input);
    };
}

extern MAGConverter MAGBind(MAGManagedConverter converter, NSManagedObjectContext *moc) {
    return ^(id input) {
        return converter(input, moc);
    };
}

extern MAGManagedConverter MAGDeferredBind(MAGConverter(^block)(MAGBindingBlock bind)) {
    return ^(id input, NSManagedObjectContext *moc) {
        return block(^(MAGManagedConverter managedConverter) {
            return MAGBind(managedConverter, moc);
        })(input);
    };
}

extern MAGConverter MAGSubscripter(NSObject <NSCopying> *key) {
    NSCParameterAssert(key != nil);
    key = [key copy];
    return ^(id input) {
        return [input objectForKeyedSubscript:key];
    };
}

extern MAGConverter MAGKeyPathExtractor(NSString *keyPath) {
    NSCParameterAssert(keyPath != nil);
    keyPath = [keyPath copy];
    return ^(id input) {
        return [input valueForKeyPath:keyPath];
    };
}

extern MAGConverter MAGPredicateConverter(id <MAGMapper> mapper) {
    NSCParameterAssert(mapper != nil);
    return ^(id input) {
        MAGMutablePredicateProxy *proxy = [[MAGMutablePredicateProxy alloc] init];
        [mapper map:input to:proxy];
        return proxy.predicate;
    };
}

extern MAGConverter MAGMappedConverter(MAGConverter converter, id <MAGMapper> mapper) {
    NSCParameterAssert(converter != nil);
    NSCParameterAssert(mapper != nil);
    return ^(id input) {
        id object = converter(input);
        [mapper map:input to:object];
        return object;
    };
}

extern MAGConverter MAGCollectionConverter(MAGConverter elementConverter) {
    NSCParameterAssert(elementConverter != nil);
    return ^(id <NSObject, NSFastEnumeration> collection) {
        NSCParameterAssert([collection conformsToProtocol:@protocol(NSFastEnumeration)]);
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (id element in collection) {
            [result addObject:elementConverter(element)];
        }
        return result;
    };
}
