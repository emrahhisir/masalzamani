//
//  DisplayerController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/1/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logger.h"
#import "MBProgressHUD.h"
#import "DownloadController.h"
#import "IAPHelper.h"

enum LoadOrder {
    E_LOAD_FIRST = 0,
    E_LOAD_SECOND,
    E_LOAD_THIRD,
    E_LOAD_FOURTH,
    E_LOAD_FIFTH,
    E_LOAD_SIXTH,
    E_LOAD_SEVENTH,
    E_LOAD_EIGHTH,
    E_LOAD_NINTH,
    E_LOAD_TENTH
    };

#define BUY_ALERT_VIEW_TAG 2626
#define PROD_LIST_FAIL_ALERT_VIEW_TAG 2627
#define RATE_ALERT_VIEW_TAG 2628
#define NO_INTERNET_MESSAGE_OFFSET 50.0f
#define BOTTOM_MESSAGE_OFFSET (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) ? self.view.frame.size.height/2 - self.tabBarController.tabBar.frame.size.height - NO_INTERNET_MESSAGE_OFFSET : self.view.frame.size.height/2 - self.tabBarController.tabBar.frame.size.height + self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - NO_INTERNET_MESSAGE_OFFSET
#define BOTTOM_MESSAGE_OFFSET2 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) ? self.view.frame.size.height/2 - self.tabBarController.tabBar.frame.size.height - NO_INTERNET_MESSAGE_OFFSET : self.view.frame.size.height/2 - self.tabBarController.tabBar.frame.size.height - NO_INTERNET_MESSAGE_OFFSET

@protocol DisplayerController <NSObject, MBProgressHUDDelegate, DownloadControllerDelegate>

@optional
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Logger *logger;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) DownloadController *downloader;
@property (nonatomic) enum LoadOrder loadOrder;
@property (nonatomic, strong) IAPHelper *inAppHelper;
@property (nonatomic, strong) NSNumberFormatter * priceFormatter;
@property (nonatomic) BOOL noInternetConn;

@end
