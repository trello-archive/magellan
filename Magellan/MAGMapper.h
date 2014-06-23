//
//  MAGMapper.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(BOOL, MAGMappingResult) {
    MAGMappingResultSuccess = YES,
    MAGMappingResultFailure = NO,
};

@protocol MAGMapper <NSObject>

- (MAGMappingResult)map:(id)source to:(id)dest;

@end
