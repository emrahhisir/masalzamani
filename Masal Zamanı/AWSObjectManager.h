//
//  AWSObjectManager.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 8/27/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRuntime/AmazonServiceRequest.h>
#import "DownloadManager.h"

@interface AWSObjectManager : NSObject <DownloadManager, AmazonServiceRequestDelegate>

@property (nonatomic) NSData *data;

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response;
-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data;
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response;
-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error;

+(void)downloadSync:(NSString *)URLString;
+(NSString *)objectPath:(NSString *)URLString;

@end
