//
//  SecondViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import "SearchViewController.h"
#import "Story.h"
#import "DayStoryViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) NSArray *resultStories;
@property (nonatomic, strong) Story *story;
@property (strong, nonatomic) SKProduct *buyProduct;

- (BOOL)searchStories:(NSString *)searchText;
- (void)openStory:(UIButton *)sender;

@end

@implementation SearchViewController

@synthesize managedObjectContext, resultStories, logger=_logger, HUD, priceFormatter=_priceFormatter, story=_story, noInternetConn=_noInternetConn, inAppHelper=_inAppHelper, buyProduct=_buyProduct;

- (void)viewDidLoad
{
    [DownloadController close];
    _inAppHelper = [IAPHelper sharedInstance];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)dealloc {
    HUD = nil;
    _priceFormatter = nil;
    _story = nil;
    resultStories = nil;
    managedObjectContext = nil;
    _logger = nil;
}

- (void)didReceiveMemoryWarning
{
    HUD = nil;
    _priceFormatter = nil;
    _story = nil;
    resultStories = nil;
    managedObjectContext = nil;
    _logger = nil;
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = NSLocalizedString(@"SearchTitle", @"Title of search view.");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Query operations

- (NSString *)replaceUnicodeChars:(NSString *)searchText
{
    NSString *result = [searchText stringByReplacingOccurrencesOfString:@"u" withString:@"ü"];
    result = [result stringByReplacingOccurrencesOfString:@"u" withString:@"ü"];
    result = [result stringByReplacingOccurrencesOfString:@"c" withString:@"ç"];
    result = [result stringByReplacingOccurrencesOfString:@"U" withString:@"Ü"];
    result = [result stringByReplacingOccurrencesOfString:@"C" withString:@"Ç"];
    result = [result stringByReplacingOccurrencesOfString:@"o" withString:@"ö"];
    result = [result stringByReplacingOccurrencesOfString:@"O" withString:@"Ö"];
    result = [result stringByReplacingOccurrencesOfString:@"g" withString:@"ğ"];
    result = [result stringByReplacingOccurrencesOfString:@"G" withString:@"Ğ"];
    result = [result stringByReplacingOccurrencesOfString:@"s" withString:@"ş"];
    result = [result stringByReplacingOccurrencesOfString:@"S" withString:@"Ş"];
    result = [result stringByReplacingOccurrencesOfString:@"i" withString:@"ı"];
    result = [result stringByReplacingOccurrencesOfString:@"İ" withString:@"I"];

    return result;
}

- (BOOL)searchStories:(NSString *)searchText
{
    BOOL result = YES;
    
    NSError *error;
    NSPredicate *predicateQuery = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ OR title CONTAINS[cd] %@", searchText, [self replaceUnicodeChars:searchText]];
    // Gets story of day.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Story" inManagedObjectContext:managedObjectContext];
    
    // Create the sort descriptor.
    NSSortDescriptor *menuNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:menuNameDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicateQuery];
    
    resultStories = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        result = NO;
    }
    
    return result;
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    for (UIView *subview in self.searchDisplayController.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UIButton")]) {
            [(UIButton *)subview setTitle:NSLocalizedString(@"Cancel", @"Search bar cancel button.") forState:UIControlStateNormal];
        }
        else {
            for(UIView *subSubView in [subview subviews]) {
                if([subSubView isKindOfClass:NSClassFromString(@"UIButton")]) {
                    [(UIButton *)subSubView setTitle:NSLocalizedString(@"Cancel", @"Search bar cancel button.") forState:UIControlStateNormal];
                }
            }
        }
    }
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    resultStories = nil;
    [self.tableView reloadData];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return [self searchStories:searchString];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultStories count] + self.isADLoaded;
}

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    cell.textLabel.text = [[resultStories objectAtIndex:index] title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        _story = (Story *)[resultStories objectAtIndex:[indexPath row] - self.isADLoaded];
        [self openStory:nil];
    }
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
    if ([[segue identifier] isEqualToString:@"Story"]) {
        DayStoryViewController *dayStoryViewController = [segue destinationViewController];
        dayStoryViewController.textFilePath = _story.text;
        dayStoryViewController.audioFilePath = _story.audio;
        dayStoryViewController.title = _story.title;
        dayStoryViewController.backgroundImagePath = _story.backgroundImage;
        dayStoryViewController.textColor = _story.textColor;
    }
    
}

- (void)openStory:(UIButton *)sender
{
    if (_noInternetConn == NO) {
        NSString *productIdentifier = [_inAppHelper productIdentifier:_story.text];
        _buyProduct = [_inAppHelper findProduct:productIdentifier];
        
        if (_buyProduct == nil) {
            UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ProductNotFound", @"Urun Bulunamadi") delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [notification show];
            notification = nil;
        }
        else if ([_inAppHelper productPurchased:productIdentifier]) {
            [self performSegueWithIdentifier:@"Story" sender:nil];
        }
        else {
             [_priceFormatter setLocale:_buyProduct.priceLocale];
             
             NSString *content = [NSString stringWithFormat:NSLocalizedString(@"BuyProductContent", @"Buy content"), _story.title, _buyProduct.price.floatValue];
             
             UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button") otherButtonTitles:NSLocalizedString(@"BuyButton", @"Buy button"), nil];
             notification.tag = BUY_ALERT_VIEW_TAG;
             [notification show];
             notification = nil;
        }
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BUY_ALERT_VIEW_TAG && buttonIndex != [alertView cancelButtonIndex]) {
        [_inAppHelper buyProduct:_buyProduct];
        _buyProduct = nil;
        
        /*if (HUD == nil) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = NSLocalizedString(@"Loading", @"Load view");
            HUD.delegate = self;
        }
        
        // Begins user interaction disable.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        */
    }
}

#pragma mark -
#pragma mark In App Purchase Operations

- (void)productPurchased:(NSNotification *)notification {
    // Ends user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self performSegueWithIdentifier:@"Story" sender:nil];
}


@end
