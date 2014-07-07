//
//  MAGRoute.m
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import "MAGRoute.h"

typedef NSString *(^MAGRouteComponent)(id obj);

@interface MAGRoute ()

@property (nonatomic, strong) NSArray *components;

@end

@implementation MAGRoute

+ (MAGRouteComponent)routeComponentWithFormat:(NSString *)format {
    if ([format hasPrefix:@":"]) {
        return ^(id obj) {
            return [obj valueForKeyPath:[format substringFromIndex:1]];
        };
    } else {
        return ^(id obj) {
            return format;
        };
    }
}

+ (instancetype)routeWithFormat:(NSString *)format {
    NSParameterAssert(format != nil);

    NSMutableArray *components = [[NSMutableArray alloc] init];
    for (NSString *componentFormat in [format componentsSeparatedByString:@"/"]) {
        [components addObject:[self routeComponentWithFormat:componentFormat]];
    }

    MAGRoute *this = [[MAGRoute alloc] init];
    this.components = components;
    return this;
}

- (NSString *)route:(id)object {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (MAGRouteComponent component in self.components) {
        [result addObject:component(object)];
    }
    return [result componentsJoinedByString:@"/"];
}

@end
