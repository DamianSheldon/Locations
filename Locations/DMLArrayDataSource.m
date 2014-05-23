//
//  DMLArrayDataSource.m
//  Locations
//
//  Created by dongmeiliang on 5/22/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//

#import "DMLArrayDataSource.h"

@interface DMLArrayDataSource ()

@property (nonatomic, readwrite, strong) NSMutableArray *items;
@property (nonatomic, readwrite, copy) NSString *cellIdentifier;
@property (nonatomic, readwrite, copy) TableViewCellConfigureBlock configureCellBlock;
@end

@implementation DMLArrayDataSource

- (id)init
{
    return nil;
}

#pragma mark - Public Method

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger)indexPath.row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
 
     // Configure the cell...
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell, item);
 
     return cell;
 }



@end
