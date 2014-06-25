//
//  MAGMutablePredicateProxy.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import "MAGMutablePredicateProxy.h"

@interface MAGMutablePredicateProxy ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation MAGMutablePredicateProxy

- (instancetype)init {
    if (self = [super init]) {
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [self.dictionary setObject:value forKey:key];
}

- (NSPredicate *)predicate {
    NSMutableArray *components = [[NSMutableArray alloc] init];
    [self.dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id val, BOOL *stop) {
        [components addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, val]];
    }];
    return [NSCompoundPredicate andPredicateWithSubpredicates:components];
}

@end
