//
//  MapViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 17.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import  "MapViewController.h"
#import  "LocationService.h"
#import  "DataManager.h"
#import  "APIManager.h"
#import  "MapPrice.h"
#import  "NSString+Localize.h"
#import  "CoreDataHelper.h"
#import  "ProgressView.h"
#import  "MainViewController.h"

@interface   MapViewController  () < MKMapViewDelegate>
@property  ( strong ,  nonatomic )  MKMapView  *mapView;
@property  ( nonatomic ,  strong ) LocationService *locationService;
@property  ( nonatomic ,  strong ) City *origin;
@property  ( nonatomic ,  strong )  NSArray  *prices;

@end

@implementation MapViewController

- ( void )viewDidLoad {
    [ super  viewDidLoad];
    //self .title =  @"Карта цен" ;
    _mapView = [[ MKMapView  alloc] initWithFrame: self .view.bounds];
    _mapView.showsUserLocation =  YES ;
    
    _mapView.delegate = self;
    
    [ self .view addSubview:_mapView];
    [[DataManager sharedInstance] loadData];
    [[ NSNotificationCenter defaultCenter] addObserver: self selector: @selector (dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object: nil ];
    
    [[ NSNotificationCenter defaultCenter] addObserver: self selector: @selector (updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object: nil ];
}

- ( void )dealloc {
    [[ NSNotificationCenter  defaultCenter] removeObserver: self ];
    
}

- ( void )dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- ( void )updateCurrentLocation:( NSNotification  *)notification {
    
    CLLocation  *currentLocation = notification.object;
    
   
//    NSLog(@"currentLocation.coordinate = %lf -%lf", currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    MKCoordinateRegion region =  MKCoordinateRegionMakeWithDistance (currentLocation.coordinate, 1000000 ,  1000000 );
    [_mapView setRegion: region animated:  YES ];
   
    if  (currentLocation) {
        
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        
        if  (_origin) {
            [[APIManager sharedInstance] mapPricesFor:_origin withCompletion:^( NSArray  *prices) {self.prices = prices; }];
            
        }
        
    }
}

- ( void )setPrices:( NSArray  *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
    for  (MapPrice *price  in  prices) {
        dispatch_async (dispatch_get_main_queue(), ^{
            MKPointAnnotation  *annotation = [[ MKPointAnnotation  alloc] init];
        
            //название города и его код
            annotation.title = [NSString stringWithFormat: @"%@ (%@)" , price.destination.name, price.destination.code];
            
            //первая доступная цена перелета
            annotation.subtitle = [ NSString  stringWithFormat: @"перелёт от %ld руб." , ( long )price.value];
            
            
            annotation.coordinate = price.destination.coordinate;
            
//            NSLog(@"%@ currentLocation.coordinate = %lf -%lf",price.destination.name, annotation.coordinate.latitude,annotation.coordinate.longitude);

            
            [_mapView addAnnotation: annotation];
        });
        
    }
}


- ( MKAnnotationView *)mapView:( MKMapView *)mapView viewForAnnotation:( id < MKAnnotation >)annotation {
    
    static   NSString  *identifier =  @"MarkerIdentifier" ;
    MKMarkerAnnotationView *annotationView = ( MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if  (!annotationView) {
        
        annotationView = [[ MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
       // CLLocation * markLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        
        //[self addressFromLocation:markLocation ];

        //отображение выноски с детальной информацией о метке
        annotationView.canShowCallout =  YES ;
        //[annotationView setGlyphText:@"sad"]; это тест метки
        
        
        
        annotationView.calloutOffset =  CGPointMake ( -5.0 ,  5.0 );

        UIButton *infoButton2 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        infoButton2.frame = CGRectMake(4, 4, 150, 28);
        [infoButton2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [infoButton2 setTitle:[NSString stringWithFormat:@"  %@",[@"annotation title" localize]] forState:UIControlStateNormal];
        [infoButton2 setEnabled:YES];
        infoButton2.userInteractionEnabled = YES;
        infoButton2.layer.cornerRadius  =  4.0 ;
        
        annotationView.rightCalloutAccessoryView = infoButton2;
    
        
    }
    annotationView.annotation = annotation;
    
    return  annotationView;
}


//обработка нажатия info на метке карты - выведем адрес текущего города
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl*)control
{


    MKPointAnnotation  *annotation = (MKPointAnnotation *)view.annotation;
    
//    NSLog(@"lat = %lf, lon = %lf",annotation.coordinate.latitude,annotation.coordinate.longitude);
    
    //текущий город
    CLLocation * markLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
    [self addressFromLocation:markLocation ];

    SearchRequest searchRequest1;

    searchRequest1.origin=_origin.code;
    //City * destionation =[[City alloc] init];
    //destionation=;
    searchRequest1.destionation=[[DataManager sharedInstance] cityForLocation:markLocation].code;
    
    //если использовать даты - нужно отладить SearchRequestQuery

    searchRequest1.departDate= NULL; //[NSDate date];
    searchRequest1.returnDate= NULL; //[NSDate date];

//         NSLog(@"from = %@",searchRequest1.origin);
//    NSLog(@"to city = %@",searchRequest1.destionation);
          //NSLog(@"depart date = %@",searchRequest1.departDate);
          //NSLog(@"returnDate = %@",searchRequest1.returnDate);
    
    if  ( searchRequest1.origin && searchRequest1.destionation ) {
        [[ ProgressView   sharedInstance ]  show :^{
            
            [[ APIManager   sharedInstance ] ticketsWithRequest : searchRequest1   withCompletion :^( NSArray
                                                                                                     *tickets) {
                [[ ProgressView   sharedInstance ]  dismiss :^{
                    if (tickets. count  > 0) {
                        
                        //NSLog(@"count ticket = %ld",tickets. count);
                        
                        Ticket * currentTicket =[tickets firstObject];
                        
                        //сам билет добавим в избранное, если он еще не добавлен
                        if  (![[ CoreDataHelper   sharedInstance ]  isFavorite : currentTicket]) {
                            
                            //добавили из поиска - тип 1
                            currentTicket.typeTicket=[NSNumber numberWithInt:2];
                            
                            [[ CoreDataHelper   sharedInstance ]  addToFavorite:currentTicket]  ;
                            
                            UIButton *infoButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                            infoButton3.frame = CGRectMake(4, 4, 150, 28);
                            [infoButton3 setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                            [infoButton3 setTitle:[NSString stringWithFormat:@"  %@",[@"annotation add done" localize]] forState:UIControlStateNormal];
                            [infoButton3 setEnabled:NO];
                            infoButton3.userInteractionEnabled = NO;
                            infoButton3.layer.cornerRadius  =  4.0 ;
                            view.rightCalloutAccessoryView=infoButton3;


                        }

                    }
                }];
                
            }];
        }];
    }

    

}

- ( void )addressFromLocation:( CLLocation  *)location {
    
    CLGeocoder  *geocoder = [[ CLGeocoder  alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^( NSArray < CLPlacemark *> * _Nullable
                                                                  placemarks,  NSError  * _Nullable error) {
        
        if  ([placemarks count] >  0 ) {
            
            for  ( MKPlacemark  *placemark  in  placemarks) {
               NSLog ( @"%@" , placemark.name);
            }
        }
        
    }];
    
}

- ( void )locationFromAddress:( NSString  *)address {
    
    CLGeocoder  *geocoder = [[ CLGeocoder  alloc] init];
    
    [geocoder geocodeAddressString:address completionHandler:^( NSArray <CLPlacemark *> * _Nullable
                                                               placemarks,  NSError  * _Nullable error) {
        
        if  ([placemarks count] >  0 ) {
            
            for  ( MKPlacemark  *placemark  in  placemarks) {
               NSLog ( @"%@" , placemark.location);
            }
        }
        
    }];
    
}

@end
