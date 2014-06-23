//
//  MGNMasseuse.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MGNMapper.h"

@interface MGNMasseuse : NSObject <MGNMapper>

- (instancetype)initWithMapper:(id <MGNMapper>)mapper;

@property (nonatomic, strong, readonly) id <MGNMapper> mapper;
- (id)massage:(id)source;

@end

typedef MGNMasseuse MGNMasseur;