//
//  MappingTests.m
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import "MappingTests.h"
#import "Magellan.h"

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@end
@implementation Person @end

@implementation MappingTests

- (void)testSetter {
    Person *firstPerson = [[Person alloc] init];
    Person *secondPerson = [[Person alloc] init];
    MGNSetter *nameSetter = [MGNSetter setterWithKeyPath:@"name"];
    [nameSetter map:@"first name" to:firstPerson];
    expect(firstPerson.name).equal(@"first name");
    [[MGNKeyExtractor keyExtractorWithKeyPath:@"name" mapper:nameSetter] map:firstPerson to:secondPerson];
    expect(secondPerson.name).equal(@"first name");
}

@end
