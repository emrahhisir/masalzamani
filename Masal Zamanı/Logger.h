//
//  Logger.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 2/16/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

-(id)init:(NSURL *)rootPath;
-(void)logMsg:(NSString *)message;
-(void)close:(NSString *)copyTo;

@end
