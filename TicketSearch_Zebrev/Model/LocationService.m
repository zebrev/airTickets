//
//  LocationService.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 17.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "LocationService.h"

@implementation   LocationService

- ( instancetype )init {
    self  = [ super  init];
    if  ( self ) {
        _locationManager = [[ CLLocationManager  alloc] init];
        _locationManager.delegate =  self ;

        [_locationManager requestAlwaysAuthorization];
    }
    
    return   self ;
}


- ( void )locationManager:( CLLocationManager *)manager didChangeAuthorizationStatus:( CLAuthorizationStatus )status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }  else   if  (status != kCLAuthorizationStatusNotDetermined) {
        
        UIAlertController *alertController2 = [ UIAlertController alertControllerWithTitle: @"Упс!" message: @"Не удалось определить текущий город!"  preferredStyle:  UIAlertControllerStyleAlert ];
        
        [alertController2 addAction:[ UIAlertAction actionWithTitle: @"Закрыть" style:( UIAlertActionStyleDefault )
                                                            handler: nil ]];
        
        [[ UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController2 animated: YES  completion: nil ];
        
    }
    
}

- ( void )locationManager:( CLLocationManager *)manager didUpdateLocations:( NSArray < CLLocation *> *)locations {
    
    if  (!_currentLocation) {
        _currentLocation = [locations firstObject]; [_locationManager stopUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
        
    }
}

@end

