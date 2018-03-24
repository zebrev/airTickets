//
//  City.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <MapKit/MapKit.h>

@interface City : NSObject

@property (  nonatomic,   strong)   NSString * name;
@property (  nonatomic,   strong)   NSString * timezone;
@property (  nonatomic,   strong)   NSDictionary * translations;
@property (  nonatomic,   strong)   NSString * countryCode;
@property (  nonatomic,   strong)   NSString * code;
@property (  nonatomic)             CLLocationCoordinate2D  coordinate;

- (instancetype) initWithDictionary:( NSDictionary * )dictionary;

@end
