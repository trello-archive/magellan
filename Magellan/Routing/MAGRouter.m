//
//  MAGRouter.m
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import "MAGRouter.h"
#import "MAGRoute.h"

@interface MAGBoundRouteHelper ()
@property (nonatomic, strong) Class c;
@property (nonatomic, copy, readwrite) MAGBoundRouteBlock GET, PUT, POST, DELETE, ANY;
@end

@implementation MAGBoundRouteHelper

+ (instancetype)boundRouteHelperWithClass:(Class)c {
    MAGBoundRouteHelper *helper = [[MAGBoundRouteHelper alloc] init];
    helper.c = c;
    return helper;
}

@end

@interface MAGRouter ()

@property (nonatomic, copy) NSDictionary *routes;

@end

@implementation MAGRouter

+ (instancetype)routerWithBlock:(void(^)(MAGRouteHelper route))block {
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
            MAGThrowF(@"Already have a %@ route for %@", method, className);
        }
    };

    MAGBoundRouteBlock (^boundRoute)(Class c, NSString *method, __weak MAGBoundRouteHelper *helper) = ^(Class c, NSString *method, __weak MAGBoundRouteHelper *helper) {
        return ^(NSString *format) {
            addRoute(method, c, format);
            return helper;
        };
    };

    MAGRouteHelper route = ^(Class c){
        MAGBoundRouteHelper *helper = [MAGBoundRouteHelper boundRouteHelperWithClass:c];
        helper.GET = boundRoute(c, @"GET", helper);
        helper.POST = boundRoute(c, @"POST", helper);
        helper.PUT = boundRoute(c, @"PUT", helper);
        helper.DELETE = boundRoute(c, @"DELETE", helper);
        helper.ANY = boundRoute(c, @"", helper);
        return helper;
    };

    block(route);

    MAGRouter *router = [[MAGRouter alloc] init];
    router.routes = routes;
    return router;
}

// TODO: CAN RETURN NIL
- (MAGRoute *)routeForClass:(Class)c method:(NSString *)method {
    return self.routes[method][NSStringFromClass(c)] ?: self.routes[@""][NSStringFromClass(c)];
}

// TODO: CAN RETURN NIL
- (NSString *)routeObject:(id)obj method:(NSString *)method {
    return [[self routeForClass:[obj class] method:method] route:obj];
}

@end
