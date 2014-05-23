//
//  DMLLocationsStack.h
//  Locations
//
//  Created by dongmeiliang on 5/22/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DMLLocationsStack : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext* managedObjectContext;

- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;

@end
