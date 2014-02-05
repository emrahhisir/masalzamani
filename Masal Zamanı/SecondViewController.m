//
//  SecondViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#pragma warning disable

#import "SecondViewController.h"
#import "MenuItem.h"
#import "FirstLevelMenuItem.h"
#import "FirstLevelMenuController.h"

@interface SecondViewController ()

@property (nonatomic, strong) NSArray *menus;

- (void)getMenuItems;

@end

@implementation SecondViewController

@synthesize managedObjectContext=_managedObjectContext, menus, logger=_logger, noInternetConn=_noInternetConn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getMenuItems];
}

- (void)viewDidUnload
{
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.menus = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = NSLocalizedString(@"TopMenuTitle", @"Title of top menu view.");
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

#pragma mark -
#pragma mark Table view editing

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark -
#pragma mark Database operations

/*
 Gets the menu items.
 */
- (void)getMenuItems
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MenuItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptor.
    NSSortDescriptor *menuNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:menuNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    // Menu items fetch.
    NSError *error;
    menus = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        [_logger logMsg:[[NSString alloc] initWithFormat:@"SecondViewController:getMenuItems %@, %@\r\n", error, [error userInfo]]];
    }
}


#pragma mark - Segue management

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DownMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MenuItem *menu = (MenuItem *)[menus objectAtIndex:[indexPath row] - self.isADLoaded];
        
        // Create the sort descriptor.
        NSSortDescriptor *menuNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:menuNameDescriptor, nil];
        
        FirstLevelMenuController *nextViewController = [segue destinationViewController];
        nextViewController.managedObjectContext = _managedObjectContext;
        nextViewController.menus = [menu.downMenu sortedArrayUsingDescriptors:sortDescriptors];
        nextViewController.title = menu.name;
    }
    
}

#pragma mark -
#pragma mark Auto Rotate Operations

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
