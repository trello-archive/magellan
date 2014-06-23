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
#import "MAGMasseuse.h"

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
    expect(person.firstName).equal(@"John");
}

- (void)testKeyExtractor {
    Person *person = [[Person alloc] init];
    person.firstName = @"John";

    [[MAGKeyExtractor keyExtractorWithKeyPath:@"firstName" mapper:[MAGSetter setterWithKeyPath:@"lastName"]]
     map:person to:person];
    expect(person.firstName).equal(person.lastName);
}

- (void)testKeyExtractorWithPath {
    Person *person = [[Person alloc] init];
    person.firstName = @"John";

    [[MAGKeyExtractor keyExtractorWithKeyPath:@"firstName.length" mapper:[MAGSetter setterWithKeyPath:@"age"]]
     map:person to:person];
    expect(person.age).equal(4);
}


@end
