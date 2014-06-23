//
//  MAGShip.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAGPerson;

@interface MAGShip : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *people;
@end

@interface MAGShip (CoreDataGeneratedAccessors)

- (void)addPeopleObject:(MAGPerson *)value;
- (void)removePeopleObject:(MAGPerson *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

@end
