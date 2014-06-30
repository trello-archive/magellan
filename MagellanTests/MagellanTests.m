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
static id <MAGMapper> identityMapper, personFieldsMapper, shipFieldsMapper;
static NSEntityDescription *personEntity, *shipEntity;
static MAGConverter personConverter, shipConverter;

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


    identityMapper = MAGConvertInput(MAGSubscripter(@"id"), [MAGSetter setterWithKeyPath:@"identifier"]);

    personFieldsMapper = [MAGMappingSeries mappingSeriesWithMappers:@[MAGConvertInput(MAGSubscripter(@"name"), [MAGSetter setterWithKeyPath:@"name"])]];

    personConverter = MAGEntityConverter(personEntity, moc, identityMapper, personFieldsMapper);

    shipFieldsMapper = [MAGMappingSeries mappingSeriesWithMappers:@[MAGConvertInput(MAGSubscripter(@"name"), [MAGSetter setterWithKeyPath:@"name"]),
                                                                    MAGConvertInput(MAGCompose(MAGSubscripter(@"captain"), personConverter), [MAGSetter setterWithKeyPath:@"captain"])]];
    shipConverter = MAGEntityConverter(shipEntity, moc, identityMapper, shipFieldsMapper);
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
    MAGConverter personCreator = MAGEntityCreator(personEntity, moc);
    personCreator(nil);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
}

- (void)testEntityFind {
    MAGConverter finder = MAGCompose(MAGPredicateConverter(identityMapper), MAGEntityFinder(personEntity, moc));

    expect(finder(magellanPayload)).to.beNil();

    MAGConverter personCreator = MAGMappedConverter(MAGMappedConverter(MAGEntityCreator(personEntity, moc), identityMapper), personFieldsMapper);
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellan = personCreator(magellanPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);

    expect(finder(magellanPayload)).to.beIdenticalTo(magellan);
}

- (void)testEntityConverter {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellanOne = personConverter(magellanPayload);
    expect(magellanOne.name).to.equal(@"Ferdinand Magellan");
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    MAGPerson *magellanTwo = personConverter(magellanPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect(magellanOne).to.equal(magellanTwo);
    MAGPerson *cartagena = personConverter(cartagenaPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(cartagena.name).to.equal(@"Juan de Cartagena");
}

- (void)testCollectionConverter {
    NSArray *peoplePayloads = @[magellanPayload, cartagenaPayload];
    MAGConverter collectionConverter = MAGCollectionConverter(personConverter);

    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    NSArray *people = collectionConverter(peoplePayloads);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect([people[0] name]).to.equal(@"Ferdinand Magellan");
}

- (void)testRelationship {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = shipConverter(trinidadPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.name).to.equal(@"Trinidad");
    expect(trinidad.captain.name).to.equal(@"Ferdinand Magellan");
}

- (void)testCollectionConverterDuplicates {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = shipConverter(trinidadPayload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);

    MAGConverter collectionConverter = MAGCollectionConverter(shipConverter);
    NSArray *ships = collectionConverter(fleetPayload);
    expect(ships).to.haveCountOf(fleetPayload.count);
    expect([MAGPerson MR_countOfEntities]).to.equal(5);
    expect([MAGShip MR_countOfEntities]).to.equal(5);
    expect(ships[0]).to.beIdenticalTo(trinidad);
}

- (void)testUnorderedToManyRelationship {
    id <MAGMapper> crewMapper = MAGMakeMapper(@{@"crewmembers": MAGRelationshipUnionMapper(shipEntity.relationshipsByName[@"crew"], personConverter)});
    id <MAGMapper> shipMapperWithCrew = [MAGMappingSeries mappingSeriesWithMappers:@[shipFieldsMapper, crewMapper]];
    MAGConverter shipConverterWithCrew = MAGEntityConverter(shipEntity, moc, identityMapper, shipMapperWithCrew);

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:trinidadPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    payload[@"crewmembers"] = @[magellanPayload];
    MAGShip *trinidad = shipConverterWithCrew(payload);
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.crew).to.haveCountOf(1);
    expect(trinidad.crew.anyObject).to.beIdenticalTo(trinidad.captain);

    payload[@"crewmembers"] = @[cartagenaPayload];
    expect(shipConverterWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);

    payload[@"crewmembers"] = @[];
    expect(shipConverterWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);

    [payload removeObjectForKey:@"crewmembers"];
    expect(shipConverterWithCrew(payload)).to.beIdenticalTo(trinidad);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(trinidad.crew).to.haveCountOf(2);
}

- (void)testOrderedToManyRelationship {
    id <MAGMapper> bestFriendsMapper = MAGMakeMapper(@{@"best_friends": MAGRelationshipUnionMapper(personEntity.relationshipsByName[@"bestFriends"], personConverter)});
    id <MAGMapper> personMapperWithFriends = [MAGMappingSeries mappingSeriesWithMappers:@[personFieldsMapper, bestFriendsMapper]];
    MAGConverter personConverterWithFriends = MAGEntityConverter(personEntity, moc, identityMapper, personMapperWithFriends);

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:magellanPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);

    payload[@"best_friends"] = @[cartagenaPayload];
    MAGPerson *magellan = personConverterWithFriends(payload);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(magellan.bestFriends).to.haveCountOf(1);

    payload[@"best_friends"] = @[@{@"id": @"123", @"name": @"Ian Henry"}];
    expect(personConverterWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");

    payload[@"best_friends"] = @[cartagenaPayload];
    expect(personConverterWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");

    [payload removeObjectForKey:@"best_friends"];
    expect(personConverterWithFriends(payload)).to.beIdenticalTo(magellan);
    expect([MAGPerson MR_countOfEntities]).to.equal(3);
    expect(magellan.bestFriends).to.haveCountOf(2);
    expect([[magellan.bestFriends objectAtIndex:0] name]).to.equal(@"Juan de Cartagena");
    expect([[magellan.bestFriends objectAtIndex:1] name]).to.equal(@"Ian Henry");
}

- (void)testCustomRelationshipMapper {
    id <MAGMapper> crewMapper = MAGMakeMapper(@{@"crewmembers": MAGRelationshipUnionMapper(shipEntity.relationshipsByName[@"crew"], personConverter)});
    id <MAGMapper> shipMapperWithCrew = [MAGMappingSeries mappingSeriesWithMappers:@[shipFieldsMapper, crewMapper]];
    MAGConverter shipConverterWithCrew = MAGEntityConverter(shipEntity, moc, identityMapper, shipMapperWithCrew);

    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:trinidadPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    payload[@"crewmembers"] = @[magellanPayload, cartagenaPayload];
    MAGShip *trinidad = shipConverterWithCrew(payload);
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.crew).to.haveCountOf(2);
    expect(trinidad.crew).to.contain(trinidad.captain);

    id <MAGMapper> crewRemover = MAGMakeMapper(@{@"crewmembers": MAGRelationshipMapper(shipEntity.relationshipsByName[@"crew"], personConverter, [MAGBlockMapper mapperWithBlock:^(NSSet *crew, NSMutableSet *target) {
        [target minusSet:crew];
    }])});

    payload[@"crewmembers"] = @[magellanPayload];
    [crewRemover map:payload to:trinidad];
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.crew).to.haveCountOf(1);
    expect(trinidad.crew).notTo.contain(trinidad.captain);
}

@end
