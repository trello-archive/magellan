//
//  MagellanTests.m
//  MagellanTests
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <XCTest/XCTest.h>
#import "MAGModels.h"
#import "MAGMapping.h"

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

static NSDictionary *magellanPayload;
static NSDictionary *trinidadPayload;
static NSManagedObjectContext *moc;

@interface MagellanTests : XCTestCase

@end

@implementation MagellanTests

+ (void)setUp {
    [super setUp];
    [MagicalRecord setDefaultModelFromClass:self];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];

    magellanPayload = @{@"id": @"a",
                        @"name": @"Ferdinand Magellan"};
    trinidadPayload = @{@"id": @"a",
                        @"name": @"Trinidad",
                        @"captain": magellanPayload,
                        @"type": @"caravel"};
    moc = [NSManagedObjectContext MR_defaultContext];
}

+ (void)tearDown {
    [super tearDown];
    [MagicalRecord cleanUp];
}

- (void)tearDown {
    [MAGPerson MR_deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
    [MAGShip MR_deleteAllMatchingPredicate:[NSPredicate predicateWithValue:YES]];
}

- (void)testPeople {
    MAGPerson *person = [MAGPerson MR_createEntity];
    person.name = @"Ferdinand Magellan";
    expect([MAGPerson MR_countOfEntities]).equal(1);
    expect(person.name).to.equal(@"Ferdinand Magellan");
}

- (void)testEntityCreator {
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                                                    inManagedObjectContext:moc];
    MAGEntityCreator *personCreator = [MAGEntityCreator entityProviderWithEntityDescription:personEntity
                                                                        inManagedObjectContext:moc];
    [personCreator provideObjectFromObject:nil];
    expect([MAGPerson MR_countOfEntities]).equal(1);
}

- (void)testEntityFindOrCreate {
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                                                    inManagedObjectContext:moc];
    MAGEntityCreator *personCreator = [MAGEntityCreator entityProviderWithEntityDescription:personEntity
                                                                     inManagedObjectContext:moc];
    MAGEntityFinder *personFinder = [MAGEntityFinder entityProviderWithEntityDescription:personEntity
                                                                  inManagedObjectContext:moc
                                                                               predicate:^(id source) {
                                                                                   return [NSPredicate predicateWithFormat:@"identifier = %@", [source valueForKey:@"id"]];
                                                                               }];

    MAGFallbackProvider *findOrCreateProvider = [MAGFallbackProvider fallbackProviderWithPrimary:personFinder
                                                                                   secondary:personCreator];

    expect([MAGPerson MR_countOfEntities]).equal(0);
    MAGPerson *personOne = [findOrCreateProvider provideObjectFromObject:@{@"id": @"a"}];
    personOne.identifier = @"a";
    expect([MAGPerson MR_countOfEntities]).equal(1);
    MAGPerson *personTwo = [findOrCreateProvider provideObjectFromObject:@{@"id": @"a"}];
    expect([MAGPerson MR_countOfEntities]).equal(1);
    expect(personOne).equal(personTwo);
    [findOrCreateProvider provideObjectFromObject:@{@"id": @"b"}];
    expect([MAGPerson MR_countOfEntities]).equal(2);
}


- (void)testNestedRelationship {
    NSArray *payload = @[trinidadPayload,
                         @{@"id": @"b",
                           @"name": @"San Antonio",
                           @"captain": @{@"id": @"b",
                                         @"name": @"Juan de Cartagena"},
                           @"type": @"carrack"},
                         @{@"identifier": @"c",
                           @"name": @"Concepcion",
                           @"captain": @{@"id": @"c",
                                         @"name": @"Gaspar de Quesada"},
                           @"type": @"carrack"},
                         @{@"identifier": @"d",
                           @"name": @"Santiago",
                           @"captain": @{@"id": @"d",
                                         @"name": @"Juan Serrano"},
                           @"type": @"carrack"},
                         @{@"identifier": @"e",
                           @"name": @"Victoria",
                           @"captain": @{@"id": @"e",
                                         @"name": @"Luis Mendoza"},
                           @"type": @"carrack"}];
}

@end
