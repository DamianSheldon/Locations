//
//  DMLDataManager.m
//  Locations
//
//  Created by dongmeiliang on 5/23/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>

#import "DMLDataManager.h"

#import "DMLLocationsStack.h"
#import "Event.h"

@interface DMLDataManager ()

@property (nonatomic, readwrite, strong) DMLLocationsStack *locationsStack;


@end

@implementation DMLDataManager

- (instancetype) init
{
    return nil;
}

+ (instancetype)sharedDataManager
{
    static DMLDataManager *sDataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sDataManager = [[self alloc] initSingleton];
    });
    
    return sDataManager;
}

- (instancetype)initSingleton
{
    self = [super init];
    if (self) {
        self.locationsStack = [[DMLLocationsStack alloc] initWithStoreURL:[self storeURL] modelURL:[self modelURL]];
    }
    
    return self;
}

- (NSMutableArray *)fetchEventDataFromPersistentStore
{
    /*
	 Fetch existing events.
	 Create a fetch request; find the Event entity and assign it to the request; add a sort descriptor; then execute the fetch.
	 */
    
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.locationsStack.managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.locationsStack.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	 return mutableFetchResults;
}

- (Event *)createEventCoordinate:(CLLocationCoordinate2D)coordinate creationDate:(NSDate *)date error:(NSError **)err
{
    /*
	 Create a new instance of the Event entity.
	 */
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.locationsStack.managedObjectContext];
	
    //	// Configure the new event with information from the location.
    //	CLLocationCoordinate2D coordinate = [location coordinate];
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	
	// Should be the location's timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[event setCreationDate:date];
	
	[self.locationsStack.managedObjectContext save:err];
    
    return event;
}

#pragma mark - Utilities

- (NSURL*)storeURL
{
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"Locations.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Locations" withExtension:@"momd"];
}

@end
