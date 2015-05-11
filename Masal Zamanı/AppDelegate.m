//
//  AppDelegate.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 12/12/12.
//  Copyright (c) 2012 Emrah Hisir. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "DisplayerController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DayStory.h"
#import "AdminUtil.h"
#import "Logger.h"
#import "IAPHelper.h"
#import "ImageStoriesViewController.h"
#import "LocationManager.h"

@interface AppDelegate()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSURL *storeURL;
@property (nonatomic, strong, readonly) Logger *logger;
@property (nonatomic, readonly) BOOL noInternetConn;

- (NSURL *)createAndGetStoreDir;
- (void)saveContext;
- (BOOL)isStoreFileEmpty;
- (void)setNavigationBarColor;
- (void)terminateApp;

@end

@implementation AppDelegate

static NSURL *remotePath;
static const NSInteger NO_INTERNET_ALERT_VIEW_TAG = 2628;

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator, storeURL, logger=_logger, noInternetConn=_noInternetConn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // LocationManager Start
    [LocationManager sharedInstance];
    
    // Gets defult store url path and init logger.
    remotePath = [self createAndGetStoreDir];
    
    _logger = [[Logger alloc] init:[storeURL URLByDeletingLastPathComponent]];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    NSArray *childNavigationControllers = [tabBarController viewControllers];
    
    // Sets managed object context
    for (UINavigationController *navigationController in childNavigationControllers) {
        id <DisplayerController> viewController;
        viewController = [[navigationController viewControllers] objectAtIndex:0];
        [viewController setManagedObjectContext:self.managedObjectContext];
        [viewController setLogger:_logger];
        [viewController setNoInternetConn:_noInternetConn];
    }
    
    // For admin use. It initializes store file, fills database.
    if ([self isStoreFileEmpty]) {
        [[AdminUtil alloc] initStoreFile:_managedObjectContext storeURL:remotePath];
    }

    [self setNavigationBarColor];
    
    // 12 hour (12*60*60 = 43200) termination start
    [NSTimer scheduledTimerWithTimeInterval:43200 target:self selector:@selector(terminateApp:) userInfo:nil repeats:NO];
    
    // Push notification registration
    /*[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];*/
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [_logger close:[remotePath absoluteString]];
}
/*
#pragma mark -
#pragma mark Notification operations

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
*/

#pragma mark -
#pragma mark Static Variables Getter Methods

+ (NSString *)remotePath
{
    return [remotePath absoluteString];
}

#pragma mark -
#pragma mark Application Format Set

-(void)setNavigationBarColor
{
    NSError *error;
    NSArray *navigationControllers = [(UITabBarController *)self.window.rootViewController viewControllers];
    
    // Gets story of day.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayStory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error || ([array count] == 0)) {
        if (_noInternetConn == NO) {
            [_logger logMsg:[[NSString alloc] initWithFormat:@"NavigationBarColor Set Error: %@, %@\r\n", error, [error userInfo]]];
            abort();
        }
    }
    else {
        // Sets tint color of all navigation controllers.
        //NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        
        BOOL isIOS7OrLater = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1;
        for (UINavigationController *navController in navigationControllers) {
            NSArray *colorsRGB = [((DayStory *)array[0]).barColor componentsSeparatedByString:@","];
            
            if (isIOS7OrLater) {
                [navController.navigationBar setBarTintColor:[UIColor colorWithRed:[[colorsRGB objectAtIndex:0] doubleValue] green:[[colorsRGB objectAtIndex:1] doubleValue] blue:[[colorsRGB objectAtIndex:2] doubleValue] alpha:[[colorsRGB objectAtIndex:3] doubleValue]]];
                navController.navigationBar.translucent = NO;
                navController.navigationBar.tintColor = [UIColor whiteColor];
                navController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            }else {
                [navController.navigationBar setTintColor:[UIColor colorWithRed:[[colorsRGB objectAtIndex:0] doubleValue] green:[[colorsRGB objectAtIndex:1] doubleValue] blue:[[colorsRGB objectAtIndex:2] doubleValue] alpha:[[colorsRGB objectAtIndex:3] doubleValue]]];
            }
        }
    }
}

#pragma mark -
#pragma mark Notification Show Operations

+ (NSInteger)getIndexOfSubDataInData:(NSData *)haystack forData:(NSData *)needle startIndex:(int)start
{    
    NSInteger dataCounter = start;
    NSRange dataRange = NSMakeRange(dataCounter, [needle length]);
    NSData* compareData = [haystack subdataWithRange:dataRange];
    
    while (![compareData isEqualToData:needle]) {
        dataCounter++;
        dataRange = NSMakeRange(dataCounter, [needle length]);
        compareData = [haystack subdataWithRange:dataRange];
    }
    
    return dataCounter;
}

#pragma mark -
#pragma mark Store File Operations

- (BOOL)isStoreFileEmpty
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[self.storeURL path]]) {
        // Create and configure a fetch request with the DayStory entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DayStory" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Story of day fetch.
        NSError *error;
        NSArray *array = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([array count]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSURL *)createAndGetStoreDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *localStorePath = [[[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingString:@"/StoryTime.sqlite"];
    NSLog(@"%@", localStorePath);
    NSString *rootPath = @"https://s3-us-west-2.amazonaws.com/masalzamani";
    NSMutableString *remoteStorePath = [NSMutableString stringWithString:rootPath];
    [remoteStorePath appendString:@"/StoryTime.sqlite"];
    
    // Download store file and copy
    /*NSURL  *url = [NSURL URLWithString:remoteStorePath];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData)
    {
        [urlData writeToFile:localStorePath atomically:YES];
        _noInternetConn = NO;
    }
    // No internet connection
    else
    {
        UIAlertView *noInternetCon = [[UIAlertView alloc] initWithTitle:@"Internet Bağlantısı" message:@"Internet Bağlantısı Yok" delegate:self cancelButtonTitle:@"Tamam" otherButtonTitles:nil, nil];
        [noInternetCon show];
        noInternetCon.tag = NO_INTERNET_ALERT_VIEW_TAG;
        noInternetCon = nil;
        _noInternetConn = YES;
     
        [_logger close:[AppDelegate remotePath]];
    }*/
    
    storeURL = [NSURL fileURLWithPath:localStorePath isDirectory:NO];
    
    return [[NSURL alloc] initWithString:rootPath];
}

#pragma mark -
#pragma mark Save Context

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            [_logger logMsg:[[NSString alloc] initWithFormat:@"AppDelegate:saveContext %@, %@\r\n", error, [error userInfo]]];
            abort();
        }
    }
}


#pragma mark -
#pragma mark Core Data Stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"StoryModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, @{@"journal_mode" : @"DELETE"}, NSSQLitePragmasOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:options error:&error]) {
        [_logger logMsg:[[NSString alloc] initWithFormat:@"AppDelegate:persistentStoreCoordinator %@, %@\r\n", error, [error userInfo]]];
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Utility methods

-(void)terminateApp
{
    exit(0);
}

@end
