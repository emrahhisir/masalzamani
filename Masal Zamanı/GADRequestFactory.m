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
    
    request.testDevices = @[ kGADSimulatorID ];
    
    /*CLLocation *location = [LocationManager sharedInstance].location;
    
    [request setLocationWithLatitude:location.coordinate.latitude
                           longitude:location.coordinate.longitude
                            accuracy:location.horizontalAccuracy];*/
    
    return request;
}

@end
