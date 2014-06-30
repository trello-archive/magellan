//
//  MappingTests.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <XCTest/XCTest.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "MAGMapping.h"

@interface MappingTests : XCTestCase
@end

@interface Person : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSUInteger age;
@end
@implementation Person @end

@implementation MappingTests

- (void)testSetter {
    Person *person = [[Person alloc] init];
    [[MAGSetter setterWithKeyPath:@"firstName"] map:@"John" to:person];
    expect(person.firstName).to.equal(@"John");
}

- (void)testKeyPathExtractor {
    Person *person = [[Person alloc] init];
    person.firstName = @"John";

    [MAGConvertInput(MAGKeyPathExtractor(@"firstName"), [MAGSetter setterWithKeyPath:@"lastName"])
     map:person to:person];
    expect(person.firstName).to.equal(person.lastName);
}

- (void)testKeyPathExtractorWithPath {
    Person *person = [[Person alloc] init];
    person.firstName = @"John";

    [MAGConvertInput(MAGKeyPathExtractor(@"firstName.length"), [MAGSetter setterWithKeyPath:@"age"])
     map:person to:person];
    expect(person.age).to.equal(4);
}

- (void)testSubscripting {
    Person *person = [[Person alloc] init];

    [MAGConvertInput(MAGSubscripter(@"name"), [MAGNilGuard nilGuardWithMapper:[MAGSetter setterWithKeyPath:@"firstName"]])
     map:@{@"name": @"Emily"} to:person];
    expect(person.firstName).to.equal(@"Emily");
}

- (void)testSubscriptingKeyNotFound {
    Person *person = [[Person alloc] init];

    id <MAGMapper> subscripter = MAGConvertInput(MAGSubscripter(@"name"), [MAGNilGuard nilGuardWithMapper:[MAGSetter setterWithKeyPath:@"firstName"]]);
    [subscripter map:@{@"name": @"Emily"} to:person];
    [subscripter map:@{} to:person];
    expect(person.firstName).to.equal(@"Emily");
}

@end
