//
//  GADRequestFactory.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "GADRequestFactory.h"
#import "LocationManager.h"

@implementation GADRequestFactory

+(GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           /*@"e5e07c1a28123e1e776207eb8785bd45",
                           @"72da38d627b8716a3a95ec7eec81c3b3",*/
                           nil];
    
    CLLocation *location = [LocationManager sharedInstance].location;
    
    [request setLocationWithLatitude:location.coordinate.latitude
                           longitude:location.coordinate.longitude
                            accuracy:location.horizontalAccuracy];
    
    [request setBirthdayWithMonth:3 day:13 year:2010];
    
    return request;
}

@end
