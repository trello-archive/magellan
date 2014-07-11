//
//  ClientTests.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <XCTAsyncTestCase/XCTAsyncTestCase.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import <Nocilla/Nocilla.h>
#import <PromiseKit/Promise.h>
#import "NSManagedObjectContext+Magellan.h"
#import "Magellan.h"
#import "MAGModels.h"

@interface ClientTests : XCTAsyncTestCase
@end

static MAGClient *client;
static NSManagedObjectContext *moc;
static MAGManagedConverter personConverter;

@interface NSDictionary (LSHTTPBodyCompliance) <LSHTTPBody>
@end

@implementation NSDictionary (LSHTTPBodyCompliance)
- (NSData *)data {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    NSAssert(data != nil, @"Error! %@", error.localizedDescription);
    return data;
}
@end

@implementation ClientTests

+ (void)setUp {
    [super setUp];
    [MagicalRecord setDefaultModelFromClass:self];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    moc = [NSManagedObjectContext MR_defaultContext];

    id <MAGMapper> personFieldsMapper = MAGMakeMapper(@{MAGKVP(@"name")});

    AFHTTPRequestOperationManager *rom = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.example.org/api"]];
    client = [[MAGClient alloc] initWithRequestOperationManager:rom
                                                    rootContext:moc
                                                         router:[MAGRouter routerWithBlock:^(MAGRouteBlock GET, MAGRouteBlock PUT, MAGRouteBlock POST, MAGRouteBlock DELETE, MAGRouteBlock ANY) {
        ANY([MAGPerson class], @"people/:identifier");
        POST([MAGPerson class], @"people");
    }] mappingProvider:[MAGMappingProvider mappingProviderForModel:moc.persistentStoreCoordinator.managedObjectModel block:^(MAGMapDefiner map) {
        map([MAGPerson class], personFieldsMapper);
    }]];

    MAGEntityBlock entity = MAGEntityMaker([NSManagedObjectContext MR_defaultContext]);

    personConverter = MAGEntityConverter(entity([MAGPerson class]),
                                         MAGMakeMapper(@{@"id": @"identifier"}),
                                         personFieldsMapper);

    [[LSNocilla sharedInstance] start];
}

+ (void)tearDown {
    [[LSNocilla sharedInstance] stop];
}

- (void)tearDown {
    [moc mag_deleteAllEntities];
    [[LSNocilla sharedInstance] clearStubs];
}

- (void)testBackgroundMapping {
    PMKPromise *promise = [client mapPayload:@{@"id": @"a",
                                               @"name": @"something"}
                               withConverter:personConverter];
    promise.then(^(MAGPerson *person){
        expect(person.name).to.equal(@"something");
        expect([MAGPerson MR_countOfEntities]).to.equal(1);
    });
    [self await:promise];
}

- (void)testMultipleMapping {
    [self await:[PMKPromise all:@[[client mapPayload:@{@"id": @"a",
                                                       @"name": @"something"}
                                       withConverter:personConverter],
                                  [client mapPayload:@{@"id": @"b",
                                                       @"name": @"something else"}
                                       withConverter:personConverter]]].then(^{
        expect([MAGPerson MR_countOfEntities]).to.equal(2);
    })];
}

- (void)testRaceMapping {
    [self await:[PMKPromise all:@[[client mapPayload:@{@"id": @"a",
                                                       @"name": @"something"}
                                       withConverter:personConverter],
                                  [client mapPayload:@{@"id": @"a",
                                                       @"name": @"something else"}
                                       withConverter:personConverter]]].then(^{
        expect([MAGPerson MR_countOfEntities]).to.equal(1);
    })];
}

- (void)testMainQueueRaceMapping {
    PMKPromise *background = [PMKPromise all:@[[client mapPayload:@{@"id": @"a",
                                                                    @"name": @"something"}
                                                    withConverter:personConverter],
                                               [client mapPayload:@{@"id": @"a",
                                                                    @"name": @"something else"}
                                                    withConverter:personConverter]]];

    expect([MAGPerson MR_countOfEntities]).to.equal(0);
    MAGBind(personConverter, moc)(@{@"id": @"a",
                                    @"name": @"main queue"});
    expect([MAGPerson MR_countOfEntities]).to.equal(1);
    [self await:background.then(^{
        expect([MAGPerson MR_countOfEntities]).to.equal(1);
    })];
}

- (void)testObjectPosting {
    stubRequest(@"POST", @"http://www.example.org/api/people")
    .andReturn(200)
    .withHeaders(@{ @"Content-Type": @"application/json" })
    .withBody(@{ @"identifier": @"a", @"name": @"Ferdinand" });

    MAGPerson *person = [MAGPerson MR_createEntity];
    person.name = @"Magellan";
    [self await:[client createObject:person].then(^(MAGPerson *personResponse) {
        expect(personResponse).to.beIdenticalTo(person);
        expect(person.name).to.equal(@"Ferdinand");
        expect(person.managedObjectContext).to.beIdenticalTo(moc);
        expect([MAGPerson MR_countOfEntities]).to.equal(1);
    })];
}

- (void)testObjectGettingWithUrl {
    stubRequest(@"GET", @"http://www.example.org/api/people/1")
    .andReturn(200)
    .withHeaders(@{ @"Content-Type": @"application/json" })
    .withBody(@{ @"identifier": @"1", @"name": @"Ferdinand Magellan" });

    [self await:[client get:@"http://www.example.org/api/people/1" withConverter:personConverter].then(^(MAGPerson *person) {
        expect(person.name).to.equal(@"Ferdinand Magellan");
        expect(person.managedObjectContext).to.beIdenticalTo(moc);
        expect([MAGPerson MR_countOfEntities]).to.equal(1);
    })];
}

- (void)await:(PMKPromise *)promise {
    [self prepare];
    promise.then(^{
        [self notify:kXCTUnitWaitStatusSuccess];
    }).catch(^{
        [self notify:kXCTUnitWaitStatusFailure];
    });
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:1.0];
}

@end
