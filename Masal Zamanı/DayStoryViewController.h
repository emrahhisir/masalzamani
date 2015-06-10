//
//  DayStoryViewController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/11/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DisplayerController.h"
#import "MZGADInterstitialViewController.h"

@interface DayStoryViewController : MZGADInterstitialViewController<AVAudioPlayerDelegate, DisplayerController>

@property (nonatomic, strong) NSString *textFilePath;
@property (nonatomic, strong) NSString *audioFilePath;
@property (nonatomic, strong) NSString *backgroundImagePath;
@property (nonatomic, strong) NSString *textColor;

@end
