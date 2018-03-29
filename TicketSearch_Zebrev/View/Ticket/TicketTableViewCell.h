//
//  TicketTableViewCell.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 26.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <UIKit/UIKit.h>

#import  "DataManager.h"
#import  "APIManager.h"
#import  "FavoriteTicket+CoreDataClass.h"
#import  "Ticket.h"


@interface TicketTableViewCell :  UITableViewCell

@property  ( nonatomic ,  strong )  UIImageView  *airlineLogoView;
@property  ( nonatomic ,  strong )  UILabel  *priceLabel;
@property  ( nonatomic ,  strong )  UILabel  *placesLabel;
@property  ( nonatomic ,  strong )  UILabel  *dateLabel;

@property  ( nonatomic ,  strong )  Ticket  *ticket;
@property  ( nonatomic ,  strong )  FavoriteTicket  *favoriteTicket;
@end

