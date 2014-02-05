//
//  FirstLevelMenuItem.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/21/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuItem, Story;

@interface FirstLevelMenuItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *stories;
@property (nonatomic, retain) NSSet *upMenu;
@end

@interface FirstLevelMenuItem (CoreDataGeneratedAccessors)

- (void)addStoriesObject:(Story *)value;
- (void)removeStoriesObject:(Story *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

- (void)addUpMenuObject:(MenuItem *)value;
- (void)removeUpMenuObject:(MenuItem *)value;
- (void)addUpMenu:(NSSet *)values;
- (void)removeUpMenu:(NSSet *)values;

@end
