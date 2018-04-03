//
//  Ticket.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 26.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property  ( nonatomic ,  strong )  NSNumber  *price;
@property  ( nonatomic ,  strong )  NSString  *airline;
@property  ( nonatomic ,  strong )  NSDate  *departure;
@property  ( nonatomic ,  strong )  NSDate  *expires;
@property  ( nonatomic ,  strong )  NSNumber  *flightNumber;
@property  ( nonatomic ,  strong )  NSNumber  *typeTicket;

@property  ( nonatomic ,  strong )  NSDate  *returnDate;
@property  ( nonatomic ,  strong )  NSString  *from;
@property  ( nonatomic ,  strong )  NSString  *to;

- ( instancetype )initWithDictionary:( NSDictionary  *)dictionary;

@end
