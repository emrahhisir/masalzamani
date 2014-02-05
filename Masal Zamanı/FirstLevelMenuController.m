//
//  FirstLevelMenuController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/23/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "FirstLevelMenuController.h"
#import "FirstLevelMenuItem.h"
#include "ImageStoriesViewController.h"
#include "Story.h"

@interface FirstLevelMenuController ()

- (NSMutableArray *)selectStories:(NSArray *)allStories;

@end

@implementation FirstLevelMenuController

@synthesize managedObjectContext, menus, title, inAppHelper=_inAppHelper;

- (void)viewDidLoad
{
    _inAppHelper = [IAPHelper sharedInstance];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.menus = nil;
    _inAppHelper = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:false];
    self.navigationItem.title = title;
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menus count] + self.isADLoaded;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    cell.textLabel.text = [[menus objectAtIndex:index] name];
}

-(void)viewDidLayoutSubviews {
    [self.view layoutIfNeeded];
}

#pragma mark -
#pragma mark Table view editing

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Stories"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FirstLevelMenuItem *menu = (FirstLevelMenuItem *)[menus objectAtIndex:[indexPath row] - self.isADLoaded];
        
        // Create the sort descriptor.
        NSSortDescriptor *storyTitleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:storyTitleDescriptor, nil];
        
        ImageStoriesViewController *nextViewController = [segue destinationViewController];
        nextViewController.stories = [self selectStories:[menu.stories sortedArrayUsingDescriptors:sortDescriptors]];
        nextViewController.navTitle = menu.name;
        nextViewController.selectedStoryIndex = 0;
    }
    
}

- (NSMutableArray *)selectStories:(NSArray *)allStories
{
    __block NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [allStories enumerateObjectsUsingBlock:^(Story *story, NSUInteger idx, BOOL *stop) {
        if ([_inAppHelper productPurchased:[_inAppHelper productIdentifier:story.text]] == NO) {
            [result addObject:story];
        }
    }];
    
    return result;
}

@end
