//
//  TabBarControllerViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 23.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "TabBarControllerViewController.h"
#import  "MainViewController.h"
#import  "MapViewController.h"

@implementation TabBarController

- (instancetype ) init {
    self  = [ super   initWithNibName : nil  bundle : nil ];
    if (self) {
        self.viewControllers  = [ self  createViewControllers ];
        
    }
    self.tabBar.tintColor  = [ UIColor   blackColor]  ;
    
    return   self ;
}

- ( NSArray < UIViewController *> *)createViewControllers {
    
    NSMutableArray < UIViewController *> *controllers = [ NSMutableArray   new ];
    
    MainViewController  *mainViewController = [[ MainViewController   alloc ]  init]  ;
    
    mainViewController. tabBarItem  = [[ UITabBarItem   alloc ]  initWithTitle : @"Поиск"  image:[ UIImage imageNamed : @"search" ]  selectedImage :[UIImage   imageNamed : @"search_selected" ]];
    
    UINavigationController  *mainNavigationController = [[ UINavigationController   alloc ] initWithRootViewController :mainViewController];

    [controllers  addObject :mainNavigationController];
    
    MapViewController  *mapViewController = [[ MapViewController   alloc ]  init ];
    
    mapViewController. tabBarItem  = [[ UITabBarItem   alloc ]  initWithTitle : @"Карта цен"  image:[ UIImage imageNamed : @"map" ]  selectedImage :[UIImage imageNamed : @"map_selected" ]];
    
    UINavigationController  *mapNavigationController = [[ UINavigationController   alloc ] initWithRootViewController :mapViewController];
    
    [controllers  addObject :mapNavigationController];
    
    return controllers;
    
}

@end
