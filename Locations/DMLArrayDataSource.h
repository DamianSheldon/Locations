//
//  DMLArrayDataSource.h
//  Locations
//
//  Created by dongmeiliang on 5/22/14.
//  Copyright (c) 2014 dongmeilianghy@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface DMLArrayDataSource : NSObject <UITableViewDataSource>

- (id)initWithItems:(NSMutableArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
