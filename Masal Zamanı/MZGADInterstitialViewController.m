//
//  GADInterstitialViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 11/19/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "MZGADInterstitialViewController.h"
#import "DayStoryViewController.h"
#import "LocationManager.h"
#import "GADRequestFactory.h"

#define INTERSTITIAL_AD_UNIT_ID @"ca-app-pub-1796711852238712/2919281782"

@interface MZGADInterstitialViewController ()

@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MZGADInterstitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:INTERSTITIAL_AD_UNIT_ID];
    
    _interstitial.delegate = self;
    [_interstitial loadRequest:[GADRequestFactory request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    _interstitial = nil;
}

/*
-(void)viewDidAppear:(BOOL)animated {
    if (_isFirstLoaded && (_textFilePath != nil)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"OpenDayStory"]) {
        DayStoryViewController *dayStoryViewController = [segue destinationViewController];
        dayStoryViewController.textFilePath = _textFilePath;
        dayStoryViewController.audioFilePath = _audioFilePath;
        dayStoryViewController.title = self.title;
        dayStoryViewController.backgroundImagePath = _backgroundImagePath;
        dayStoryViewController.textColor = _textColor;
        _isFirstLoaded = YES;
    }
}*/

#pragma mark -
#pragma mark GAD Operations

- (NSString *)interstitialAdUnitID {
    return INTERSTITIAL_AD_UNIT_ID;
}

/*
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    if (_textFilePath != nil) {
        [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
    }
}
*/

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [interstitial presentFromRootViewController:self];
}
/*
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    if (_textFilePath != nil) {
        [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
    }
}
*/

@end
