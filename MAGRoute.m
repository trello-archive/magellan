//
//  MAGRoute.m
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import "MAGRoute.h"

@interface MAGRoute ()
@property (nonatomic, strong) NSArray *components;
@end

@protocol MAGRouteComponent <NSObject>
- (NSString *)route:(id)object;
@end

@interface MAGRouteLiteralComponent : NSObject <MAGRouteComponent>
@property (nonatomic, copy) NSString *string;
+ (instancetype)componentWithString:(NSString *)string;
@end

@interface MAGRouteKeyPathComponent : NSObject <MAGRouteComponent>
@property (nonatomic, copy) NSString *keyPath;
+ (instancetype)componentWithKeyPath:(NSString *)keyPath;
@end

@implementation MAGRouteLiteralComponent

+ (instancetype)componentWithString:(NSString *)string {
    MAGRouteLiteralComponent *this = [[self alloc] init];
    this.string = string;
    return this;
}

- (NSString *)route:(id)object {
    return self.string;
}

@end

@implementation MAGRouteKeyPathComponent

+ (instancetype)componentWithKeyPath:(NSString *)keyPath {
    MAGRouteKeyPathComponent *this = [[self alloc] init];
    this.keyPath = keyPath;
    return this;
}

- (NSString *)route:(id)object {
    return [object valueForKeyPath:self.keyPath];
}

@end

@implementation MAGRoute

+ (id <MAGRouteComponent>)routeComponentWithFormat:(NSString *)format {
    if ([format hasPrefix:@":"]) {
        return [MAGRouteKeyPathComponent componentWithKeyPath:[format substringFromIndex:1]];
    } else {
        return [MAGRouteLiteralComponent componentWithString:format];
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
    for (id <MAGRouteComponent> component in self.components) {
        [result addObject:[component route:object]];
    }
    return [result componentsJoinedByString:@"/"];
}

@end
