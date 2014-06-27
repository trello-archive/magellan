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
#import "NSManagedObjectContext+Magellan.h"

static NSDictionary *magellanPayload;
static NSDictionary *cartagenaPayload;
static NSDictionary *trinidadPayload;
static NSArray *fleetPayload;
static NSManagedObjectContext *moc;
static id <MAGMapper> identityMapper, personMapper, shipMapper;
static NSEntityDescription *personEntity, *shipEntity;
static MAGProvider personProvider, shipProvider;

@interface MagellanTests : XCTestCase

@end

@implementation MagellanTests

+ (void)setUp {
    [super setUp];
    [MagicalRecord setDefaultModelFromClass:self];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];

    magellanPayload = @{@"id": @"a",
                        @"name": @"Ferdinand Magellan"};

    cartagenaPayload = @{@"id": @"b",
                         @"name": @"Juan de Cartagena"};

    trinidadPayload = @{@"id": @"a",
                        @"name": @"Trinidad",
                        @"captain": magellanPayload,
                        @"type": @"caravel"};

    fleetPayload = @[trinidadPayload,
                     @{@"id": @"b",
                       @"name": @"San Antonio",
                       @"captain": cartagenaPayload,
                       @"type": @"carrack"},
                     @{@"id": @"c",
                       @"name": @"Concepcion",
                       @"captain": @{@"id": @"c",
                                     @"name": @"Gaspar de Quesada"},
                       @"type": @"carrack"},
                     @{@"id": @"d",
                       @"name": @"Santiago",
                       @"captain": @{@"id": @"d",
                                     @"name": @"Juan Serrano"},
                       @"type": @"carrack"},
                     @{@"id": @"e",
                       @"name": @"Victoria",
                       @"captain": @{@"id": @"e",
                                     @"name": @"Luis Mendoza"},
                       @"type": @"carrack"}];

    moc = [NSManagedObjectContext MR_defaultContext];

    personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                               inManagedObjectContext:moc];
    shipEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGShip class])
                             inManagedObjectContext:moc];


    identityMapper = [MAGMasseuse masseuseWithProvider:MAGSubscripter(@"id")
                                                mapper:[MAGSetter setterWithKeyPath:@"identifier"]];

    personMapper = [MAGMappingSeries mappingSeriesWithMappers:@[identityMapper,
                                                                [MAGMasseuse masseuseWithProvider:MAGSubscripter(@"name")
                                                                                           mapper:[MAGSetter setterWithKeyPath:@"name"]]]];

    personProvider = MAGEntityProvider(personEntity, moc, identityMapper, personMapper);

    shipMapper = [MAGMappingSeries mappingSeriesWithMappers:@[identityMapper,
                                                              [MAGMasseuse masseuseWithProvider:MAGSubscripter(@"name")
                                                                                         mapper:[MAGSetter setterWithKeyPath:@"name"]],
                                                              [MAGMasseuse masseuseWithProvider:MAGCompose(MAGSubscripter(@"captain"), personProvider)
                                                                                         mapper:[MAGSetter setterWithKeyPath:@"captain"]]]];
    shipProvider = MAGEntityProvider(shipEntity, moc, identityMapper, shipMapper);
}

+ (void)tearDown {
    [super tearDown];
    [MagicalRecord cleanUp];
}

- (void)tearDown {
    expect([moc mag_deleteAllEntities]).to.equal(nil);
}

- (void)testPeople {
    MAGPerson *person = [MAGPerson MR_createEntity];
    person.name = @"Ferdinand Magellan";
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect(person.name).to.equal(@"Ferdinand Magellan");
}

- (void)testEntityCreator {
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                                                    inManagedObjectContext:moc];
    MAGProvider personCreator = MAGEntityCreator(personEntity, moc);
    personCreator(nil);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
}

- (void)testEntityFind {
    MAGProvider finder = MAGCompose(MAGPredicateProvider(identityMapper), MAGEntityFinder(personEntity, moc));

    expect(finder(magellanPayload)).to.beNil();

    MAGProvider personCreator = MAGMappedProvider(MAGEntityCreator(personEntity, moc), personMapper);
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellan = personCreator(magellanPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);

    expect(finder(magellanPayload)).to.beIdenticalTo(magellan);
}

- (void)testEntityProvider {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellanOne = personProvider(magellanPayload);
    expect(magellanOne.name).to.equal(@"Ferdinand Magellan");
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    MAGPerson *magellanTwo = personProvider(magellanPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect(magellanOne).to.equal(magellanTwo);
    MAGPerson *cartagena = personProvider(cartagenaPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(cartagena.name).to.equal(@"Juan de Cartagena");
}

- (void)testCollectionProvider {
    NSArray *peoplePayloads = @[magellanPayload, cartagenaPayload];
    MAGProvider collectionProvider = MAGCollectionProvider(personProvider);

    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    NSArray *people = collectionProvider(peoplePayloads);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect([people[0] name]).to.equal(@"Ferdinand Magellan");
}

- (void)testRelationship {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = shipProvider(trinidadPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.name).to.equal(@"Trinidad");
    expect(trinidad.captain.name).to.equal(@"Ferdinand Magellan");
}

- (void)testCollectionProviderDuplicates {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = shipProvider(trinidadPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);

    MAGProvider collectionProvider = MAGCollectionProvider(shipProvider);
    NSArray *ships = collectionProvider(fleetPayload);
    expect(ships).to.haveCountOf(fleetPayload.count);
    expect([MAGPerson MR_countOfEntities]).to.equal(5);
    expect([MAGShip MR_countOfEntities]).to.equal(5);
    expect(ships[0]).to.beIdenticalTo(trinidad);
}

- (void)testUnorderedToManyRelationship {
    id <MAGMapper> crewMapper = MAGMakeMapper(@{@"crewmembers": MAGRelationshipUnionMapper(shipEntity.relationshipsByName[@"crew"], personProvider)});
    id <MAGMapper> shipMapperWithCrew = [MAGMappingSeries mappingSeriesWithMappers:@[shipMapper, crewMapper]];
    MAGProvider shipProviderWithCrew = MAGEntityProvider(shipEntity, moc, identityMapper, shipMapperWithCrew);

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:trinidadPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    payload[@"crewmembers"] = @[magellanPayload];
    MAGShip *trinidad = shipProviderWithCrew(payload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.crew).to.haveCountOf(1);
    expect(trinidad.crew.anyObject).to.beIdenticalTo(trinidad.captain);

    payload[@"crewmembers"] = @[cartagenaPayload];
    expect(shipProviderWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);

    payload[@"crewmembers"] = @[];
    expect(shipProviderWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);

    [payload removeObjectForKey:@"crewmembers"];
    expect(shipProviderWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);
}

- (void)testOrderedToManyRelationship {
    id <MAGMapper> bestFriendsMapper = MAGMakeMapper(@{@"best_friends": MAGRelationshipUnionMapper(personEntity.relationshipsByName[@"bestFriends"], personProvider)});
    id <MAGMapper> personMapperWithFriends = [MAGMappingSeries mappingSeriesWithMappers:@[personMapper, bestFriendsMapper]];
    MAGProvider personProviderWithFriends = MAGEntityProvider(personEntity, moc, identityMapper, personMapperWithFriends);

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:magellanPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);

    payload[@"best_friends"] = @[cartagenaPayload];
    MAGPerson *magellan = personProviderWithFriends(payload);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(magellan.bestFriends).to.haveCountOf(1);

    payload[@"best_friends"] = @[@{@"id": @"123", @"name": @"Ian Henry"}];
    expect(personProviderWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");

    payload[@"best_friends"] = @[cartagenaPayload];
    expect(personProviderWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");

    [payload removeObjectForKey:@"best_friends"];
    expect(personProviderWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");
}

@end
