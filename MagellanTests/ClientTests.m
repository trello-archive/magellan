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

@implementation ClientTests

+ (void)setUp {
    [super setUp];
    [MagicalRecord setDefaultModelFromClass:self];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    moc = [NSManagedObjectContext MR_defaultContext];

    AFHTTPRequestOperationManager *rom = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.example.org"]];
    client = [[MAGClient alloc] initWithRequestOperationManager:rom rootContext:moc];

    MAGEntityBlock entity = MAGEntityMaker([NSManagedObjectContext MR_defaultContext]);

    personConverter = MAGEntityConverter(entity([MAGPerson class]),
                                         MAGMakeMapper(@{@"id": @"identifier"}),
                                         MAGMakeMapper(@{MAGKVP(@"name")}));
}

- (void)tearDown {
    [moc mag_deleteAllEntities];
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
