//
//  NotificationCenter.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 24.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef   struct  Notification {
    __unsafe_unretained   NSString  *  _Nullable  title;
    __unsafe_unretained   NSString  *  _Nonnull  body;
    __unsafe_unretained   NSDate  *  _Nonnull  date;
    __unsafe_unretained   NSURL  *  _Nullable  imageURL;
} Notification;

@interface NotificationCenter : NSObject

+ ( instancetype   _Nonnull )sharedInstance;
- ( void )registerService;
- ( void )sendNotification:( Notification )notification;

Notification  NotificationMake( NSString *  _Nullable  title,  NSString *  _Nonnull  body,  NSDate *  _Nonnull  date, NSURL  *  _Nullable  imageURL);


@end
