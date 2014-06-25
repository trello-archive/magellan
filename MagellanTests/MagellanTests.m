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
static NSManagedObjectContext *moc;
static id <MAGMapper> personMapper, shipMapper;
static MAGEntityFinder *personFinder, *shipFinder;
static NSEntityDescription *personEntity, *shipEntity;
static MAGEntityProvider *personProvider, *shipProvider;

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

    moc = [NSManagedObjectContext MR_defaultContext];

    personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                               inManagedObjectContext:moc];
    shipEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGShip class])
                               inManagedObjectContext:moc];

    personMapper = [MAGMappingSeries mappingSeriesWithMappers:@[[MAGSubscripter subscripterWithKey:@"id" mapper:[MAGSetter setterWithKeyPath:@"identifier"]],
                                                                [MAGSubscripter subscripterWithKey:@"name" mapper:[MAGSetter setterWithKeyPath:@"name"]]]];

    shipMapper = [MAGMappingSeries mappingSeriesWithMappers:@[[MAGSubscripter subscripterWithKey:@"id" mapper:[MAGSetter setterWithKeyPath:@"identifier"]],
                                                              [MAGSubscripter subscripterWithKey:@"name" mapper:[MAGSetter setterWithKeyPath:@"name"]]]];

    personFinder = [MAGEntityFinder entityFinderWithEntityDescription:personEntity
                                               inManagedObjectContext:moc
                                                            predicate:^(id source) {
                                                                return [NSPredicate predicateWithFormat:@"identifier = %@", [source valueForKey:@"id"]];
                                                            }];

    personProvider = [MAGEntityProvider entityProviderWithEntityFinder:personFinder mapper:personMapper];

    shipFinder = [MAGEntityFinder entityFinderWithEntityDescription:shipEntity
                                             inManagedObjectContext:moc
                                                          predicate:^(id source) {
                                                              return [NSPredicate predicateWithFormat:@"identifier = %@", [source valueForKey:@"id"]];
                                                          }];

    shipProvider = [MAGEntityProvider entityProviderWithEntityFinder:shipFinder mapper:shipMapper];
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
    expect([MAGPerson MR_countOfEntities]).equal(1);
    expect(person.name).to.equal(@"Ferdinand Magellan");
}

- (void)testEntityCreator {
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:NSStringFromClass([MAGPerson class])
                                                    inManagedObjectContext:moc];
    MAGEntityCreator *personCreator = [MAGEntityCreator entityCreatorWithEntityDescription:personEntity
                                                                    inManagedObjectContext:moc];
    [personCreator provideObjectFromObject:nil];
    expect([MAGPerson MR_countOfEntities]).equal(1);
}

- (void)testEntityFindOrCreate {
    MAGEntityCreator *personCreator = [MAGEntityCreator entityCreatorWithEntityDescription:personEntity
                                                                    inManagedObjectContext:moc];

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

- (void)testEntityProvider {
    expect([MAGPerson MR_countOfEntities]).equal(0);
    MAGPerson *magellanOne = [personProvider provideObjectFromObject:magellanPayload];
    expect(magellanOne.name).equal(@"Ferdinand Magellan");
    expect([MAGPerson MR_countOfEntities]).equal(1);
    MAGPerson *magellanTwo = [personProvider provideObjectFromObject:magellanPayload];
    expect([MAGPerson MR_countOfEntities]).equal(1);
    expect(magellanOne).equal(magellanTwo);
    MAGPerson *cartagena = [personProvider provideObjectFromObject:cartagenaPayload];
    expect([MAGPerson MR_countOfEntities]).equal(2);
    expect(cartagena.name).equal(@"Juan de Cartagena");
}

- (void)testCollectionProvider {
    NSArray *peoplePayloads = @[magellanPayload, cartagenaPayload];
    MAGCollectionProvider *collectionProvider = [MAGCollectionProvider collectionProviderWithElementProvider:personProvider];

    expect([MAGPerson MR_countOfEntities]).equal(0);
    NSArray *people = [collectionProvider provideObjectFromObject:peoplePayloads];
    expect([MAGPerson MR_countOfEntities]).equal(2);
    expect([people[0] name]).equal(@"Ferdinand Magellan");
}

- (void)testNestedRelationship {
    NSArray *payload = @[trinidadPayload,
                         @{@"id": @"b",
                           @"name": @"San Antonio",
                           @"captain": cartagenaPayload,
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
