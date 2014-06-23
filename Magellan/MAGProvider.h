//
//  MAGProvider.h
//  Magellan
//
//  Created by Ian Henry on 6/23/14.
//
//

#import <Foundation/Foundation.h>

@protocol MAGProvider <NSObject>

- (id)provideObjectFromObject:(id)object;

@end
