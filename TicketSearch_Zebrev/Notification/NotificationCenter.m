//
//  NotificationCenter.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 24.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "NotificationCenter.h"
#import  <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>
#import "TicketsViewController.h"
#import "TabBarController.h"
#import "AppDelegate.h"

@interface   NotificationCenter  () < UNUserNotificationCenterDelegate >

@end

@implementation NotificationCenter


+ ( instancetype )sharedInstance {
    static   NotificationCenter  *instance;
    static   dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ NotificationCenter   alloc ]  init]  ;
    });
    
    return  instance;
}

- ( void )registerService {
    if  ( @available (iOS  10.0 , *)) {
        
        UNUserNotificationCenter  *center = [ UNUserNotificationCenter   currentNotificationCenter ];
        
        center. delegate  =  self ;
        
        [center  requestAuthorizationWithOptions :( UNAuthorizationOptionBadge  |
                                                   UNAuthorizationOptionSound  |  UNAuthorizationOptionAlert )  completionHandler :^(BOOL granted, NSError * _Nullable error){
            if  (!error) {
                NSLog ( @"request authorization succeeded!" );
            }
            
        
        }];
        
    }  else  {
        
            UIUserNotificationType  types = ( UIUserNotificationTypeAlert |  UIUserNotificationTypeSound | UIUserNotificationTypeBadge );
        
            UIUserNotificationSettings  *settings;
        
            settings = [ UIUserNotificationSettings  settingsForTypes :types  categories : nil ];
        
            [[ UIApplication   sharedApplication ] registerUserNotificationSettings :settings];
        
    }
}


- ( void )sendNotification:( Notification )notification  ticketFlightNumber:(NSNumber * )ticketFlightNumber{
    
    if  ( @available (iOS  10.0 , *)) {
        
    UNMutableNotificationContent  *content = [[ UNMutableNotificationContent   alloc ]  init ];
        
        //Сохраним в контент номер билета, чтобы потом на него поставить фокус в списке избранных
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:ticketFlightNumber forKey:@"ticketFlightNumber"];

        content.userInfo=infoDict;
        
        
        content. title  = notification. title ;
    
        content. body  = notification. body ;
        content.badge = [NSNumber numberWithInt:1];
        
    
        content. sound  = [ UNNotificationSound   defaultSound ];
        
    if  (notification. imageURL ) {
        UNNotificationAttachment  *attachment = [ UNNotificationAttachment
                                                 attachmentWithIdentifier : @"image"   URL :notification. imageURL   options : nil   error : nil ];
        if  (attachment) {
            content. attachments  =  @[ attachment ] ;
            
        }
    }
        
    NSCalendar  *calendar = [ NSCalendar   calendarWithIdentifier : NSCalendarIdentifierGregorian ];
    NSDateComponents  *components = [calendar  componentsInTimeZone :[ NSTimeZone systemTimeZone ]  fromDate :notification. date ];
        
    NSDateComponents  *newComponents = [[ NSDateComponents   alloc ]  init]  ;
        newComponents. calendar  = calendar;
    newComponents. timeZone  = [ NSTimeZone   defaultTimeZone ];
        newComponents. month  = components. month ;
        
    newComponents. day  = components. day ;
        newComponents. hour  = components. hour ;
        newComponents. minute  = components. minute ;
        
        //NSLog(@"%ld - %ld - %ld - %ld",(long)newComponents.month,(long)newComponents.day,(long)newComponents.hour,(long)newComponents.minute);
        
        //NSLog(@"content = %@",content);
        
    UNCalendarNotificationTrigger  *trigger = [ UNCalendarNotificationTrigger triggerWithDateMatchingComponents :newComponents  repeats : NO ];
        
    UNNotificationRequest  *request = [ UNNotificationRequest   requestWithIdentifier : @"Notification"
                                                                              content :content  trigger :trigger];
        
        
        UNUserNotificationCenter  *center = [ UNUserNotificationCenter   currentNotificationCenter ];

        [center  addNotificationRequest :request  withCompletionHandler : nil ];
        
        
        
    } else {
        UILocalNotification  *localNotification = [[ UILocalNotification   alloc ]  init ];
        localNotification. fireDate  = notification. date ;
        localNotification.applicationIconBadgeNumber = 1;
        
        if  (notification. title ) {
            localNotification. alertBody  = [ NSString   stringWithFormat : @"%@ - %@" , notification. title , notification. body ];
        }  else  {
            localNotification. alertBody  = notification. body ;
            
        }
        
        //NSLog(@"отправка напоминания %@ - %@",notification. title , notification. body);
        [[ UIApplication   sharedApplication ] scheduleLocalNotification :localNotification];
        
    }
    
    
}

Notification  NotificationMake( NSString *  _Nullable  title,  NSString *  _Nonnull  body,  NSDate *  _Nonnull  date, NSURL  *  _Nullable  imageURL) {
    
    Notification  notification;
    notification. title  = title;
    notification. body  = body;
    notification. date  = date;
    notification. imageURL  = imageURL;
    
    return  notification;
}


- ( void )userNotificationCenter:( UNUserNotificationCenter *)center didReceiveNotificationResponse:( UNNotificationResponse *)response withCompletionHandler:( void (^)( void ))completionHandler {

    //NSLog(@"not1 = %@, id = %@",response.notification,response.actionIdentifier);

    //NSDate *currentDate = [NSDate date];
    //NSLog(@"%@", currentDate);
    
    UNNotificationContent *content =response.notification.request.content;
    NSNumber * flightNumber =(NSNumber*)[content.userInfo objectForKey:@"ticketFlightNumber"];

    //NSLog(@"flightNumber = %@",flightNumber);
    
    //NSString *itemName = [localNotif.userInfo objectForKey:@"Notification"];
    
    //NSLog(@"fireDate = %@",response.n);

    
    UIApplication *app                = [UIApplication sharedApplication];
    
    //NSLog(@"%ld count = ",app.applicationIconBadgeNumber);
    
    app.applicationIconBadgeNumber-=1;
   
    UITabBarController *tabBarController =(UITabBarController *)app.keyWindow.rootViewController;
    
    //[appDelegate.navigationController popToRootViewControllerAnimated:YES];
    
    for (id item in tabBarController.viewControllers) {

        UIViewController *vc = item;
        
        NSUInteger index = [tabBarController.viewControllers indexOfObject:item];
        
        //NSLog(@"vc = %@ - %@ , %ld",vc.title,vc.tabBarItem.title,index);
        
        if ([vc.title isEqualToString:@"Favorites"]) {

            tabBarController.selectedIndex = index;
            
            UINavigationController *nc = (UINavigationController*)item;
            TicketsViewController *favoriteViewController = (TicketsViewController *)nc.visibleViewController;
            favoriteViewController.firstFlightNumber=flightNumber;
            favoriteViewController.isStartFavorites =1;
            
            break;
        }
    }
  
    completionHandler();

}

@end

