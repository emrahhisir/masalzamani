//
//  GADBannerViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <GADRequest.h>
#import "GADBannerTableViewController.h"
#import "LocationManager.h"
#import "GADRequestFactory.h"

#define kSampleAdUnitID @"ca-app-pub-1796711852238712/2298232587"

@interface GADBannerTableViewController ()

@property(nonatomic, strong) GADBannerView *adBanner;

@end

@implementation GADBannerTableViewController

#pragma mark -
#pragma mark ViewController Operations

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _isADLoaded = NO;
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID before compiling.
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.delegate = self;
    self.adBanner.rootViewController = self;
    [self.view addSubview:self.adBanner];
    [self.adBanner loadRequest:[GADRequestFactory request]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _adBanner.delegate = nil;
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark TableViewController Operations

-(void)configureCell:(UITableViewCell *)cell atIndex:(NSInteger)index {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isADLoaded && [indexPath row] == 0) {
        return _adBanner.frame.size.height;
    }
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    int rowIndex = [indexPath row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    
    if (_isADLoaded) {
        if (rowIndex == 0) {
            // Configure the cell.
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell addSubview:_adBanner];
        }
        else {
            // Configure the cell.
            [self configureCell:cell atIndex:rowIndex - 1];
        }
    }
    else {
        [self configureCell:cell atIndex:rowIndex];
    }
    
    return cell;
}

#pragma mark GADBannerViewDelegate implementation

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    _isADLoaded = YES;
    [self.tableView reloadData];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    _isADLoaded = NO;
    [self.tableView reloadData];
}


@end
