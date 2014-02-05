//
//  DayStory.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/21/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Story;

@interface DayStory : NSManagedObject

@property (nonatomic, retain) NSString * backgroundImage;
@property (nonatomic, retain) NSString * barColor;
@property (nonatomic, retain) NSString * headerColor;
@property (nonatomic, retain) NSString * titleColor;
@property (nonatomic, retain) Story *storyOfDay;

@end
