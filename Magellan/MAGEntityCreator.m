//
//  MAGEntityCreator.m
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import "MAGEntityCreator.h"
#import <CoreData/CoreData.h>
#import "MAGMapper.h"

@interface MAGEntityCreator ()

@property (nonatomic, strong) NSEntityDescription *entityDescription;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation MAGEntityCreator

+ (instancetype)entityCreatorWithEntityDescription:(NSEntityDescription *)entityDescription
                            inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    MAGEntityCreator *provider = [[self alloc] init];
    provider.entityDescription = entityDescription;
    provider.managedObjectContext = managedObjectContext;
    return provider;
}

- (NSManagedObject *)provideObjectFromObject:(id)object {
    return [NSEntityDescription insertNewObjectForEntityForName:self.entityDescription.name
                                         inManagedObjectContext:self.managedObjectContext];
}

@end
