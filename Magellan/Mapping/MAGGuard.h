//
//  MAGGuard.h
//  Magellan
//
//  Created by Ian Henry on 6/25/14.
//
//

#import <Foundation/Foundation.h>

@interface MAGGuard : NSObject <MAGMapper>

- (instancetype)initWithMapper:(id <MAGMapper>)mapper;

@property (nonatomic, strong, readonly) id <MAGMapper> mapper;

// protected
- (BOOL)shouldMap:(id)input;

@end
