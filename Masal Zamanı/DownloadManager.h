//
//  DownloadManager.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 8/27/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadControllerDelegate <NSObject>
@optional
- (void) didReceiveData: (NSData *) data;
- (void) didReceiveFilename: (NSString *) name;
- (void) dataDownloadFailed: (NSString *) reason;
- (void) dataDownloadAtPercent: (NSNumber *) percent;
- (void) urlNotValid: (NSString *) urlString;
@end

@protocol DownloadManager <NSObject>
@optional

@property (nonatomic, strong) id<DownloadControllerDelegate> delegate;

+ (id) sharedInstance;
+ (void) download:(NSString *) URLString;
+ (void) downloadSync:(NSString *) URLString;
+ (void) cancel;
+ (void) close;

@end
