//
//  AppDelegate.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSString *)remotePath;
+ (NSInteger)getIndexOfSubDataInData:(NSData *)haystack forData:(NSData *)needle startIndex:(int)start;

@end

