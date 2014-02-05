//
//  Story.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/21/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayStory, FirstLevelMenuItem;

@interface Story : NSManagedObject

@property (nonatomic, retain) NSString * audio;
@property (nonatomic, retain) NSString * backgroundImage;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * textColor;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *category;
@property (nonatomic, retain) DayStory *nameOfDayStory;
@end

@interface Story (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(FirstLevelMenuItem *)value;
- (void)removeCategoryObject:(FirstLevelMenuItem *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;

@end
