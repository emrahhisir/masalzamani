//
//  AdminUtil.m
//  Masal Zamanı
//
//  Created by Emrah Hisir on 2/16/13.
//  Copyright (c) 2013 Emrah Hisir. All rights reserved.
//

#import "AdminUtil.h"
#import "DayStory.h"
#import "Story.h"
#import "MenuItem.h"
#import "FirstLevelMenuItem.h"

@interface AdminUtil()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSURL *storeURL;

-(void)initDBObjects;
-(void)saveContext;

@end

@implementation AdminUtil

@synthesize managedObjectContext=_managedObjectContext, storeURL=_storeURL;

#pragma mark -
#pragma mark Init Databese Methods

/**
 * These methods for admin.
 */
- (void)initStoreFile:(NSManagedObjectContext *)managedObjectContext storeURL:(NSURL *)storeURL
{
    self.managedObjectContext = managedObjectContext;
    self.storeURL = storeURL;
    
    [self initDBObjects];
    [self saveContext];
}

- (void)initDBObjects
{
    // Top menu items.
    MenuItem *newMenuItemAge = (MenuItem *)[NSEntityDescription
                                            insertNewObjectForEntityForName:@"MenuItem"
                                            inManagedObjectContext:_managedObjectContext];
    newMenuItemAge.name = @"Yaş";
    
    MenuItem *newMenuItemType = (MenuItem *)[NSEntityDescription
                                             insertNewObjectForEntityForName:@"MenuItem"
                                             inManagedObjectContext:_managedObjectContext];
    newMenuItemType.name = @"Tür";
    
    MenuItem *newMenuItemContent = (MenuItem *)[NSEntityDescription
                                                insertNewObjectForEntityForName:@"MenuItem"
                                                inManagedObjectContext:_managedObjectContext];
    newMenuItemContent.name = @"İçerik";
    
    MenuItem *newMenuItemEnglish = (MenuItem *)[NSEntityDescription
                                                insertNewObjectForEntityForName:@"MenuItem"
                                                inManagedObjectContext:_managedObjectContext];
    newMenuItemEnglish.name = @"İngilizce";
    
    // First level menu items of girls.
    FirstLevelMenuItem *newMenuItem02Years = (FirstLevelMenuItem *)[NSEntityDescription
                                                                    insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                    inManagedObjectContext:_managedObjectContext];
    newMenuItem02Years.name = @"0-2 Yaş";
    [newMenuItem02Years addUpMenuObject:newMenuItemAge];
    
    FirstLevelMenuItem *newMenuItem24Years = (FirstLevelMenuItem *)[NSEntityDescription
                                                                    insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                    inManagedObjectContext:_managedObjectContext];
    newMenuItem24Years.name = @"2-4 Yaş";
    [newMenuItem24Years addUpMenuObject:newMenuItemAge];
    
    FirstLevelMenuItem *newMenuItem46Years = (FirstLevelMenuItem *)[NSEntityDescription
                                                                    insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                    inManagedObjectContext:_managedObjectContext];
    newMenuItem46Years.name = @"4-6 Yaş";
    [newMenuItem46Years addUpMenuObject:newMenuItemAge];
    
    FirstLevelMenuItem *newMenuItem6AndOlderYears = (FirstLevelMenuItem *)[NSEntityDescription
                                                                           insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                           inManagedObjectContext:_managedObjectContext];
    newMenuItem6AndOlderYears.name = @"6 Üzeri Yaş";
    [newMenuItem6AndOlderYears addUpMenuObject:newMenuItemAge];
    
    // First level menu items by TYPE.
    FirstLevelMenuItem *newMenuItemDidactic = (FirstLevelMenuItem *)[NSEntityDescription
                                                                     insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                     inManagedObjectContext:_managedObjectContext];
    newMenuItemDidactic.name = @"Öğretici Masallar";
    [newMenuItemDidactic addUpMenuObject:newMenuItemType];
    
    FirstLevelMenuItem *newMenuItemClassic = (FirstLevelMenuItem *)[NSEntityDescription
                                                                    insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                    inManagedObjectContext:_managedObjectContext];
    newMenuItemClassic.name = @"Klasik Masallar";
    [newMenuItemClassic addUpMenuObject:newMenuItemType];
    
    FirstLevelMenuItem *newMenuItemComic = (FirstLevelMenuItem *)[NSEntityDescription
                                                                  insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                  inManagedObjectContext:_managedObjectContext];
    newMenuItemComic.name = @"Komik Masallar";
    [newMenuItemComic addUpMenuObject:newMenuItemType];
    
    // First level menu items by CONTENT.
    FirstLevelMenuItem *newMenuItemAnimal = (FirstLevelMenuItem *)[NSEntityDescription
                                                                   insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                   inManagedObjectContext:_managedObjectContext];
    newMenuItemAnimal.name = @"Hayvan Masalları";
    [newMenuItemAnimal addUpMenuObject:newMenuItemContent];
    
    FirstLevelMenuItem *newMenuItemMagic = (FirstLevelMenuItem *)[NSEntityDescription
                                                                  insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                  inManagedObjectContext:_managedObjectContext];
    newMenuItemMagic.name = @"Sihir Masalları";
    [newMenuItemMagic addUpMenuObject:newMenuItemContent];
    
    FirstLevelMenuItem *newMenuItemNature = (FirstLevelMenuItem *)[NSEntityDescription
                                                                   insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                   inManagedObjectContext:_managedObjectContext];
    newMenuItemNature.name = @"Doğa Masalları";
    [newMenuItemNature addUpMenuObject:newMenuItemContent];
    
    FirstLevelMenuItem *newMenuItemHistory = (FirstLevelMenuItem *)[NSEntityDescription
                                                                    insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                    inManagedObjectContext:_managedObjectContext];
    newMenuItemHistory.name = @"Tarihi Masallar";
    [newMenuItemHistory addUpMenuObject:newMenuItemContent];
    
    // First level menu items by ENGLISH.
    FirstLevelMenuItem *newMenuItemEnglishWithAudio = (FirstLevelMenuItem *)[NSEntityDescription
                                                                             insertNewObjectForEntityForName:@"FirstLevelMenuItem"
                                                                             inManagedObjectContext:_managedObjectContext];
    newMenuItemEnglishWithAudio.name = @"Sesli ve Yazılı";
    [newMenuItemEnglishWithAudio addUpMenuObject:newMenuItemEnglish];
    
    /*FirstLevelMenuItem *newMenuItemEnglishNoAudio = (FirstLevelMenuItem *)[NSEntityDescription
     insertNewObjectForEntityForName:@"FirstLevelMenuItem"
     inManagedObjectContext:_managedObjectContext];
     newMenuItemEnglishNoAudio.name = @"Yazılı";
     [newMenuItemEnglishNoAudio addUpMenuObject:newMenuItemEnglish];*/
    
    // Stories
    Story *newStory = (Story *)[NSEntityDescription
                                insertNewObjectForEntityForName:@"Story"
                                inManagedObjectContext:_managedObjectContext];
    
    newStory.title = @"Kırmızı Başlıklı Kız";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KirmiziBaslikliKiz.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KirmiziBaslikliKiz.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background30.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KirmiziBaslikliKiz.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Çirkin Ördek Yavrusu";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/CirkinOrdekYavrusu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/CirkinOrdekYavrusu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background2.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/CirkinOrdekYavrusu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Hansel ve Gretel";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/HanselVeGretel.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/HanselVeGretel.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background4.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/HanselVeGretel.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Kül Kedisi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KulKedisi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KulKedisi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background4.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KulKedisi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Pamuk Prenses Ve Yedi Cüceler";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/PamukPrensesVeYediCuceler.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/PamukPrensesVeYediCuceler.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background5.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/PamukPrensesVeYediCuceler.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Pinokyo";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/Pinokyo.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/Pinokyo.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background6.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/Pinokyo.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Sihirli Fasulye";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/SihirliFasulye.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/SihirliFasulye.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background7.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/SihirliFasulye.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemNature];
    [newStory addCategoryObject:newMenuItemMagic];
    
    // **** Story Of The Day ****
    DayStory *newDayStory = (DayStory *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"DayStory"
                                         inManagedObjectContext:_managedObjectContext];
    
    // Blue color1
    //newDayStory.titleColor = @"0.0,145.0,212.0";
    // Blue color2
    newDayStory.titleColor = @"0.0,50.0,255.0";
    // Red color
    //newDayStory.titleColor = @"255.0,0.0,50.0";
    // White color
    //newDayStory.headerColor = @"255.0,255.0,250.0";
    newDayStory.headerColor = @"0.0,145.0,212.0";
    /* Blue color navigation bar
     UIColor *navigationBarColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.82 alpha:0.75];
     Pink color navigation bar
     UIColor *navigationBarColor2 = [UIColor colorWithRed:1.0 green:0.5 blue:0.75 alpha:0.75];*/
    newDayStory.barColor = @"1.0,0.5,0.75,0.75";
    newDayStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/MasalZamani_background.png"] absoluteString];
    newDayStory.storyOfDay = newStory;
    // **** Story Of The Day ****
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Uyuyan Güzel";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/UyuyanGuzel.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/UyuyanGuzel.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background8.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/UyuyanGuzel.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemMagic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Büyümek";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/Buyumek.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/Buyumek.png"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background9.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/Buyumek.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemAnimal];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Altın Saçlı Kız";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AltinSacliKiz.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AltinSacliKiz.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background10.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AltinSacliKiz.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemMagic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Su Perisi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/SuPerisi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/SuPerisi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background31.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/SuPerisi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Ağaç Ev";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AgacEv.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AgacEv.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background12.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AgacEv.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Akıl Okulu";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AkilOkulu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AkilOkulu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background13.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AkilOkulu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Altın Yumurtlayan Tavuk";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AltinYumurtlayanTavuk.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AltinYumurtlayanTavuk.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background14.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AltinYumurtlayanTavuk.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemAnimal];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Ay Avcısı Eskimolar";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AyAvcisiEskimolar.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AyAvcisiEskimolar.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background15.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AyAvcisiEskimolar.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Bacaklar Mı Boynuzlar Mı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/BacaklarMiBoynuzlarMi.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/BacaklarMiBoynuzlarMi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background14.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/BacaklarMiBoynuzlarMi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemAnimal];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Badem Ağacı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/BademAgaci.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/BademAgaci.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background31.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/BademAgaci.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Başını Vermeyen Şehit";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/BasiniVermeyenSehit.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/BasiniVermeyenSehit.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background31.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/BasiniVermeyenSehit.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemHistory];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Bezelye Prenses";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/BezelyePrenses.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/BezelyePrenses.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background2.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/BezelyePrenses.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Bremen Mızıkacıları";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/BremenMizikacilari.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/BremenMizikacilari.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background4.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/BremenMizikacilari.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Ceylan, Kaplumbağa, Fare ve Karga";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/CeylanKaplumbagaFareVeKarga.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/CeylanKaplumbagaFareVeKarga.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background4.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/CeylanKaplumbagaFareVeKarga.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Cimri";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/Cimri.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/Cimri.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background5.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/Cimri.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Çizmeli Kedi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/CizmeliKedi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/CizmeliKedi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background6.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/CizmeliKedi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Dağınık Çocuk";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/DaginikCocuk.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/DaginikCocuk.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background7.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/DaginikCocuk.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Deniz Yıldızı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/DenizYildizi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/DenizYildizi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background8.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/DenizYildizi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Eşek Ve Çekirge";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/EsekVeCekirge.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/EsekVeCekirge.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background9.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/EsekVeCekirge.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemAnimal];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Fareli Köyün Kavalcısı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/FareliKoyunKavalcisi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/FareliKoyunKavalcisi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background10.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/FareliKoyunKavalcisi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Güzel Ve Çirkin";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/GuzelVeCirkin.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/GuzelVeCirkin.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background31.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/GuzelVeCirkin.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemMagic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Karga İle Tilki";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KargaIleTilki.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KargaIleTilki.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background12.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KargaIleTilki.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Karınca İle Ağustos Böceği";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KarincaIleAgustosBocegi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KarincaIleAgustosBocegi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background13.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KarincaIleAgustosBocegi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemAnimal];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Karlar Kraliçesi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KarlarKralicesi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KarlarKralicesi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background6.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KarlarKralicesi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemMagic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Kar Tanesi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KarTanesi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KarTanesi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background15.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KarTanesi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Keloğlan Ünlü Falcı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KeloglanUnluFalci.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KeloglanUnluFalci.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background15.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KeloglanUnluFalci.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemHistory];
    [newStory addCategoryObject:newMenuItemComic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Kiraz Ağacı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KirazAgaci.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KirazAgaci.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background31.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KirazAgaci.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Küçük Deniz Kızı";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KucukDenizKizi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KucukDenizKizi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background30.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KucukDenizKizi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Küçük İstavritin Öyküsü";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KucukIstavritinOykusu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KucukIstavritinOykusu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background2.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KucukIstavritinOykusu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Küçük Kibritçi Kız";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KucukKibritciKiz.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KucukKibritciKiz.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background30.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KucukKucukKibritciKiz.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Kurbağa Prens";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/KurbagaPrens.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/KurbagaPrens.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background4.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/KurbagaPrens.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemClassic];
    [newStory addCategoryObject:newMenuItemMagic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Meraklı Tavşan";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/MerakliTavsan.dat"]
                     absoluteString];
    newStory.textColor = @"225.0,30.0,6.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/MerakliTavsan.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background5.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/MerakliTavsan.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Obur Kaplumbağa";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/OburKaplumbaga.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/OburKaplumbaga.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background6.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/OburKaplumbaga.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem02Years];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Öküz Olmak İsteyen Kurbağa";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/OkuzOlmakIsteyenKurbaga.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/OkuzOlmakIsteyenKurbaga.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background7.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/OkuzOlmakIsteyenKurbaga.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Öpücük Kutusu";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/OpucukKutusu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/OpucukKutusu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background8.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/OpucukKutusu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Orman Perisi";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/OrmanPerisi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/OrmanPerisi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background9.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/OrmanPerisi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemNature];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Parmak Kız";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/ParmakKiz.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/ParmakKiz.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background10.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/ParmakKiz.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Rapunzel";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/Rapunzel.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/Rapunzel.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background30.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/Rapunzel.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemClassic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Tembel Tavşan";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/TembelTavsan.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/TembelTavsan.png"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background12.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/TembelTavsan.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem24Years];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemAnimal];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Yoksul Oduncu";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/YoksulOduncu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/YoksulOduncu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background13.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/YoksulOduncu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Yorgun Oduncu";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/YorgunOduncu.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/YorgunOduncu.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background14.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/YorgunOduncu.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem46Years];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemMagic];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Zorun Başarılması";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/ZorunBasarilmasi.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/ZorunBasarilmasi.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background15.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/ZorunBasarilmasi.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItem6AndOlderYears];
    [newStory addCategoryObject:newMenuItemDidactic];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"I Want The Sun";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/IWantTheSun.dat"]
                     absoluteString];
    newStory.textColor = @"255.0,255.0,255.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/IWantTheSun.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background18.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/IWantTheSun.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItemEnglishWithAudio];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"The Spider And The Fly";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/TheSpiderAndTheFly.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,255.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/TheSpiderAndTheFly.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background19.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/TheSpiderAndTheFly.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItemEnglishWithAudio];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"The Lion And A Mouse";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/TheLionAndAMouse.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/TheLionAndAMouse.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background20.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/TheLionAndAMouse.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItemEnglishWithAudio];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"A Wise Parrot";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/AWiseParrot.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/AWiseParrot.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background30.png"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/AWiseParrot.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItemEnglishWithAudio];
    
    newStory = (Story *)[NSEntityDescription
                         insertNewObjectForEntityForName:@"Story"
                         inManagedObjectContext:_managedObjectContext];
    newStory.title = @"Two Frogs";
    newStory.text = [[_storeURL URLByAppendingPathComponent:@"Body/TwoFrogs.dat"]
                     absoluteString];
    newStory.textColor = @"0.0,0.0,0.0";
    newStory.image = [[_storeURL URLByAppendingPathComponent:@"Image/TwoFrogs.jpg"]
                      absoluteString];
    newStory.backgroundImage = [[_storeURL URLByAppendingPathComponent:@"BackgroundImage/Background26.jpg"]
                                absoluteString];
    newStory.audio = [[_storeURL URLByAppendingPathComponent:@"Audio/TwoFrogs.m4a"]
                      absoluteString];
    [newStory addCategoryObject:newMenuItemEnglishWithAudio];
    
}

#pragma mark -
#pragma mark Save Context

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
