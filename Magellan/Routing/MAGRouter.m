//
//  MAGRouter.m
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import "MAGRouter.h"
#import "MAGRoute.h"

@interface MAGRouter ()

@property (nonatomic, copy) NSDictionary *routes;

@end

@implementation MAGRouter

+ (instancetype)routerWithBlock:(void(^)(MAGRouteBlock GET, MAGRouteBlock PUT, MAGRouteBlock POST, MAGRouteBlock DELETE, MAGRouteBlock ANY))block {
    NSParameterAssert(block != nil);

    NSMutableDictionary *routes = [[NSMutableDictionary alloc] init];

    void (^addRoute)(NSString *method, Class c, NSString *format) = ^(NSString *method, Class c, NSString *format) {
        if (routes[method] == nil) {
            routes[method] = [[NSMutableDictionary alloc] init];
        }
        NSString *className = NSStringFromClass(c);
        if (routes[method][className] == nil) {
            routes[method][className] = [MAGRoute routeWithFormat:format];
        } else {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:[NSString stringWithFormat:@"Already have a %@ route for %@", method, className]
                                         userInfo:nil];
        }
    };

    MAGRouteBlock (^route)(NSString *method) = ^(NSString *method) {
        return ^(Class c, NSString *format) {
            addRoute(method, c, format);
        };
    };


    block(route(@"GET"), route(@"PUT"), route(@"POST"), route(@"DELETE"), route(@""));

    MAGRouter *router = [[MAGRouter alloc] init];
    router.routes = routes;
    return router;
}

- (MAGRoute *)routeForClass:(Class)c method:(NSString *)method {
    return self.routes[method][NSStringFromClass(c)] ?: self.routes[@""][NSStringFromClass(c)];
}

- (NSString *)routeObject:(id)obj method:(NSString *)method {
    return [[self routeForClass:[obj class] method:method] route:obj];
}

@end
