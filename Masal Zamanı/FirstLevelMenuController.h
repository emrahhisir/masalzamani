//
//  FirstLevelMenuController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/23/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayerController.h"
#import "GADBannerTableViewController.h"

@interface FirstLevelMenuController : GADBannerTableViewController<DisplayerController>

@property (nonatomic, strong) NSArray *menus;

@end
