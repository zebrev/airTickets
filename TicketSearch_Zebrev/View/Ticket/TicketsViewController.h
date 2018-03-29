//
//  TicketsViewController.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 26.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController

- (instancetype)initWithTickets:( NSArray  *)tickets;
- ( instancetype )initFavoriteTicketsController;
    
@end
