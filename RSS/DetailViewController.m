//
//  DetailViewController.m
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {

    // Update the view.
    [self configureView];
}

- (void)configureView {
    // Update the user interface for the detail item.
    _DetailWebView.scalesPageToFit = YES;
    NSURL *websiteUrl;
    if (self.webInfo) {
        websiteUrl = [NSURL URLWithString:[_webInfo objectForKey:@"link"]];
    }
    else {
        websiteUrl = [NSURL URLWithString:@"http://www.google.com"];
    }
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [_DetailWebView loadRequest:urlRequest];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_webInfo forKey:@"latestPage"];
    [defaults synchronize];
    
    [self isfavorite];
}

-(BOOL)isfavorite{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *dataArray = (NSArray*)[defaults objectForKey:@"favorites"];
//    if ([dataArray containsObject:self.webInfo]) {
//        _favo_logo.image = [UIImage imageNamed:@"star.png"];
//        return true;
//    }
//    else {
//        _favo_logo.image = nil;
//        return false;
//    }

    // file path
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    
    // Read
    NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    
    Article *favourite_file = (Article*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!favourite_file) {
        return false;
    }
    if (![favourite_file.favourite containsObject:self.webInfo]) {
        self.favo_logo.image = nil;
        NSLog(@"not my favourite");
        return false;
    }
    else {
        self.favo_logo.image = [UIImage imageNamed:@"star.png"];
        NSLog(@"my favourite");
        return true;
    }
    return false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _DetailWebView.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    _activeview.clipsToBounds = YES;
    _activeview.layer.cornerRadius = 10;    
    [self.DetailWebView addSubview: self.activeview];
    self.activeview.hidden = YES;
    
    [self.view bringSubviewToFront:self.favo_logo];
    
    [self.delegate  removeSplash:self sendObject:true];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    self.activeview.hidden = NO;

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.activeview.hidden = YES;

}


- (void)viewWillAppear:(BOOL)animated
{
//    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)favourite:(id)sender {
    if (!self.webInfo) {
        return;
    }
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *dataArray = (NSArray*)[defaults objectForKey:@"favorites"];
//    NSMutableArray *newArr = nil;
//    if (!dataArray) {
//        newArr = [[NSMutableArray alloc] init];
//    }
//    else {
//        newArr = [[NSMutableArray alloc] initWithArray:dataArray];
//    }
//    if (![newArr containsObject:self.webInfo]) {
//        [newArr addObject:self.webInfo];
//    }    
//    [defaults setObject:newArr forKey:@"favorites"];
//    [defaults synchronize];
    
    // file path
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    
    // Read
    NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    
    Article *favourite_file = (Article*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!favourite_file) {
        favourite_file = [[Article alloc] init];
        favourite_file.favourite = [[NSMutableArray alloc] initWithObjects:self.webInfo, nil];
    }
    if (![favourite_file.favourite containsObject:self.webInfo]) {
        [favourite_file.favourite addObject:self.webInfo];
    }
    
    // Write
    NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:favourite_file];
    [sessionData writeToURL:file atomically:NO];
    NSLog(@"Add into plist:%@ \n FILE: %@", favourite_file.favourite, file);
    
    [self isfavorite];    
}

- (IBAction)SendTwitter:(id)sender {
    if (!self.webInfo) {
        return;
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[[NSString alloc] initWithFormat: @"Share news %@ from %@", self.webInfo[@"title"], self.webInfo[@"link"]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO TWITTER ACCOUNTS\n" message:@"There are no Twitter accounts configured. You can add or create a Twitter account in Setting." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([[segue identifier] isEqualToString:@"popoverSegue"]) {
//        
//        UINavigationController *nvc = (UINavigationController*)segue.destinationViewController;
//        BookMarkTableViewController *bvc = (BookMarkTableViewController*)nvc.topViewController;
//        bvc.delegate = self;
//    }
    
    if ([segue.identifier isEqualToString:@"popoverSegue"]) {
        
        
        UINavigationController *destNav = segue.destinationViewController;
        BookMarkTableViewController *vc = (BookMarkTableViewController*)destNav.viewControllers.firstObject;
        vc.delegate =self;
        
        // This is the important part
        UIPopoverPresentationController *popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void)bookmark: (id)sender sendObject:(NSDictionary *)web_info{
    self.webInfo = web_info;
    [self configureView];
}

@end
