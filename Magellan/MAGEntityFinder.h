//
//  MAGEntityFinder.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@class NSManagedObjectContext, NSEntityDescription;

@interface MAGEntityFinder : NSObject <MAGProvider>

+ (instancetype)entityFinderWithEntityDescription:(NSEntityDescription *)entityDescription
                           inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic, strong, readonly) NSEntityDescription *entityDescription;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
