//
//  DataManager.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "DataManager.h"

@interface  DataManager ( )

@property (  nonatomic,   strong)   NSMutableArray * countriesArray;
@property (  nonatomic,   strong)   NSMutableArray * citiesArray;
@property (  nonatomic,   strong)   NSMutableArray * airportsArray;

@end

@implementation  DataManager

+ ( instancetype) sharedInstance
{
    static  DataManager * instance;
    static  dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance  = [[DataManager alloc] init];
    });

    return instance;
}

- (  void) loadData
{
    dispatch_async( dispatch_get_global_queue(QOS_CLASS_UTILITY , 0) , ^{
        
        NSArray * countriesJsonArray  = [self arrayFromFileName:@"data/countries" ofType: @"json"] ;
        _countriesArray  = [self createObjectsFromArray:countriesJsonArray  withType: DataSourceTypeCountry];
        NSArray * citiesJsonArray  = [self arrayFromFileName:@"data/cities" ofType: @"json"] ;
        _citiesArray  = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        NSArray * airportsJsonArray  = [self arrayFromFileName:@"data/airports" ofType: @"json"] ;
        _airportsArray  = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        dispatch_async( dispatch_get_main_queue(), ^{
            [[NSNotificationCenter  defaultCenter]  postNotificationName:kDataManagerLoadDataDidComplete object: nil] ;
        });
        
        NSLog(  @"Complete load  data") ;
    }
    );
}


/*
 метод для создания массива готовых объектов из массива объектов NSDictionary.
 Входными параметрами метода являются сам массив объектов NSDictionary и тип данных ( в к акой  объект  будет  преобразован)
 */
- (  NSMutableArray * )createObjectsFromArray:( NSArray * )array  withType:(DataSourceType)type {
    NSMutableArray * results  = [  NSMutableArray  new];
    for (  NSDictionary * jsonObject in  array) {
        if ( type  ==  DataSourceTypeCountry) {
            Country * country  = [ [Country  alloc] initWithDictionary: jsonObject];
            [ results  addObject:  country];
    }
        else if ( type  ==  DataSourceTypeCity) {
            City * city  = [ [City  alloc] initWithDictionary: jsonObject];
            [ results  addObject:  city];
        }
        else if ( type  ==  DataSourceTypeAirport) {
            Airport * airport  = [ [Airport  alloc] initWithDictionary: jsonObject];
            [ results  addObject:  airport];
        }
    }
    return results;
    
}

/*
 метод для загрузки массива объектов NSDictionary из файлов json. Входными параметрами  метода  является  имя  и т ип  файла.
 */
- (  NSArray * )arrayFromFileName:( NSString * )fileName  ofType:( NSString * )type
{
    NSString * path  = [ [ NSBundle  mainBundle]  pathForResource:fileName  ofType:type];
    NSData * data  = [  NSData  dataWithContentsOfFile:path];
    return [NSJSONSerialization  JSONObjectWithData:data  options:NSJSONReadingMutableContainers error: nil] ;
}

- (  NSArray * )countries
{
    return  _countriesArray;
    
}

- (  NSArray * )cities
{
    return  _citiesArray;
    
}

- (  NSArray * )airports
{
    return  _airportsArray;
    
}

- ( City  *)cityForIATA:( NSString  *)iata {
    if  (iata) {
        for  ( City  *city  in   _citiesArray ) {
            
            if  ([city. code   isEqualToString :iata]) {
            return  city;
            }
        }
    }
    
  return   nil ;
    
}

- (City *)cityForLocation:( CLLocation  *)location {
    for  (City *city  in  _citiesArray) {
    if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude) && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
        return  city;
    }
}
    return   nil ;
}

@end
