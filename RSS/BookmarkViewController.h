//
//  BookMarkTableViewController.h
//  RSS
//
//  Created by Lingduo Kong on 2/15/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterTableViewCell.h"
#import "Article.h"

@protocol BookMarkToWebViewDelegate <NSObject>

-(void)bookmark: (id)sender sendObject: (NSDictionary*)web_info;

@end

@interface BookMarkTableViewController : UITableViewController
@property (weak,nonatomic) id<BookMarkToWebViewDelegate> delegate;
@property NSMutableArray * myFavourite;
@property NSArray *myKeys;

- (IBAction)tap:(id)sender;
- (IBAction)edit:(id)sender;

@end
