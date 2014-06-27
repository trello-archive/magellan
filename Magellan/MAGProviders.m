//
//  MAGProviders.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGProviders.h"
#import "MAGMutablePredicateProxy.h"

#define MAGCombinator(name, body) \
MAGProvider name(MAGProvider a, MAGProvider b) { \
    NSCParameterAssert(a != nil); \
    NSCParameterAssert(b != nil); \
    return ^(id input) { \
        return body; \
    }; \
}

MAGCombinator(MAGCompose, b(a(input)))
MAGCombinator(MAGFallback, a(input) ?: b(input))

extern MAGProvider MAGSubscripter(NSObject <NSCopying> *key) {
    NSCParameterAssert(key != nil);
    key = [key copy];
    return ^(id input) {
        return [input objectForKeyedSubscript:key];
    };
}

extern MAGProvider MAGKeyPathExtractor(NSString *keyPath) {
    NSCParameterAssert(keyPath != nil);
    keyPath = [keyPath copy];
    return ^(id input) {
        return [input valueForKeyPath:keyPath];
    };
}

extern MAGProvider MAGPredicateProvider(id <MAGMapper> mapper) {
    NSCParameterAssert(mapper != nil);
    return ^(id input) {
        MAGMutablePredicateProxy *proxy = [[MAGMutablePredicateProxy alloc] init];
        [mapper map:input to:proxy];
        return proxy.predicate;
    };
}

extern MAGProvider MAGMappedProvider(MAGProvider provider, id <MAGMapper> mapper) {
    NSCParameterAssert(provider != nil);
    NSCParameterAssert(mapper != nil);
    return ^(id input) {
        id object = provider(input);
        [mapper map:input to:object];
        return object;
    };
}

extern MAGProvider MAGCollectionProvider(MAGProvider elementProvider) {
    NSCParameterAssert(elementProvider != nil);
    return ^(id <NSObject, NSFastEnumeration> collection) {
        NSCParameterAssert([collection conformsToProtocol:@protocol(NSFastEnumeration)]);
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (id element in collection) {
            [result addObject:elementProvider(element)];
        }
        return result;
    };
}