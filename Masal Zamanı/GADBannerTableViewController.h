//
//  GADBannerViewController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GADBannerView.h>

@interface GADBannerTableViewController : UITableViewController<GADBannerViewDelegate>

@property(nonatomic) bool isADLoaded;

- (void)configureCell:(UITableViewCell *)cell atIndex:(NSInteger)index;

@end
