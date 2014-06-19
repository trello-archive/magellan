//
//  MGNMapper.h
//  Magellan
//
//  Created by Ian Henry on 6/19/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(BOOL, MGNMappingResult) {
    MGNMappingResultSuccess = YES,
    MGNMappingResultFailure = NO,
};

@protocol MGNMapper <NSObject>

- (MGNMappingResult)map:(id)source to:(id)dest;

@end
