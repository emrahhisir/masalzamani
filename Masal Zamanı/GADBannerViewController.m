//
//  GADBannerViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <GADRequest.h>
#import "GADBannerViewController.h"
#import "LocationManager.h"
#import "GADRequestFactory.h"

#define kSampleAdUnitID @"ca-app-pub-1796711852238712/2298232587"

@interface GADBannerViewController ()

@property(nonatomic, strong) GADBannerView *adBanner;
@property(nonatomic) bool isFirstLoad;

@end

@implementation GADBannerViewController

#pragma mark -
#pragma mark ViewController Operations

- (void)viewDidLoad
{
    [super viewDidLoad];
	_isFirstLoad = YES;
    
    // Initialize the banner at the bottom of the screen.
    CGPoint origin = CGPointMake(0.0,
                                 self.view.bounds.size.height -
                                 CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    
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
#pragma mark GADBannerViewDelegate implementation

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    CGRect contentFrame = self.view.bounds;
    
    if (_isFirstLoad) {
        [UIView beginAnimations:@"BannerSlide" context:nil];
        
        BOOL isIOS7OrLater = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
        if (isIOS7OrLater) {
            contentFrame.size.height -= 2*bannerView.frame.size.height;
        }
        else {
            contentFrame.size.height -= bannerView.frame.size.height;
        }
        
        bannerView.frame = CGRectMake(0.0,
                                      contentFrame.size.height,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
        
        self.view.frame = contentFrame;
        
        [UIView commitAnimations];
    }
    
    _isFirstLoad = NO;
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    CGRect contentFrame = self.view.bounds;
    
    if (_isFirstLoad == NO) {
        [UIView beginAnimations:@"BannerSlide" context:nil];
        contentFrame.size.height += _adBanner.frame.size.height;
        self.view.frame = contentFrame;
        [UIView commitAnimations];
    }
    
    _isFirstLoad = YES;
}


@end
