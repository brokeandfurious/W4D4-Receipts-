//
//  AppDelegate.h
//  W4D4- Receipts++
//
//  Created by Murat Ekrem Kolcalar on 11/23/17.
//  Copyright © 2017 murtilicious. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

