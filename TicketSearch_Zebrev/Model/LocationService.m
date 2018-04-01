//
//  LocationService.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 17.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "LocationService.h"
#import "NSString+Localize.h"

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
        
        UIAlertController *alertController2 = [ UIAlertController alertControllerWithTitle: [@"opps!" localize] message: [@"not_determine_current_city" localize] preferredStyle:  UIAlertControllerStyleAlert ];
        
        [alertController2 addAction:[ UIAlertAction actionWithTitle: [@"close" localize] style:( UIAlertActionStyleDefault )
                                                            handler: nil ]];
        
        [[ UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController2 animated: YES  completion: nil ];
        
    }
    
}

- ( void )locationManager:( CLLocationManager *)manager didUpdateLocations:( NSArray < CLLocation *> *)locations {
    

    
    if  (!_currentLocation) {

        //_currentLocation = [locations firstObject];
        
        //зададим по умолчанию Москву
        _currentLocation = [[CLLocation alloc] initWithLatitude:55.7522200 longitude:37.6155600];
        
        [_locationManager stopUpdatingLocation];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
        
    }
}

@end

