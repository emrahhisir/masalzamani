//
//  UITabBarController+Rotation.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 4/25/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "UITabBarController+Rotation.h"

@implementation UITabBarController (Rotation)

- (BOOL)shouldAutorotate
{
    BOOL result = NO;
    
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *rootController = [((UINavigationController *)self.selectedViewController).viewControllers objectAtIndex:0];
        result = [rootController shouldAutorotate];
    }
    else {
        result = [self.selectedViewController shouldAutorotate];
    }
    
    return result;
}

@end
