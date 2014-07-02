//
//  MAGRoute.h
//  Magellan
//
//  Created by Ian Henry on 7/1/14.
//
//

#import <Foundation/Foundation.h>

@interface MAGRoute : NSObject

+ (instancetype)routeWithFormat:(NSString *)format;
- (NSString *)route:(id)object;

@end
