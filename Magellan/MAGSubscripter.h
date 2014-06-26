//
//  MAGSubscripter.h
//  Magellan
//
//  Created by Ian Henry on 6/24/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGProvider.h"

@interface MAGSubscripter : NSObject <MAGProvider>

+ (instancetype)subscripterWithKey:(id <NSCopying>)key;

@property (nonatomic, copy, readonly) id <NSCopying> key;

@end
