//
//  MAGRouter.h
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import <Foundation/Foundation.h>

@class MAGRoute;

typedef void(^MAGRouteBlock)(Class c, NSString *format);

@interface MAGRouter : NSObject

+ (instancetype)routerWithBlock:(void(^)(MAGRouteBlock GET, MAGRouteBlock PUT, MAGRouteBlock POST, MAGRouteBlock DELETE, MAGRouteBlock ANY))block;

- (MAGRoute *)routeForClass:(Class)c method:(NSString *)method;
- (NSString *)routeObject:(id)obj method:(NSString *)method;

@end
