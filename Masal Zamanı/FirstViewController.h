//
//  FirstViewController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DisplayerController.h"
#import "GADBannerViewController.h"

@interface FirstViewController : GADBannerViewController <DisplayerController, UIAlertViewDelegate>

@end
