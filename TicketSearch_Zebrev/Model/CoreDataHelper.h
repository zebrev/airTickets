//
//  CoreDataHelper.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 24.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CoreData/CoreData.h>
#import  "DataManager.h"
#import  "FavoriteTicket+CoreDataClass.h"
#import  "Ticket.h"

@interface CoreDataHelper : NSObject

+ ( instancetype )sharedInstance;

- ( BOOL )isFavorite:( Ticket  *)ticket;
- ( NSArray  *)favorites;
- ( void )addToFavorite:( Ticket  *)ticket;
- ( void )removeFromFavorite:( Ticket  *)ticket;

@end
