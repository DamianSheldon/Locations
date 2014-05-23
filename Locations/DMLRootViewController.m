//
//  DMLRootViewController.m
//  Locations
//
//  Created by dongmeiliang on 5/22/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

#import "DMLRootViewController.h"
#import "DMLArrayDataSource.h"
#import "Event.h"
#import "DMLDataManager.h"

@interface DMLRootViewController () <CLLocationManagerDelegate>

@property (nonatomic, readwrite, strong) DMLArrayDataSource  *arrayDataSource;
@property (nonatomic, readwrite, strong) NSMutableArray *eventArray;
@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;

@end

@implementation DMLRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem.target = self;
//    self.navigationItem.rightBarButtonItem.action = @selector(addEvent:);
    self.navigationItem.rightBarButtonItem.action = NSSelectorFromString(@"addEvent:");
    
    // Start the location manager.
	[self.locationManager startUpdatingLocation];
    
    self.eventArray = [[DMLDataManager sharedDataManager] fetchEventDataFromPersistentStore];
    
    [self setUpTableView];
}

- (void)setUpTableView
{
    TableViewCellConfigureBlock configureCellBlock = ^(UITableViewCell *cell, Event *item) {
        // A date formatter for the creation date.
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        }
        
        static NSNumberFormatter *numberFormatter = nil;
        if (numberFormatter == nil) {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:3];
        }
        
        cell.textLabel.text = [dateFormatter stringFromDate:[item creationDate]];
        
        NSString *string = [NSString stringWithFormat:@"%@, %@",
                            [numberFormatter stringFromNumber:[item latitude]],
                            [numberFormatter stringFromNumber:[item longitude]]];
        cell.detailTextLabel.text = string;
    };
    
    self.arrayDataSource = [[DMLArrayDataSource alloc] initWithItems:self.eventArray cellIdentifier:@"cell" configureCellBlock:configureCellBlock];

    self.tableView.dataSource = self.arrayDataSource;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (void)addEvent:(id)sender
{
	// If it's not possible to get a location, then return.
	CLLocation *location = [self.locationManager location];
	if (!location) {
		return;
	}
	
	// Commit the change.
	NSError *error;
    
    Event *event = [[DMLDataManager sharedDataManager] createEventCoordinate:[[self.locationManager location] coordinate] creationDate:[NSDate date] error:&error];
    
	if (error) {
		// Handle the error.
	}
	
    [self.eventArray insertObject:event atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (_locationManager != nil) {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager setDelegate:self];
	
	return _locationManager;
}


/**
 Conditionally enable the Add button:
 If the location manager is generating updates, then enable the button;
 If the location manager is failing, then disable the button.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

@end
