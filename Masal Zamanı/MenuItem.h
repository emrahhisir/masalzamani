//
//  MenuItem.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 1/21/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FirstLevelMenuItem;

@interface MenuItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *downMenu;
@end

@interface MenuItem (CoreDataGeneratedAccessors)

- (void)addDownMenuObject:(FirstLevelMenuItem *)value;
- (void)removeDownMenuObject:(FirstLevelMenuItem *)value;
- (void)addDownMenu:(NSSet *)values;
- (void)removeDownMenu:(NSSet *)values;

@end
