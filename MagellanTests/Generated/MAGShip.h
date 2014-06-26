//
//  MAGShip.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAGPerson;

@interface MAGShip : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MAGPerson *captain;
@property (nonatomic, retain) NSSet *crew;
@end

@interface MAGShip (CoreDataGeneratedAccessors)

- (void)addCrewObject:(MAGPerson *)value;
- (void)removeCrewObject:(MAGPerson *)value;
- (void)addCrew:(NSSet *)values;
- (void)removeCrew:(NSSet *)values;

@end
