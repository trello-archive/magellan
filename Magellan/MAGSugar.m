//
//  MAGSugar.m
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import "MAGSugar.h"
#import "MAGMapping.h"

extern id <MAGMapper> MAGMakeMapper(id obj) {
    if ([obj conformsToProtocol:@protocol(MAGMapper)]) {
        return obj;
    }

    if ([obj isKindOfClass:[NSDictionary class]]) {
        return MAGMakeMapperWithFields(obj);
    }

    if ([obj isKindOfClass:[NSString class]]) {
        return [MAGSetter setterWithKeyPath:obj];
    }

    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"Don't know how to make a mapper out of %@", obj]
                                 userInfo:@{@"obj": obj}];
}

extern id <MAGMapper> MAGMakeMapperWithFields(NSDictionary *fields) {
    NSMutableArray *mappers = [[NSMutableArray alloc] init];

    [fields enumerateKeysAndObjectsUsingBlock:^(id <NSCopying> key, id obj, BOOL *stop) {
        [mappers addObject:[MAGMasseuse masseuseWithProvider:[MAGSubscripter subscripterWithKey:key]
                                                      mapper:[MAGNilGuard nilGuardWithMapper:MAGMakeMapper(obj)]]];
    }];

    return [MAGMappingSeries mappingSeriesWithMappers:mappers];
}
