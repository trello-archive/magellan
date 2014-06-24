//
//  MAGEntityProvider.m
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import "MAGEntityProvider.h"
#import "MAGFallbackProvider.h"
#import "MAGEntityFinder.h"
#import "MAGEntityCreator.h"
#import "MAGMapper.h"
#import <CoreData/CoreData.h>

@interface MAGEntityProvider ()

@property (nonatomic, strong) MAGFallbackProvider *fallbackProvider;
@property (nonatomic, strong) id <MAGMapper> mapper;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation MAGEntityProvider

+ (instancetype)entityProviderWithEntityFinder:(MAGEntityFinder *)entityFinder
                                        mapper:(id <MAGMapper>)mapper {
    NSParameterAssert(entityFinder != nil);
    NSParameterAssert(mapper != nil);
    MAGEntityProvider *entityProvider = [[MAGEntityProvider alloc] init];
    entityProvider.mapper = mapper;

    MAGEntityCreator *entityCreator = [MAGEntityCreator entityCreatorWithEntityDescription:entityFinder.entityDescription
                                                                    inManagedObjectContext:entityFinder.managedObjectContext];
    entityProvider.fallbackProvider = [MAGFallbackProvider fallbackProviderWithPrimary:entityFinder
                                                                             secondary:entityCreator];

    return entityProvider;
}

- (NSManagedObject *)provideObjectFromObject:(id)object {
    NSManagedObject *managedObject = [self.fallbackProvider provideObjectFromObject:object];
    [self.mapper map:object to:managedObject];
    return managedObject;
}

@end
