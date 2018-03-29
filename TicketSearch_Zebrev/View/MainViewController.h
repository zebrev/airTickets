//
//  ViewController.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

typedef  struct SearchRequest {
    __unsafe_unretained  NSString *origin;
    __unsafe_unretained  NSString *destionation;
    __unsafe_unretained  NSDate *departDate;
    __unsafe_unretained  NSDate *returnDate;
} SearchRequest;




@end

