//
//  LocationManagerView.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/10/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

static LocationManager *singletonLocationManager = nil;

@implementation LocationManager

-(id)init {
    
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = 2000; // meters
        
        [_locationManager startUpdatingLocation];
    }
    
    return self;
}

+ (LocationManager *)sharedInstance
{
    @synchronized(self) {
        if (singletonLocationManager == nil) {
            singletonLocationManager = [[[self class] alloc] init];
        }
    }
    return singletonLocationManager;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if ([locations count] > 0) {
        _location = [locations lastObject];
    }
}


@end
