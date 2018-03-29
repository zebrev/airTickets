//
//  LocationService.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 17.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

@interface LocationService : NSObject

@end

@interface   LocationService  () < CLLocationManagerDelegate >
@property  ( nonatomic ,  strong )  CLLocationManager  *locationManager;
@property  ( strong ,  nonatomic )  CLLocation  *currentLocation;

@end


