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
#import "MAGPredicateProvider.h"

static NSDictionary *magellanPayload;
static NSDictionary *cartagenaPayload;
static NSDictionary *trinidadPayload;
static NSArray *fleetPayload;
static NSManagedObjectContext *moc;
static id <MAGMapper> identityMapper, personMapper, shipMapper;
static NSEntityDescription *personEntity, *shipEntity;
static id <MAGProvider> personProvider, shipProvider;

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

    identityMapper = [MAGSubscripter subscripterWithKey:@"id" mapper:[MAGSetter setterWithKeyPath:@"identifier"]];

    personMapper = [MAGMappingSeries mappingSeriesWithMappers:@[identityMapper,
                                                                [MAGSubscripter subscripterWithKey:@"name" mapper:[MAGSetter setterWithKeyPath:@"name"]]]];

    personProvider = MAGEntityProvider(personEntity, moc, identityMapper, personMapper);

    shipMapper = [MAGMappingSeries mappingSeriesWithMappers:@[identityMapper,
                                                              [MAGSubscripter subscripterWithKey:@"name" mapper:[MAGSetter setterWithKeyPath:@"name"]],
                                                              [MAGSubscripter subscripterWithKey:@"captain" mapper:[MAGProvidingMapper providerMasseuseWithProvider:personProvider
                                                                                                                                                             mapper:[MAGSetter setterWithKeyPath:@"captain"]]]]];
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
    MAGEntityCreator *personCreator = [MAGEntityCreator entityCreatorWithEntityDescription:personEntity
                                                                    inManagedObjectContext:moc];
    [personCreator provideObjectFromObject:nil];
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
}

- (void)testEntityFind {
    id <MAGProvider> finder = [MAGProviderComposition providerCompositionWithInner:[MAGPredicateProvider predicateProviderWithMapper:identityMapper]
                                                                             outer:[MAGEntityFinder entityFinderWithEntityDescription:personEntity
                                                                                                               inManagedObjectContext:moc]];

    expect([finder provideObjectFromObject:magellanPayload]).to.beNil();

    id <MAGProvider> personCreator = [MAGMappedProvider mappedProviderWithProvider:[MAGEntityCreator entityCreatorWithEntityDescription:personEntity
                                                                                                                 inManagedObjectContext:moc]
                                                                            mapper:personMapper];
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellan = [personCreator provideObjectFromObject:magellanPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(1);

    expect([finder provideObjectFromObject:magellanPayload]).to.beIdenticalTo(magellan);
}

- (void)testEntityProvider {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGPerson *magellanOne = [personProvider provideObjectFromObject:magellanPayload];
    expect(magellanOne.name).to.equal(@"Ferdinand Magellan");
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    MAGPerson *magellanTwo = [personProvider provideObjectFromObject:magellanPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect(magellanOne).to.equal(magellanTwo);
    MAGPerson *cartagena = [personProvider provideObjectFromObject:cartagenaPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect(cartagena.name).to.equal(@"Juan de Cartagena");
}

- (void)testCollectionProvider {
    NSArray *peoplePayloads = @[magellanPayload, cartagenaPayload];
    MAGCollectionProvider *collectionProvider = [MAGCollectionProvider collectionProviderWithElementProvider:personProvider];

    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    NSArray *people = [collectionProvider provideObjectFromObject:peoplePayloads];
    expect([MAGPerson MR_countOfEntities]).to.equal(2);
    expect([people[0] name]).to.equal(@"Ferdinand Magellan");
}

- (void)testRelationship {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = [shipProvider provideObjectFromObject:trinidadPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);
    expect(trinidad.name).to.equal(@"Trinidad");
    expect(trinidad.captain.name).to.equal(@"Ferdinand Magellan");
}

- (void)testCollectionProviderDuplicates {
    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    expect([MAGShip MR_countOfEntities]).to.equal(0);

    MAGShip *trinidad = [shipProvider provideObjectFromObject:trinidadPayload];
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    expect([MAGShip MR_countOfEntities]).to.equal(1);

    MAGCollectionProvider *collectionProvider = [MAGCollectionProvider collectionProviderWithElementProvider:shipProvider];
    NSArray *ships = [collectionProvider provideObjectFromObject:fleetPayload];
    expect(ships).to.haveCountOf(fleetPayload.count);
    expect([MAGPerson MR_countOfEntities]).to.equal(5);
    expect([MAGShip MR_countOfEntities]).to.equal(5);
    expect(ships[0]).to.beIdenticalTo(trinidad);
}

@end
