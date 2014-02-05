//
//  LocationManagerView.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *location;

+ (LocationManager *)sharedInstance;

@end
