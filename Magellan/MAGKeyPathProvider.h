//
//  MAGKeyPathProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGKeyPathProvider : NSObject <MAGProvider>

+ (instancetype)keyPathProviderWithKeyPath:(NSString *)keyPath;

@property (nonatomic, copy, readonly) NSString *keyPath;

@end
