//
//  MAGMapperMasseuse.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMapper.h"

@interface MAGMapperMasseuse : NSObject <MAGMapper>

- (instancetype)initWithMapper:(id <MAGMapper>)mapper;

@property (nonatomic, strong, readonly) id <MAGMapper> mapper;

// protected... need to figure out how to represent that
- (id)massage:(id)source;

@end

typedef MAGMapperMasseuse MAGMapperMasseur;