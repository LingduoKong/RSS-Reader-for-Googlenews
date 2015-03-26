//
//  MasterViewController.h
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedNetworking.h"
#import "MasterTableViewCell.h"
#import "DetailViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController<LoadDataFinishDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property NSMutableArray* data;

@property UIViewController* vc;

@end

