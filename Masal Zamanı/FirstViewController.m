//
//  FirstViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import "FirstViewController.h"
#import "DayStory.h"
#import "Story.h"
#import "DayStoryViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@property (strong, nonatomic) IBOutlet UILabel *m_pDayStoryLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_pDayStoryButton;
@property (strong, nonatomic) IBOutlet UILabel *dayStoryTitle;
@property (strong, nonatomic) NSString *audioPath;
@property (strong, nonatomic) NSString *textBodyPath;
@property (strong, nonatomic) NSString *textBodyColor;
@property (strong, nonatomic) NSString *nextImagePath;
@property (strong, nonatomic) DayStory *fetchedDayStory;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic, readonly) NSString *okButtonContent;
@property (strong, nonatomic) SKProduct *buyProduct;

- (void)setDayOfStory;
- (void)openStory:(UIButton *)sender;
- (void)getProductList;
- (void)checkNotification;

@end

@implementation FirstViewController

@synthesize managedObjectContext=_managedObjectContext;
@synthesize m_pDayStoryLabel, m_pDayStoryButton, audioPath, textBodyPath, nextImagePath, textBodyColor, logger=_logger, HUD, downloader, loadOrder, fetchedDayStory, inAppHelper=_inAppHelper, priceFormatter=_priceFormatter, noInternetConn=_noInternetConn, okButtonContent, buyProduct=_buyProduct;

#pragma mark -
#pragma mark Load Operations

- (void)viewDidLoad
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	HUD.labelText = NSLocalizedString(@"Loading", @"Load view");
	HUD.delegate = self;
    [m_pDayStoryButton setHidden:YES];
    
    if (_noInternetConn) {
        [self dataDownloadFailed:nil];
    }
    else {
        [self getProductList];
        [self checkNotification];
        
        loadOrder = E_LOAD_FIRST;
        
        [DownloadController close];
        downloader = [DownloadController sharedInstance];
        [downloader setDelegate:self];
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    
    [super viewDidLoad];
}

- (void)dealloc {
    HUD = nil;
    downloader = nil;
    [self setBackgroundImage:nil];
    [DownloadController close];
    fetchedDayStory = nil;
    m_pDayStoryButton = nil;
    audioPath = nil;
    textBodyPath = nil;
    nextImagePath = nil;
    textBodyColor = nil;
    _logger = nil;
    fetchedDayStory = nil;
    _inAppHelper = nil;
    _priceFormatter = nil;
    okButtonContent = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    HUD = nil;
    downloader = nil;
    [self setBackgroundImage:nil];
    [DownloadController close];
    fetchedDayStory = nil;
    m_pDayStoryButton = nil;
    audioPath = nil;
    textBodyPath = nil;
    nextImagePath = nil;
    textBodyColor = nil;
    _logger = nil;
    fetchedDayStory = nil;
    _inAppHelper = nil;
    _priceFormatter = nil;
    okButtonContent = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = NSLocalizedString(@"DayStoryTitle", @"Title of day story view.");
    
    downloader = [DownloadController sharedInstance];
    [downloader setDelegate:self];
    
    if (fetchedDayStory != nil) {
        [self resumeDownload];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkNotification
{
    
    NSString *notificationFilePath = @"https://s3-us-west-2.amazonaws.com/masalzamani/Notification.dat";
    
    NSURL  *url = [NSURL URLWithString:notificationFilePath];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    
    if (urlData)
    {
        NSString *contentTag = @"Content:";
        NSString *okButtonTag = @"OK:";
        
        int contentIndex = [AppDelegate getIndexOfSubDataInData:urlData forData:[contentTag dataUsingEncoding:NSUTF8StringEncoding] startIndex:0];
        int okIndex = [AppDelegate getIndexOfSubDataInData:urlData forData:[okButtonTag dataUsingEncoding:NSUTF8StringEncoding] startIndex:contentIndex];
        
        NSRange dataRange = NSMakeRange(contentIndex + 9, okIndex - 11);
        NSString *content = [[NSString alloc] initWithData:[urlData subdataWithRange:dataRange] encoding:NSUTF8StringEncoding];
        
        dataRange = NSMakeRange(okIndex + 4, [urlData length] - okIndex - 4);
        okButtonContent = [[NSString alloc] initWithData:[urlData subdataWithRange:dataRange] encoding:NSUTF8StringEncoding];
        
        UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:@"Daha Sonra Hatırlat" otherButtonTitles:@"Tamam", nil];
        notification.tag = RATE_ALERT_VIEW_TAG;
        [notification show];
        
        notification = nil;
        _noInternetConn = NO;
    }
}

#pragma mark -
#pragma mark Fetch operations

- (void)setDayOfStory
{
    // Create and configure a fetch request with the DayStory entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayStory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Story of day fetch.
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    fetchedDayStory = (DayStory *)array[0];
    
    // Begins user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Background image set.
    [DownloadController download:[fetchedDayStory.backgroundImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    // Next view background image and text color set.
    nextImagePath = ((Story *)fetchedDayStory.storyOfDay).backgroundImage;
    textBodyColor = ((Story *)fetchedDayStory.storyOfDay).textColor;
    
    // Color of title set.
    NSArray *colorsRGB = [fetchedDayStory.titleColor componentsSeparatedByString:@","];
    [self.m_pDayStoryLabel setTextColor:[UIColor colorWithRed:[[colorsRGB objectAtIndex:0] doubleValue]/255.0 green:[[colorsRGB objectAtIndex:1] doubleValue]/255.0 blue:[[colorsRGB objectAtIndex:2] doubleValue]/255.0 alpha:1]];
    
    // Color of header set.
    colorsRGB = [fetchedDayStory.headerColor componentsSeparatedByString:@","];
    [self.dayStoryTitle setTextColor:[UIColor colorWithRed:[[colorsRGB objectAtIndex:0] doubleValue]/255.0 green:[[colorsRGB objectAtIndex:1] doubleValue]/255.0 blue:[[colorsRGB objectAtIndex:2] doubleValue]/255.0 alpha:1]];
    
    [self.m_pDayStoryLabel setText:((Story *)fetchedDayStory.storyOfDay).title];
    
    // Next view audio and text body set.
    self.audioPath = ((Story *)fetchedDayStory.storyOfDay).audio;
    self.textBodyPath = ((Story *)fetchedDayStory.storyOfDay).text;
    
    // Adds selector for the image
    [m_pDayStoryButton addTarget:self action:@selector(openStory:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == PROD_LIST_FAIL_ALERT_VIEW_TAG) {
        [HUD show:YES];
        [self getProductList];
    }
    else if (alertView.tag == BUY_ALERT_VIEW_TAG && buttonIndex != [alertView cancelButtonIndex]) {
        [_inAppHelper buyProduct:_buyProduct];
        _buyProduct = nil;
    }
    else if (alertView.tag == RATE_ALERT_VIEW_TAG && buttonIndex != [alertView cancelButtonIndex]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:okButtonContent]];
    }
}

#pragma mark -
#pragma mark Segue Operations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"OpenDayStory"]) {
        DayStoryViewController *dayStoryViewController = [segue destinationViewController];
        dayStoryViewController.textFilePath = self.textBodyPath;
        dayStoryViewController.audioFilePath = self.audioPath;
        dayStoryViewController.title = [m_pDayStoryLabel text];
        dayStoryViewController.backgroundImagePath = nextImagePath;
        dayStoryViewController.textColor = textBodyColor;
    }
}

- (void)openStory:(UIButton *)sender
{
    NSString *productIdentifier = [_inAppHelper productIdentifier:((Story *)fetchedDayStory.storyOfDay).text];
    _buyProduct = [_inAppHelper findProduct:[_inAppHelper productIdentifier:((Story *)fetchedDayStory.storyOfDay).text]];
                          
    if ([_inAppHelper productPurchased:productIdentifier]) {
        [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
    }
    else if (_buyProduct == nil) {
        UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PrdouctNotFound", @"Urun Bulunamadi") delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
        [notification show];
        notification = nil;
    }
    else {
        [_priceFormatter setLocale:_buyProduct.priceLocale];
        
        NSString *content = [NSString stringWithFormat:NSLocalizedString(@"BuyProductContent", @"Buy content"), m_pDayStoryLabel.text, _buyProduct.price.floatValue];
        
        UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:content delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button") otherButtonTitles:NSLocalizedString(@"BuyButton", @"Buy button"), nil];
        notification.tag = BUY_ALERT_VIEW_TAG;
        [notification show];
        notification = nil;
    }
}

#pragma mark -
#pragma mark DownloadControllerDelegate

- (void)dataDownloadFailed:(NSString *)reason
{
    HUD.mode = MBProgressHUDModeText;
	HUD.labelText = @"İnternet Bağlantısı Yok";
	HUD.margin = 10.f;
	HUD.yOffset = BOTTOM_MESSAGE_OFFSET2;
	HUD.removeFromSuperViewOnHide = YES;
	
    // Ends user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//	[HUD hide:YES afterDelay:3];
}

- (void)didReceiveData:(NSData *)data
{
    UIImage *image;
    
    switch (loadOrder) {
        case E_LOAD_FIRST:
            image = [[UIImage alloc] initWithData:[downloader data]];
            //self.backgroundImage = [[UIImageView alloc] initWithImage:image];
            [self.backgroundImage setImage:image];
            
            [DownloadController download:[((Story *)fetchedDayStory.storyOfDay).image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            loadOrder = E_LOAD_SECOND;
            break;
        case E_LOAD_SECOND:
            // Story image set.
            m_pDayStoryButton.layer.cornerRadius = 8.0;
            m_pDayStoryButton.clipsToBounds = YES;
            m_pDayStoryButton.backgroundColor = [UIColor whiteColor];
            m_pDayStoryButton.layer.borderColor = [UIColor whiteColor].CGColor;
            m_pDayStoryButton.layer.borderWidth = 10.0f;
            
            image = [[UIImage alloc] initWithData:[downloader data]];
            [m_pDayStoryButton setImage:image forState:UIControlStateNormal];
            [m_pDayStoryButton setHidden:NO];
            
            [HUD hide:YES];
            [DownloadController close];
            loadOrder = E_LOAD_THIRD;
            
            // Ends user interaction disable.
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            break;
        default:
            break;
    }
}

- (void)resumeDownload {
    switch (loadOrder) {
        case E_LOAD_FIRST:
            // Begins user interaction disable.
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [DownloadController download:[fetchedDayStory.backgroundImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            break;
        case E_LOAD_SECOND:
            // Begins user interaction disable.
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [DownloadController download:[((Story *)fetchedDayStory.storyOfDay).image stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            break;
        default:
            break;
    }

}

#pragma mark -
#pragma mark Interface Rotation Operations

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark In App Purchase Operations

- (void)getProductList
{
    _inAppHelper = [IAPHelper sharedInstance];
    
    if ([_inAppHelper isProductRequestNotCompleted]) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [_inAppHelper requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success) {
                [self setDayOfStory];
            }
            else {
                [HUD hide:YES];
                
                // Ends user interaction disable.
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                UIAlertView *notification = [[UIAlertView alloc] initWithTitle:@"" message:@"Masal listesini alırken hata oluştu, tekrar denenecektir" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil];
                notification.tag = PROD_LIST_FAIL_ALERT_VIEW_TAG;
                [notification show];
                notification = nil;
            }
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    else {
        [self setDayOfStory];
    }
}

- (void)productPurchased:(NSNotification *)notification {
    // Ends user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self performSegueWithIdentifier:@"OpenDayStory" sender:nil];
}

@end
