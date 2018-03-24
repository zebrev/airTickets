//
//  Airport.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "Airport.h"

@implementation Airport

- ( instancetype) initWithDictionary:( NSDictionary * )dictionary
{
    self  = [  super init];
    if (  self)  {
        _timezone  = [ dictionary  valueForKey: @"time_zone"] ;
        _translations  = [ dictionary  valueForKey:@  "name_translations"] ;
        _name  = [ dictionary  valueForKey: @"name"] ;
        _countryCode  = [ dictionary  valueForKey: @"country_code"] ;
        _cityCode  = [ dictionary  valueForKey: @"city_code"] ;
        _code  = [ dictionary  valueForKey: @"code"] ;
        _flightable  = [ dictionary valueForKey: @"flightable"] ;
        NSDictionary * coords  = [ dictionary  valueForKey: @"coordinates"] ;
        if ( coords  && ! [coords isEqual:[ NSNull  null]]) {
            NSNumber * lon  = [ coords  valueForKey: @"lon"] ;
            NSNumber * lat  = [ coords  valueForKey: @"lat"] ;
            if ( ![lon isEqual:[ NSNull  null]]  && ! [lat isEqual:[ NSNull  null]]) {
                _coordinate  =  CLLocationCoordinate2DMake( [lat  doubleValue], [ lon  doubleValue]);
                
            }
        }
    }
    return  self;
    
}

@end
