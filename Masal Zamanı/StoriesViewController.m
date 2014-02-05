//
//  StoriesViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/28/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "StoriesViewController.h"
#import "Story.h"
#import "DayStoryViewController.h"

@interface StoriesViewController ()

@end

@implementation StoriesViewController

@synthesize stories, title;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.stories = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:false];
    self.navigationItem.title = title;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stories count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = ((Story *)[stories objectAtIndex:[indexPath row]]).title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark Table View Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark Segue Management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Story"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Story *story = (Story *)[stories objectAtIndex:[indexPath row]];
        
        DayStoryViewController *dayStoryViewController = [segue destinationViewController];
        dayStoryViewController.textFilePath = story.text;
        dayStoryViewController.audioFilePath = story.audio;
        dayStoryViewController.title = story.title;
        dayStoryViewController.backgroundImagePath = story.backgroundImage;
        dayStoryViewController.textColor = story.textColor;
    }
}


@end
