//
//  AppDelegate.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TabBarController.h"
#import "NotificationCenter.h"
#import "TicketsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    CGRect windowFrame  = [UIScreen mainScreen].bounds;
    self.window  = [[UIWindow alloc] initWithFrame: windowFrame];
    
    TabBarController  *tabBarController = [[ TabBarController   alloc ]  init ];
    self . window . rootViewController  = tabBarController;

    [self.window makeKeyAndVisible];
    
    //запрос на получение доступа для отправления уведомлений, в момент первого запуска приложения
    [[ NotificationCenter   sharedInstance ]  registerService ];

    /*
     сюда мы не попадем на симуляторе
    //Если есть локальные уведомления - обработаем их
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif) {
        
        NSDate *currentDate = [NSDate date];
        NSLog(@"%@", currentDate);
        
        NSString *itemName = [localNotif.userInfo objectForKey:@"Notification"];
        
        NSLog(@"itemName = %@,fireDate = %@",itemName,localNotif.fireDate);
        //[viewController displayItem:itemName];  // custom method
        
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
        
    }
     */
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
