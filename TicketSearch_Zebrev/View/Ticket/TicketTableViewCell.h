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
#import  "Ticket.h"

@interface TicketTableViewCell :  UITableViewCell

@property  ( nonatomic ,  strong )  Ticket  *ticket;

@end

