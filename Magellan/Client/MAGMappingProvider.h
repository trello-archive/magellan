//
//  MAGMappingProvider.h
//  Magellan
//
//  Created by Ian Henry on 7/10/14.
//
//

#import <Foundation/Foundation.h>

typedef void(^MAGMapDefiner)(Class c, id <MAGMapper> mapper);

@class NSManagedObjectModel;

@interface MAGMappingProvider : NSObject

+ (instancetype)mappingProviderForModel:(NSManagedObjectModel *)managedObjectModel block:(void(^)(MAGMapDefiner map))block;
- (id <MAGMapper>)mapperForClass:(Class)c;

@end
