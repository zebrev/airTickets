//
//  PlaceViewController.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 03.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "DataManager.h"

typedef  enum PlaceType { PlaceTypeArrival, PlaceTypeDeparture} PlaceType;

@protocol  PlaceViewControllerDelegate < NSObject >

- ( void) selectPlace:(id) place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end


@interface PlaceViewController : UIViewController < UITableViewDelegate,UITableViewDataSource >

@property (nonatomic, strong) id < PlaceViewControllerDelegate > delegate;
- (instancetype) initWithType:(PlaceType)type;
@end

