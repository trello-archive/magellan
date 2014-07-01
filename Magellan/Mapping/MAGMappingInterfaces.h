//
//  MAGMappingInterfaces.h
//  Magellan
//
//  Created by Ian Henry on 6/27/14.
//
//

#import <Foundation/Foundation.h>

@protocol MAGMapper <NSObject>

- (void)map:(id)input to:(id)target;

@end

typedef id(^MAGConverter)(id input);

@class NSManagedObjectContext, NSManagedObject;
typedef id(^MAGManagedConverter)(id input, NSManagedObjectContext *moc);
