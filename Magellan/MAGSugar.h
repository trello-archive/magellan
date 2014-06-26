//
//  MAGSugar.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>
#import "MAGMapper.h"

extern id <MAGMapper> MAGMakeMapperWithFields(NSDictionary *fields);
extern id <MAGMapper> MAGMakeMapper(id obj);

#define MAGKVP(kv) kv: kv