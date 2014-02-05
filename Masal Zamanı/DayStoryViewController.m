//
//  DayStoryViewController.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/11/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "DayStoryViewController.h"
#import "AudioStreamer.h"

@interface DayStoryViewController ()

@property (nonatomic, strong) UIBarButtonItem *pauseButton;
@property (nonatomic, strong) UIBarButtonItem *playButton;
@property (nonatomic) BOOL isPlayerInit;

- (void)loadStory;
- (void)playbackStateChanged:(NSNotification *)notification;
- (void)destroyStreamer;

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

- (IBAction)pauseAudio:(id)sender;
- (IBAction)playAudio:(id)sender;

@end

static AudioStreamer *streamer = nil;
static id streamerOwner = nil;

@implementation DayStoryViewController

@synthesize textFilePath, audioFilePath, title, pauseButton, playButton, backgroundImagePath, textColor, logger=_logger, HUD, loadOrder, downloader, isPlayerInit;


- (void)viewDidLoad
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"Loading", @"Load view");
	HUD.delegate = self;
    
    downloader = [DownloadController sharedInstance];
    [DownloadController cancel];
    [DownloadController close];
    [downloader setDelegate:self];
    
    isPlayerInit = NO;
    loadOrder = E_LOAD_FIRST;
    //[HUD show:YES];
    
    [super viewDidLoad];
	[self loadStory];
    [self createStreamer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self destroyStreamer];
}

- (void)viewWillAppear:(BOOL)animated {
    if (streamerOwner != self) {
        if (isPlayerInit) {
            HUD.delegate = self;
            
            isPlayerInit = NO;
            loadOrder = E_LOAD_FIRST;
            [self createStreamer];
        }
    }
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:false];
}

- (void)viewDidUnload
{
    [HUD hide:YES];
}

-(void)dealloc
{
    HUD = nil;
    downloader = nil;
}

#pragma mark -
#pragma mark Load story operations

- (void)loadStory
{
    self.navigationItem.title = title;
    
    // Begins user interaction disable.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Background image download.
    [DownloadController download:[backgroundImagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    // Color of text set.
    NSArray *colorsRGB = [textColor componentsSeparatedByString:@","];
    [((UITextView *)self.view) setTextColor:[UIColor colorWithRed:[[colorsRGB objectAtIndex:0] doubleValue]/255.0 green:[[colorsRGB objectAtIndex:1] doubleValue]/255.0 blue:[[colorsRGB objectAtIndex:2] doubleValue]/255.0 alpha:1]];
}

- (IBAction)pauseAudio:(id)sender {
    [streamer pause];
    self.navigationItem.rightBarButtonItem = self.playButton;
}

- (IBAction)playAudio:(id)sender {
    if (isPlayerInit) {
         [streamer pause];
    }
    else {
        [streamer start];
    }
    self.navigationItem.rightBarButtonItem = self.pauseButton;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [_logger logMsg:[[NSString alloc] initWithFormat:@"DayStoryViewController:audioPlayerDecodeErrorDidOccur %@, %@\r\n", error, [error userInfo]]];
}

#pragma mark -
#pragma mark DownloadControllerDelegate

- (void)dataDownloadFailed:(NSString *)reason
{
    if (loadOrder != E_LOAD_THIRD) {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"İnternet Bağlantısı Yok";
        HUD.margin = 10.f;
        HUD.yOffset = BOTTOM_MESSAGE_OFFSET;
        HUD.removeFromSuperViewOnHide = YES;
        
        // Ends user interaction disable.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)didReceiveData:(NSData *)data
{
    UIImage *image = nil;

    switch (loadOrder) {
        case E_LOAD_FIRST:
            // Background image set.
            image = [[UIImage alloc] initWithData:[downloader data]];
            self.view.backgroundColor = [UIColor colorWithPatternImage:image];
            
            // Text body download.
            [DownloadController close];
            [DownloadController download:[textFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            loadOrder = E_LOAD_SECOND;
            break;
        case E_LOAD_SECOND:
            // Text body set.
           [((UITextView *)self.view) setText:[[NSString alloc] initWithData:[downloader data] encoding:NSWindowsCP1254StringEncoding]];

            [DownloadController close];
            loadOrder = E_LOAD_THIRD;
            break;
            
            loadOrder = E_LOAD_FOURTH;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Audio Streamer (Callback) Functions

- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([streamer isWaiting])
	{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[HUD show:YES];
	}
	else if ([streamer isPlaying])
	{
        if (isPlayerInit == NO) {
            pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseAudio:)];
            playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playAudio:)];
            self.navigationItem.rightBarButtonItem = self.pauseButton;

            isPlayerInit = YES;
        }
        
        // Ends user interaction disable.
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        [HUD hide:YES];
	}
	else if ([streamer isIdle])
	{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [HUD hide:YES];
        
        if (isPlayerInit) {
            self.navigationItem.rightBarButtonItem = self.playButton;
            [streamer stop];
            isPlayerInit = NO;
        }
        else {
            [self destroyStreamer];
        }
	}
}

- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		
		[streamer stop];
		streamer = nil;
        streamerOwner = nil;
	}
}

- (void)createStreamer
{
    [self destroyStreamer];
    
    /*if (streamer) {
        return;
    }*/
    
    streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:[audioFilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
    [streamer start];
    streamerOwner = self;
    
}

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
