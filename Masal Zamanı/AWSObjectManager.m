//
//  AWSObjectManager.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 8/27/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AmazonServiceResponse.h>
#import "AmazonClientManager.h"
#import "AWSObjectManager.h"

#define DELEGATE_CALLBACK(X, Y) if (instanceAWS.delegate && [instanceAWS.delegate respondsToSelector:@selector(X)]) [instanceAWS.delegate performSelector:@selector(X) withObject:Y];
#define NUMBER(X) [NSNumber numberWithFloat:X]

#define BUCKET_NAME  @"masalzamani"

@interface AWSObjectManager ()

@property (nonatomic, strong) S3Bucket *bucket;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) S3GetObjectRequest *request;

@end

@implementation AWSObjectManager

@synthesize bucket=_bucket, delegate=_delegate, response=_response, data=_data, request=_request;

static AWSObjectManager *instanceAWS = nil;

- (id)init
{    
    if (self = [super init]) {
        @try {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            NSArray *bucketNames = [[AmazonClientManager s3] listBuckets];
            
            if (bucketNames != nil) {
                for (S3Bucket *tmpBucket in bucketNames) {
                    NSRange isFound = [[tmpBucket name] rangeOfString:BUCKET_NAME options:NSCaseInsensitiveSearch];
                    if (isFound.location != NSNotFound) {
                        _bucket = tmpBucket;
                    }
                }
            }
        }
        @catch (id exception) {
            return nil;
        }
        @finally {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark AmazonServiceRequestDelegate Operations

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    // store the response information
    _response = response;
    
    NSInteger code = [(NSHTTPURLResponse *)response statusCode];
    if (code == 404)
    {
        DELEGATE_CALLBACK(urlNotValid:, nil);
    }
    else if ([response suggestedFilename])
    {
        DELEGATE_CALLBACK(didReceiveFilename:, [response suggestedFilename]);
    }
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    // append the new data and update the delegate
    if (_response)
    {
        float expectedLength = [_response expectedContentLength];
        float currentLength = data.length;
        float percent = currentLength / expectedLength;
        DELEGATE_CALLBACK(dataDownloadAtPercent:, NUMBER(percent));
    }
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    // finished downloading the data, cleaning up
    _response = nil;
    _data = response.body;

    // Delegate is responsible for releasing data
    if (_delegate)
    {
        DELEGATE_CALLBACK(didReceiveData:, _data);
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    //NSLog(@"Error: Failed connection, %@", [error localizedDescription]);
    DELEGATE_CALLBACK(dataDownloadFailed:, @"Failed Connection");
    [self cleanup];
}

+ (AWSObjectManager *) sharedInstance
{
    if(!instanceAWS) {
        instanceAWS = [[self alloc] init];
    }
    return instanceAWS;
}

#pragma mark -
#pragma mark DownloadManager Operations

+ (void) download:(NSString *) URLString
{
    if (instanceAWS) {
        instanceAWS.request  = [[S3GetObjectRequest alloc] initWithKey:URLString withBucket:[instanceAWS.bucket name]];
        instanceAWS.request.delegate = instanceAWS;
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:instanceAWS.request];
        if(getObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", getObjectResponse.error);
        }
    }
}

+ (void) downloadSync:(NSString *)URLString
{
    if (instanceAWS) {
        instanceAWS.request  = [[S3GetObjectRequest alloc] initWithKey:URLString withBucket:[instanceAWS.bucket name]];
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:instanceAWS.request];
        instanceAWS.data = getObjectResponse.body;
        if(getObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", getObjectResponse.error);
        }
    }
}

- (void) cleanup
{
    _data = nil;
    _response = nil;
    _request.delegate = nil;
    _request = nil;
}

+ (void) cancel
{
    if (instanceAWS) {
       [instanceAWS.request cancel];
    }
}

+ (void)close
{
    if (instanceAWS) {
        [instanceAWS.request cancel];
        [instanceAWS.request.urlConnection unscheduleFromRunLoop:[NSRunLoop currentRunLoop] forMode:AWSDefaultRunLoopMode];
        [instanceAWS cleanup];
    }
}

+(NSString *)objectPath:(NSString *)URLString
{
    static NSString *result = nil;
    NSArray *tokens = [URLString componentsSeparatedByString:@"/"];
    
    if (tokens != nil) {
        result = [[NSString alloc] initWithFormat:@"%@/%@", tokens[[tokens count] - 2], tokens[[tokens count] - 1]];
    }
    
    return result;
}

@end
