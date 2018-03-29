//
//  DataManager.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"

// константа, к оторая  содержит  имя  уведомления;
#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

//перечисление  с  возможными типами  данных
typedef  enum  DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
}  DataSourceType;


@interface DataManager : NSObject

//синглтон, для того, чтобы можно было однозначно определить существование лишь одного  объекта  этого к ласса;
+ ( instancetype) sharedInstance;

//метод  для з агрузки  данных  из  файлов j son;
- ( void) loadData;

- ( City  *)cityForIATA:( NSString  *)iata;
- (City *)cityForLocation:( CLLocation  *)location;
    
//массивы для хранения готовых объектов данных, которые доступны только на  чтение.
@property (  nonatomic,   strong,  readonly)   NSArray * countries;
@property (  nonatomic,   strong,  readonly)   NSArray * cities;
@property (  nonatomic,   strong,  readonly)   NSArray * airports;


@end
