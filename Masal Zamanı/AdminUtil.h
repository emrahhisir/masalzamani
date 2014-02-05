//
//  AdminUtil.h
//  Masal Zamanı
//
//  Created by Emrah Hisir on 2/16/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdminUtil : NSObject

-(void) initStoreFile:(NSManagedObjectContext *)managedObjectContext storeURL:(NSURL *)storeURL;

@end
