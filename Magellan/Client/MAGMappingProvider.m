//
//  MAGMappingProvider.m
//  Magellan
//
//  Created by Ian Henry on 7/10/14.
//
//

#import "MAGMappingProvider.h"
#import <CoreData/CoreData.h>

@interface MAGMappingProvider ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSDictionary *mappingMappings;

@end

@implementation MAGMappingProvider

+ (instancetype)mappingProviderForModel:(NSManagedObjectModel *)managedObjectModel block:(void(^)(MAGMapDefiner map))block {
    NSParameterAssert(managedObjectModel != nil);
    NSParameterAssert(block != nil);

    MAGMappingProvider *provider = [[MAGMappingProvider alloc] init];
    provider.managedObjectModel = managedObjectModel;

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    MAGMapDefiner mapFunction = ^(Class c, id <MAGMapper> mapper) {
        NSEntityDescription *entity = [provider entityForClass:c];
        NSAssert(dictionary[entity.name] == nil, @"You can't install more than one mapper for an entity! For more fine-grained control over mapping responses, MAGMappingProvider is not the way to go. Explicitly specify the mapper to use for each request that does not fit into this format.");
        dictionary[entity.name] = mapper;
    };

    block(mapFunction);
    provider.mappingMappings = dictionary;

    return provider;
}

- (NSEntityDescription *)entityForClass:(Class)c {
    NSString *className = NSStringFromClass(c);
    for (NSEntityDescription *entity in self.managedObjectModel.entities) {
        if ([entity.managedObjectClassName isEqualToString:className]) {
            return entity;
        }
    }

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"%@ does not appear to be the backing class for an entity in the provided managed object model", className]
                                 userInfo:nil];
}

// TODO: MAY RETURN NIL
- (id <MAGMapper>)mapperForEntity:(NSEntityDescription *)entity {
    if (entity == nil) {
        return nil;
    } else {
        return self.mappingMappings[entity.name] ?: [self mapperForEntity:entity.superentity];
    }
}

// TODO: MAY RETURN NIL
- (id <MAGMapper>)mapperForClass:(Class)c {
    NSParameterAssert(c != nil);
    return [self mapperForEntity:[self entityForClass:c]];
}

@end
