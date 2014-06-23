//
//  MAGPerson.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MAGShip;

@interface MAGPerson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) MAGShip *ship;

@end
