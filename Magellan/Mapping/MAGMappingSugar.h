//
//  MAGMappingSugar.h
//  Magellan
//
//  Created by Ian Henry on 6/26/14.
//
//

#import <Foundation/Foundation.h>

extern id <MAGMapper> MAGMakeMapperWithFields(NSDictionary *fields);
extern id <MAGMapper> MAGMakeMapper(id obj);

@class NSEntityDescription, NSManagedObjectModel;
typedef NSEntityDescription *(^MAGEntityBlock)(Class c);

extern MAGEntityBlock MAGEntityMaker(NSManagedObjectContext *moc);

#define MAGKVP(kv) kv: kv