//
//  MAGRouter.h
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import <Foundation/Foundation.h>

@class MAGRoute, MAGBoundRouteHelper;

typedef MAGBoundRouteHelper *(^MAGBoundRouteBlock)(NSString *format);
typedef MAGBoundRouteHelper *(^MAGRouteHelper)(Class c);

@interface MAGBoundRouteHelper : NSObject
@property (nonatomic, copy, readonly) MAGBoundRouteBlock GET, PUT, POST, DELETE, ANY;
@end

@interface MAGRouter : NSObject

+ (instancetype)routerWithBlock:(void(^)(MAGRouteHelper route))block;

- (MAGRoute *)routeForClass:(Class)c method:(NSString *)method;
- (NSString *)routeObject:(id)obj method:(NSString *)method;

@end
