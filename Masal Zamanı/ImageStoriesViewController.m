//
//  ImageStoriesViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 5/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "ImageStoriesViewController.h"
#import "DayStory.h"
#import "Story.h"
#import "DayStoryViewController.h"

@interface ImageStoriesViewController ()

@property (strong, nonatomic) IBOutlet UILabel *storyTitle;
@property (strong, nonatomic) IBOutlet UILabel *imageNumber;
@property (strong, nonatomic) IBOutlet UIButton *audioIndicator;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *hideAudioIcon;
@property (strong, nonatomic) SKProduct *buyProduct;

- (void)checkEndOfDownload;
- (void)openStory:(UIButton *)sender;

@end

@implementation ImageStoriesViewController

@synthesize HUD, loadOrder, downloader, managedObjectContext=_managedObjectContext, logger=_logger, navTitle, stories, selectedStoryIndex, audioIndicator=_audioIndicator, carousel, images, hideAudioIcon, inAppHelper, priceFormatter=_priceFormatter, noInternetConn=_noInternetConn, buyProduct=_buyProduct;

#pragma mark -
#pragma mark View Load Operations

- (void)viewDidLoad
{
    inAppHelper = [IAPHelper sharedInstance];
    
    [super viewDidLoad];
    
    loadOrder = E_LOAD_FIRST;
    selectedStoryIndex = 0;
    
    carousel.type = iCarouselTypeRotary;
    [carousel setScrollSpeed:0.5];
    carousel.delegate = self;
    carousel.dataSource = self;
    
    images = [[NSMutableArray alloc] init];
    hideAudioIcon = [[NSMutableArray alloc] init];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText = NSLocalizedString(@"Loading", @"Load view");
    HUD.dimBackground = YES;
	HUD.delegate = self;
    
    [DownloadController close];
    downloader = [DownloadController sharedInstance];
    [downloader setDelegate:self];
    
    _audioIndicator.layer.borderColor = CGColorRetain([UIColor whiteColor].CGColor);
    _audioIndicator.layer.borderWidth = 2.0f;
    _audioIndicator.layer.cornerRadius = 8.0f;
    _audioIndicator.clipsToBounds = YES;
    [_audioIndicator setHidden:YES];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if (navTitle == nil) {
        stories = [inAppHelper purchasedProducts:nil];
    }
    
    [self setStory];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    carousel.delegate = nil;
    carousel.dataSource = nil;
    carousel = nil;
    [self setStoryTitle:nil];
    [self setAudioIndicator:nil];
    HUD.delegate = nil;
    HUD = nil;
    downloader = nil;
    images = nil;
    hideAudioIcon = nil;
    _managedObjectContext = nil;
    _logger = nil;
    navTitle = nil;
    _audioIndicator = nil;
    inAppHelper = nil;
    _priceFormatter = nil;
    _buyProduct = nil;
}

-(void)dealloc
{
    carousel.delegate = nil;
    carousel.dataSource = nil;
    carousel = nil;
    [self setStoryTitle:nil];
    [self setAudioIndicator:nil];
    HUD.delegate = nil;
    HUD = nil;
    downloader = nil;
    images = nil;
    hideAudioIcon = nil;
    _managedObjectContext = nil;
    _logger = nil;
    navTitle = nil;
    _audioIndicator = nil;
    inAppHelper = nil;
    _priceFormatter = nil;
    _buyProduct = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:false];
    
    downloader = [DownloadController sharedInstance];
    [downloader setDelegate:self];

    if (navTitle == nil) {
        self.navigationItem.title = @"Masallarım";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Geri Yükle" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
    }
    else {
        self.navigationItem.title = navTitle;
    }
    
    if (loadOrder != E_LOAD_THIRD) {
        [self setStory];
    }
    else {
        [self checkEndOfDownload];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productRestored:) name:IAPHelperProductRestoredNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)restoreTapped:(id)sender {
    [inAppHelper restoreCompletedTransactions];
}

#pragma mark -
#pragma mark Fetch Operations

- (void)setStory
{
    if ([stories count] > 0) {
        Story *story = (Story *)[stories objectAtIndex:selectedStoryIndex];
        
        /*[stories enumerateObjectsUsingBlock:^(Story *obj, NSUInteger idx, BOOL *stop) {
         NSLog(@"LIST %d. %@", idx, obj.text);
         }];*/
        
        // Begins user interaction disable.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [DownloadController download:[story.image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [HUD hide:YES];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == BUY_ALERT_VIEW_TAG && buttonIndex != [alertView cancelButtonIndex]) {
        [inAppHelper buyProduct:_buyProduct];
        _buyProduct = nil;
    }
}

#pragma mark -
#pragma mark Segue Operations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Story *story = nil;
    
    if ([[segue identifier] isEqualToString:@"OpenDayStory"]) {
        story = (Story *)[stories objectAtIndex:carousel.currentItemIndex];
        
        DayStoryViewController *dayStoryViewController = [segue destinationViewController];
        dayStoryViewController.textFilePath = story.text;
        dayStoryViewController.audioFilePath = story.audio;
        dayStoryViewController.title = story.title;
        dayStoryViewController.backgroundImagePath = story.backgroundImage;
        dayStoryViewController.textColor = story.textColor;
    }
}

- (void)openStory:(UIButton *)sender
{
    if (navTitle != nil) {
        Story *story = (Story *)[stories objectAtIndex:self.carousel.currentItemIndex];
        _buyProduct = [inAppHelper findProduct:[inAppHelper productIdentifier:story.text]];
        
        if (_buyProduct == nil) {
            UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ProductNotFound", @"Urun Bulunamadi") delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
            [notification show];
            notification = nil;
        }
        else {
            [_priceFormatter setLocale:_buyProduct.priceLocale];
            
            NSString *content = [NSString stringWithFormat:NSLocalizedString(@"BuyProductContent", @"Buy content"), story.title, _buyProduct.price.floatValue];
            
            UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button") otherButtonTitles:NSLocalizedString(@"BuyButton", @"Buy button"), nil];
            notification.tag = BUY_ALERT_VIEW_TAG;
            [notification show];
            notification = nil;
        }
    }
    else {
        [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
    }
}

#pragma mark -
#pragma mark DownloadControllerDelegate

- (void)dataDownloadFailed:(NSString *)reason
{
    HUD.mode = MBProgressHUDModeText;
	HUD.labelText = @"İnternet Bağlantısı Yok";
	HUD.margin = 10.f;
	HUD.yOffset = BOTTOM_MESSAGE_OFFSET;
	HUD.removeFromSuperViewOnHide = YES;
	
    // Ends user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)urlNotValid:(NSString *)urlString
{
    if (loadOrder == E_LOAD_SECOND) {
        [hideAudioIcon addObject:[NSNumber numberWithBool:YES]];
        
        [DownloadController cancel];
        [DownloadController close];
        [self checkEndOfDownload];
    }
}

- (void)didReceiveFilename:(NSString *)name
{
    if (loadOrder == E_LOAD_SECOND) {
        [hideAudioIcon addObject:[NSNumber numberWithBool:NO]];
        
        [DownloadController close];
        [self checkEndOfDownload];
    }
}

- (void)checkEndOfDownload
{
    NSInteger imageCount = [images count];
    
    if (selectedStoryIndex == ([stories count] - 1)) {
        loadOrder = E_LOAD_THIRD;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [carousel reloadData];
    }
    else {
        loadOrder = E_LOAD_FIRST;
        selectedStoryIndex = selectedStoryIndex + 1;
        [self setStory];
    }
    
    if (imageCount > 0) {
        [HUD hide:YES];
        [carousel reloadData];
    }

}

- (void)didReceiveData:(NSData *)data
{
    UIImage *image = nil;
    Story *story = nil;
    
    switch (loadOrder) {
        case E_LOAD_FIRST:
            // Story image set.
            image = [[UIImage alloc] initWithData:[downloader data]];
            if (image != nil) {
                [images addObject:image];
            }
            else {
                [images addObject:[images objectAtIndex:0]];
            }
            [DownloadController close];
            story = (Story *)[stories objectAtIndex:selectedStoryIndex];
            [DownloadController download:[story.audio stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            loadOrder = E_LOAD_SECOND;
            break;
        case E_LOAD_SECOND:
            [hideAudioIcon addObject:[NSNumber numberWithBool:NO]];
            
            [DownloadController cancel];
            [DownloadController close];
            [self checkEndOfDownload];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(ReflectionView *)view
{
    if ([images count] > 0) {
        
        UIButton *storyImage = nil;
        Story *story = (Story *)[stories objectAtIndex:self.carousel.currentItemIndex];
        NSString *imageNumber = nil;
        NSInteger imageCount = [images count];
        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //set up reflection view
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                view = [[ReflectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
            }
            else
            {
                view = [[ReflectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 400.0f, 400.0f)];
            }
            
            //set up content
            storyImage = [[UIButton alloc] initWithFrame:view.bounds];
            storyImage.backgroundColor = [UIColor lightGrayColor];
            storyImage.layer.borderColor = [UIColor whiteColor].CGColor;
            storyImage.clipsToBounds = YES;
            storyImage.layer.borderWidth = 4.0f;
            storyImage.layer.cornerRadius = 8.0f;
            storyImage.tag = 2626;
            
            [storyImage addTarget:self action:@selector(openStory:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:storyImage];
        }
        else
        {
            storyImage = (UIButton *)[view viewWithTag:2626];
        }
        
        if (index < imageCount) {
            [storyImage setImage:[images objectAtIndex:index] forState:UIControlStateNormal];
            [_audioIndicator setHidden:[[hideAudioIcon objectAtIndex:self.carousel.currentItemIndex] boolValue]];
        }
        
        [self.storyTitle setText:story.title];
        imageNumber = [[NSString alloc] initWithFormat:@"%d / %d", self.carousel.currentItemIndex + 1, self.carousel.numberOfItems];
        [self.imageNumber setText:imageNumber];
        
        [view update];
	}
    
	return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 2.0;
        default:
            return value;
    }
}

#pragma mark -
#pragma mark In App Purchase Operations

- (void)productPurchased:(NSNotification *)notification {
    // Ends user interaction disable
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
}

- (void)productRestored:(NSNotification *)notification {
    stories = [inAppHelper purchasedProducts:nil];
    
    if (loadOrder != E_LOAD_THIRD) {
        [self setStory];
    }
    else {
        [self checkEndOfDownload];
    }

}

@end
