//
//  APIManager.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 08.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "City.h"
#import "APIManager.h"
#import "DataManager.h"
#import "Ticket.h"
#import "MainViewController.h"
#import "MapPrice.h"


@implementation  APIManager

+ ( instancetype )sharedInstance {
    static   APIManager  *instance;
    static   dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{ instance = [[ APIManager   alloc ]  init]  ; });
    
    return  instance;
}

- ( void )cityForCurrentIP:( void  (^)( City *city)) completion {
    [ self   IPAddressWithCompletion :^( NSString  *ipAddress) {
    
        [ self  load :[ NSString  stringWithFormat : @"%@%@" , API_URL_CITY_FROM_IP, ipAddress]
            withCompletion :^( id   _Nullable  result) {
            
        NSDictionary  *json = result;
        NSString  *iata = [json  valueForKey:   @"iata" ];
            if  (iata) {
            City  *city = [[DataManager sharedInstance] cityForIATA:iata];
                if  (city) {
                dispatch_async ( dispatch_get_main_queue (), ^{ completion(city);
                });
            }
        } }];
}];
    
}

- ( void )IPAddressWithCompletion:( void  (^)( NSString  *ipAddress))completion {
    [ self   load :API_URL_IP_ADDRESS  withCompletion :^( id   _Nullable  result) {
        
    NSDictionary  *json = result;
    completion([json  valueForKey :@  "ip" ]);
        
    }];
}

- ( void )load:( NSString  *)urlString withCompletion:( void  (^)( id   _Nullable  result))completion {
    dispatch_async ( dispatch_get_main_queue (), ^{
    [[ UIApplication   sharedApplication ]  setNetworkActivityIndicatorVisible : YES ];
        
    });
    
    [[[ NSURLSession  sharedSession]   dataTaskWithURL :[ NSURL  URLWithString :urlString] completionHandler :^( NSData *  _Nullable data,  NSURLResponse *  _Nullable response,  NSError * _Nullable  error) {\
        dispatch_async ( dispatch_get_main_queue (), ^{
            
            [[ UIApplication   sharedApplication ] setNetworkActivityIndicatorVisible : NO ];
            
        });


        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: nil]);
    }]  resume ] ;
    
}


- (void)ticketsWithRequest:( SearchRequest )request withCompletion:(void (^)( NSArray *tickets))completion {
    NSString *urlString = [ NSString  stringWithFormat : @"%@?%@&token=%@" , API_URL_CHEAP, SearchRequestQuery (request), API_TOKEN];
    [self  load:urlString  withCompletion :^(id _Nullable result) {
        NSDictionary  *response = result;
        if (response) {
            NSDictionary  *json = [[response  valueForKey:   @"data" ]  valueForKey :request.destionation ];
            NSMutableArray  *array = [ NSMutableArray   new ];
            
            for ( NSString  *key in json) {
                
                NSDictionary  *value = [json  valueForKey : key];
                Ticket  *ticket = [[ Ticket   alloc ] initWithDictionary :value];
                ticket.from  = request.origin ;
                ticket.to  = request.destionation ;
                [array  addObject :ticket];
            }
            dispatch_async ( dispatch_get_main_queue (), ^{ completion(array);
            }); }
    }];
    
}


NSString  * SearchRequestQuery( SearchRequest  request) {
    NSString *result = [ NSString  stringWithFormat : @"origin=%@&destination=%@" , request. origin ,
                        request. destionation ];
    if (request. departDate  && request. returnDate ) {
        NSDateFormatter  *dateFormatter = [[ NSDateFormatter   alloc ]  init ]; dateFormatter. dateFormat  =  @"yyyy-MM" ;
        result = [ NSString  stringWithFormat : @"%@&depart_date=%@&return_date=%@" , result, [dateFormatter  stringFromDate :request.departDate ], [dateFormatter  stringFromDate :request. returnDate ]];
    }
    return result;
    
}


- ( void )mapPricesFor:(City *)origin withCompletion:( void  (^)( NSArray  *prices))completion {
    static   BOOL  isLoading;
    if  (isLoading) {  return ; }
    isLoading =  YES ;
    
    [ self load:[ NSString stringWithFormat: @"%@%@" , API_URL_MAP_PRICE, origin.code] withCompletion:^( id  _Nullable result) {
        NSArray  *array = result;
        NSMutableArray  *prices = [ NSMutableArray  new];
        
        if  (array) {
            for  ( NSDictionary  *mapPriceDictionary  in  array) {
                MapPrice *mapPrice = [[MapPrice alloc] initWithDictionary:mapPriceDictionary withOrigin:origin];
                [prices addObject:mapPrice];
            }
            isLoading =  NO ;
            dispatch_async (dispatch_get_main_queue(), ^{
                completion(prices); });
        }
        
    }];
}




@end
