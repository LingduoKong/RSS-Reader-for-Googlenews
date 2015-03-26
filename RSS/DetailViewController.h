//
//  DetailViewController.h
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkViewController.h"
#import <Social/Social.h>
#import "ActiveIndicateView.h"
#import "Article.h"

@protocol LoadDataFinishDelegate <NSObject>

-(void)removeSplash: (id)sender sendObject: (BOOL)isfinish;

@end


@interface DetailViewController : UIViewController <BookMarkToWebViewDelegate, UIWebViewDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *DetailWebView;
@property NSDictionary *webInfo;
- (IBAction)favourite:(id)sender;

- (IBAction)SendTwitter:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *favo_logo;

@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet ActiveIndicateView *activeview;

@property (weak,nonatomic) id<LoadDataFinishDelegate> delegate;

@end

