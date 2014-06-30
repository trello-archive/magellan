//
//  PredicateTests.m
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <XCTest/XCTest.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "MAGMutablePredicateProxy.h"
#import "MAGMapping.h"

@interface PredicateTests : XCTestCase
@end

@interface MAGPlaceholder : NSObject
@property (nonatomic, copy) NSString *foo;
@property (nonatomic, copy) NSString *bar;
@end
@implementation MAGPlaceholder @end

@implementation PredicateTests

- (void)testPredicateProxy {
    id <MAGMapper> mapper = [MAGMappingSeries mappingSeriesWithMappers:@[MAGConvertInput(MAGSubscripter(@"key1"), [MAGSetter setterWithKeyPath:@"foo"]),
                                                                         MAGConvertInput(MAGSubscripter(@"key2"), [MAGSetter setterWithKeyPath:@"bar"])]];
    NSDictionary *payload = @{@"key1": @"doesn't matter",
                              @"key2": @"not really part of the test"};
    MAGMutablePredicateProxy *predicateProxy = [[MAGMutablePredicateProxy alloc] init];
    [mapper map:payload to:predicateProxy];

    MAGPlaceholder *dummy = [[MAGPlaceholder alloc] init];
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beFalsy();

    [mapper map:payload to:dummy];
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beTruthy();

    dummy.foo = @"something else";
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beFalsy();
}

- (void)testPredicateOverwrites {
    id <MAGMapper> mapper = [MAGMappingSeries mappingSeriesWithMappers:@[MAGConvertInput(MAGSubscripter(@"key1"), [MAGSetter setterWithKeyPath:@"foo"]),
                                                                         MAGConvertInput(MAGSubscripter(@"key2"), [MAGSetter setterWithKeyPath:@"foo"])]];
    NSDictionary *payload = @{@"key1": @"original",
                              @"key2": @"overwritten"};
    MAGMutablePredicateProxy *predicateProxy = [[MAGMutablePredicateProxy alloc] init];
    [mapper map:payload to:predicateProxy];

    MAGPlaceholder *dummy = [[MAGPlaceholder alloc] init];
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beFalsy();

    dummy.foo = @"overwritten";
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beTruthy();

    dummy.foo = @"original";
    expect([predicateProxy.predicate evaluateWithObject:dummy]).to.beFalsy();
}


@end
