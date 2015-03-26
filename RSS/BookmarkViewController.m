//
//  BookMarkTableViewController.m
//  RSS
//
//  Created by Lingduo Kong on 2/15/15.
//  Copyright (c) 2015 Lingduo Kong. All rights reserved.
//

#import "BookmarkViewController.h"

@interface BookMarkTableViewController ()

@end

@implementation BookMarkTableViewController

-(id)initWithStyle:(UITableViewStyle)style{
//    if ((self = [super initWithStyle:style])) {
//        if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
//            self.preferredContentSize = CGSizeMake(500, 500);
//        } else {
//            self.preferredContentSize = CGSizeMake(300, 400);
//        }
//    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *dataArray = (NSArray*)[defaults objectForKey:@"favorites"];
//    
//    dataArray = (NSArray*)[defaults objectForKey:@"favorites"];
//    self.myFavourite = [[NSMutableArray alloc] initWithArray:dataArray];
    
    
    // File path
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask appropriateForURL:nil
                                                create:YES error:&err];
    // Read
    NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    Article *favourite_bookmark= (Article*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.myFavourite = favourite_bookmark.favourite;
    NSLog(@"Retrieved By Book:%@ \n FILE: %@", favourite_bookmark.favourite, file);

}

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(300, 300); // size of view in popover
    self.preferredContentSize = size;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_myFavourite count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    MasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookMarkCell" forIndexPath:indexPath];
    NSMutableDictionary *object = [self.myFavourite objectAtIndex: indexPath.row];
    cell.title.text = [object objectForKey:@"title"];
    cell.brief.text = [object objectForKey:@"contentSnippet"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    NSString *dateString = [object objectForKey:@"publishedDate"];
    [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    NSDate *date = [[NSDate alloc] init];
    date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"MM dd yyyy"];
    cell.date.text = [formatter stringFromDate:date];

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    [label sizeToFit];
    date_height = label.frame.size.height;
    return date_height + title_height + 20;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
//        [_myFavourite removeObject: [_myFavourite objectAtIndex:indexPath.row]];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:_myFavourite forKey:@"favorites"];
//        [defaults synchronize];
        
        // File path
        NSError* err = nil;
        NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                                  inDomain:NSUserDomainMask appropriateForURL:nil
                                                    create:YES error:&err];
        // Read
        NSURL* file = [docs URLByAppendingPathComponent:@"sessions.plist"];
        NSData* data = [[NSData alloc] initWithContentsOfURL:file];
        Article *favourite_articles= (Article*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [favourite_articles.favourite removeObject: [self.myFavourite objectAtIndex:indexPath.row]];
        [self.myFavourite removeObject: [self.myFavourite objectAtIndex:indexPath.row]];
        // Write
        NSData* sessionData = [NSKeyedArchiver archivedDataWithRootObject:favourite_articles];
        [sessionData writeToURL:file atomically:NO];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate  bookmark:self sendObject: self.myFavourite[indexPath.row]];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tap:(id)sender {
    [self.tableView setEditing:NO animated:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)edit:(id)sender {
    if(self.tableView.editing == NO){
        [self.tableView setEditing:YES animated:YES];
        [sender setTitle: @"Done"];
    }
    else {
        [self.tableView setEditing:NO animated:YES];
        [sender setTitle: @"Edit"];
    }
}
@end


