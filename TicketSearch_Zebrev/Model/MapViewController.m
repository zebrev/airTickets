//
//  MapViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 17.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "MapViewController.h"
#import  "LocationService.h"
#import  "DataManager.h"
#import  "APIManager.h"
#import  "MapPrice.h"


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
        
        annotationView.calloutOffset =  CGPointMake ( -5.0 ,  5.0 );

        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeDetailDisclosure ];
    }
    
    annotationView.annotation = annotation;
    
    return  annotationView;
}


//обработка нажатия info на метке карты - выведем адрес текущего города
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl*)control
{
    MKPointAnnotation  *annotation = (MKPointAnnotation *)view.annotation;
    
    //NSLog(@"lat = %lf, lon = %lf",annotation.coordinate.latitude,annotation.coordinate.longitude);
    
    CLLocation * markLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    
    [self addressFromLocation:markLocation ];

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
