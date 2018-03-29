//
//  APIManager.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 08.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "DataManager.h"
#import "MainViewController.h"

#define API_TOKEN @ "5b92e0d082fb6890bff9d5a10ff9c953"
#define API_URL_IP_ADDRESS @ "https://api.ipify.org/?format=json"
#define API_URL_CHEAP @ "https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_CITY_FROM_IP @ "https://www.travelpayouts.com/whereami?ip="

#define API_URL_MAP_PRICE @"http://map.aviasales.ru/prices.json?origin_iata="

@interface  APIManager :  NSObject

#define AirlineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@ "https://pics.avs.io/200/200/%@.png" , iata]];
- (void)ticketsWithRequest:( SearchRequest )request withCompletion:(void (^)( NSArray *tickets))completion;

+ ( instancetype )sharedInstance;
- ( void )cityForCurrentIP:( void  (^)( City  *city))completion;

- ( void )mapPricesFor:(City *)origin withCompletion:( void  (^)( NSArray  *prices))completion;
    
@end


