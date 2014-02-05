//
//  Logger.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 2/16/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "Logger.h"

@interface Logger()

-(void)checkFileSize;

@property (nonatomic, strong, readonly) NSFileHandle *logFile;
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@property (nonatomic, strong, readonly) NSFileManager *fileManager;
@property (nonatomic, strong, readonly) NSString *logFilePath;
@property (nonatomic, readonly) unsigned long long LOG_FILE_MAX_SIZE;

@end

@implementation Logger

@synthesize logFile, dateFormatter, fileManager, logFilePath, LOG_FILE_MAX_SIZE;

-(id)init:(NSURL *)rootPath{
    
    self = [super init];
    
    /*if (self) {
        logFilePath = [[rootPath URLByAppendingPathComponent:@"Log.dat"] path];
        [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
        logFile = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
        [logFile seekToEndOfFile];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        fileManager = [NSFileManager defaultManager];
        LOG_FILE_MAX_SIZE = 1000000;
        
    }*/
    
    return self;
}

-(void)logMsg:(NSString *)message {
    /*NSDate *currentDate = [NSDate date];
    NSMutableString *currentDateString = [NSMutableString stringWithString:[dateFormatter stringFromDate:currentDate]];
    [currentDateString appendString:@": "];
    [currentDateString appendString:message];
    
    [self checkFileSize];
    
    [logFile writeData:[currentDateString dataUsingEncoding:NSUTF8StringEncoding]];*/
    /*NSLog(@"%@", message);*/
}

-(void)close:(NSString *)copyTo {
    [logFile closeFile];
    [fileManager copyItemAtPath:logFilePath toPath:[copyTo stringByAppendingString:@"/Log.dat"] error:nil];
}

-(void)checkFileSize {
    if ([[fileManager attributesOfItemAtPath:logFilePath error:nil] fileSize] > LOG_FILE_MAX_SIZE) {
        // Deletes the content of log file.
        [logFile truncateFileAtOffset:0];
    }
}

-(void)finalize {
    [logFile closeFile];
}

@end
