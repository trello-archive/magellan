//
//  MAGHelpers.h
//  Magellan
//
//  Created by Ian Henry on 7/14/14.
//
//

#define MAGThrow(x) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:x userInfo:nil]
#define MAGThrowF(...) @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:__VA_ARGS__] userInfo:nil]
