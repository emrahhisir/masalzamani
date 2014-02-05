//
//  ImageStoriesViewController.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 5/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DisplayerController.h"
#import "iCarousel.h"
#import "ReflectionView.h"
#import "GADInterstitialViewController.h"

@interface ImageStoriesViewController : GADInterstitialViewController <DisplayerController, iCarouselDataSource, iCarouselDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic) NSInteger selectedStoryIndex;
@property (nonatomic, retain) IBOutlet iCarousel *carousel;

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(ReflectionView *)view;
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end
