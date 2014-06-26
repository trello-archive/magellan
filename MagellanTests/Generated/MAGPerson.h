//
//  MAGPerson.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAGPerson, MAGShip;

@interface MAGPerson : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MAGShip *shipCaptaining;
@property (nonatomic, retain) MAGShip *shipCrewing;
@property (nonatomic, retain) NSOrderedSet *bestFriends;
@property (nonatomic, retain) NSSet *bestFrinverse;
@end

@interface MAGPerson (CoreDataGeneratedAccessors)

- (void)insertObject:(MAGPerson *)value inBestFriendsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBestFriendsAtIndex:(NSUInteger)idx;
- (void)insertBestFriends:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBestFriendsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBestFriendsAtIndex:(NSUInteger)idx withObject:(MAGPerson *)value;
- (void)replaceBestFriendsAtIndexes:(NSIndexSet *)indexes withBestFriends:(NSArray *)values;
- (void)addBestFriendsObject:(MAGPerson *)value;
- (void)removeBestFriendsObject:(MAGPerson *)value;
- (void)addBestFriends:(NSOrderedSet *)values;
- (void)removeBestFriends:(NSOrderedSet *)values;
- (void)addBestFrinverseObject:(MAGPerson *)value;
- (void)removeBestFrinverseObject:(MAGPerson *)value;
- (void)addBestFrinverse:(NSSet *)values;
- (void)removeBestFrinverse:(NSSet *)values;

@end
