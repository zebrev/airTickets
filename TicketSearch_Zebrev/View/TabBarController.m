//
//  TabBarControllerViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 23.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "TabBarController.h"
#import  "MainViewController.h"
#import  "MapViewController.h"
#import "TicketsViewController.h"
#import "NSString+Localize.h"

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
    
    mainViewController. tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"search_tab" localize] image: [UIImage imageNamed:@"data/resource/search.png"] selectedImage:[UIImage imageNamed:@"data/resource/search_selected.png"]];
    
    /*
    mainViewController. tabBarItem = [[ UITabBarItem  alloc ]  initWithTitle : [@"search_tab" localize] image:[ UIImage imageNamed : @"data/resource/search.png" ]  selectedImage :[UIImage   imageNamed : @"data/resource/search_selected.png" ]];
    */
    
    UINavigationController *mainNavigationController = [[ UINavigationController  alloc ] initWithRootViewController :mainViewController];
    
    [controllers  addObject :mainNavigationController];
    
    MapViewController  *mapViewController = [[ MapViewController   alloc ]  init ];
    mapViewController. tabBarItem = [[ UITabBarItem  alloc ]  initWithTitle : [@"map_tab" localize] image:[ UIImage                                                                                         imageNamed :@"data/resource/map_find.png" ] selectedImage :[UIImage imageNamed :@"data/resource/map_find_selected.png" ]];
    
    UINavigationController *mapNavigationController = [[ UINavigationController alloc ]                                                      initWithRootViewController :mapViewController];

    [controllers  addObject :mapNavigationController];
                                                       
    TicketsViewController *favoriteViewController = [[TicketsViewController alloc] initFavoriteTicketsController ];
    
    favoriteViewController.tabBarItem = [[ UITabBarItem  alloc ]  initWithTitle : [@"favorites_tab" localize] image:[ UIImage  imageNamed:   @"data/resource/favorites.png" ]  selectedImage :[UIImage imageNamed : @"data/resource/favorites_selected.png" ]];
    
    UINavigationController *favoriteNavigationController = [[ UINavigationController  alloc ] initWithRootViewController :favoriteViewController];
    
    
    [controllers  addObject :favoriteNavigationController];
    
    return controllers;
    
    
}

@end
