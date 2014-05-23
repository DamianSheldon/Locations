//
//  DMLDataManager.h
//  Locations
//
//  Created by dongmeiliang on 5/23/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"

@interface DMLDataManager : NSObject

+ (instancetype)sharedDataManager;

- (NSMutableArray *)fetchEventDataFromPersistentStore;

- (Event *)createEventCoordinate:(CLLocationCoordinate2D)coordinate
                    creationDate:(NSDate *)date
                           error:(NSError **)err;

@end
