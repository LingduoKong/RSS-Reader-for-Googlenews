//
//  MasterViewController.m
//  RSS
//
//  Created by Lingduo Kong on 2/14/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)downloadData {
    
    NSString* url = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=8&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss";
    
    [[SharedNetworking sharedSharedNetworking] getRSSForURL:url
                                                             success:^(NSMutableDictionary *array, NSError *error) {
                                                                 self.data = array[@"responseData"][@"feed"][@"entries"];
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     [self.tableView reloadData];
                                                                 });
                                                             }
                                                             failure:^{
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     NSLog(@"Cannot load data");
                                                                 });
                                                             }];

    if (self.refreshControl.refreshing) {
        [self.refreshControl endRefreshing];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* mode = [defaults objectForKey:@"read_mode_preference"];
    if ([mode integerValue]) {
        // night mode
        self.tableView.backgroundColor = [UIColor blackColor];
    }
    else {
        // day mode
        self.tableView.backgroundColor = [UIColor whiteColor];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* mode = [defaults objectForKey:@"read_mode_preference"];
    if ([mode integerValue]) {
        // night mode
        self.tableView.backgroundColor = [UIColor blackColor];
    }
    else {
        // day mode
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIRefreshControl *refreshMe = [[UIRefreshControl alloc] init];
    refreshMe.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull Me"];
    [refreshMe addTarget:self action:@selector(downloadData)
        forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshMe;
    self.refreshControl.tintColor = [UIColor redColor];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.detailViewController.delegate = self;
    
    // splash view delegate
    
    // get the info from notification center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(downloadData)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    // show the latest page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dataArray = (NSDictionary*)[defaults objectForKey:@"latestPage"];
    if (dataArray) {
        self.detailViewController.webInfo = dataArray;        
    }
    [self downloadData];
    
    //    Set the splash screen
    self.vc = [[UIViewController alloc] init];
    self.vc.view.backgroundColor = [UIColor yellowColor];
        
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UIImageView *v = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Chicago.jpg"]];
//        NSLog(@"The Launch Image: %@",v);
//        [self.vc.view addSubview:v];
//    }
    
    [self presentViewController:self.vc animated:NO completion:^{
        
        NSLog(@"Splash screen is showing");
    }];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = [self.data objectAtIndex: indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        // send info to detailview
        controller.webInfo = object;
        // splash view delegate
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    CGFloat title_height;
    CGFloat date_height;
    static UILabel* label;
    if (!label) {
        label = [[ UILabel alloc]
                 initWithFrame:CGRectMake(0,0, FLT_MAX, FLT_MAX)];
        label.text = @"test";
    }
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [label sizeToFit];
    title_height = label.frame.size.height;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [label sizeToFit];
    date_height = label.frame.size.height;
    return date_height + title_height + 20;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableDictionary *object = [self.data objectAtIndex: indexPath.row];
    cell.title.text = [object objectForKey:@"title"];
    cell.brief.text = [object objectForKey:@"contentSnippet"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSString *dateString = [object objectForKey:@"publishedDate"];
    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    NSDate *date = [[NSDate alloc] init];
    date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"MM dd yyyy"];
    cell.date.text = [formatter stringFromDate:date];
    
    // set the font for cell
    cell.title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.date.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cell.brief.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* mode = [defaults objectForKey:@"read_mode_preference"];
    if ([mode integerValue]) {
        // night mode
        cell.backgroundColor = [UIColor blackColor];
        cell.title.textColor = [UIColor whiteColor];
    }
    else {
        // day mode
        cell.backgroundColor = [UIColor whiteColor];
        cell.title.textColor = [UIColor blackColor];
    }
    
    return cell;
    
}


// remove the added view controller
-(void)removeSplash: (id)sender sendObject: (BOOL)isfinish{
    if (isfinish) {
        if (self.vc != nil) {
            [self.vc dismissViewControllerAnimated:YES completion:^{self.vc = nil;NSLog(@"remove splash view");}];
        }
    }
}

@end
