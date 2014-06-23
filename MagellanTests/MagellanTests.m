//
//  MagellanTests.m
//  MagellanTests
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <XCTest/XCTest.h>
#import "MAGModels.h"

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface MagellanTests : XCTestCase

@end

@implementation MagellanTests

+ (void)setUp {
    [super setUp];
    [MagicalRecord setDefaultModelFromClass:self];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

+ (void)tearDown {
    [super tearDown];
    [MagicalRecord cleanUp];
}

- (void)testPeople {
    MAGPerson *person = [MAGPerson MR_createEntity];
    person.name = @"Ferdinand Magellan";
    expect([MAGPerson MR_countOfEntities]).equal(1);
    expect(person.name).to.equal(@"Ferdinand Magellan");
}

@end
