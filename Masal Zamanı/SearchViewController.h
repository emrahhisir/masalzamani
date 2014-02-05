//
//  SecondViewController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayerController.h"
#import "GADBannerTableViewController.h"

@interface SearchViewController : GADBannerTableViewController<DisplayerController, UISearchDisplayDelegate, UIAlertViewDelegate>

@end
