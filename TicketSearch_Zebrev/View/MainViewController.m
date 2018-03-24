//
//  ViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation  MainViewController

UIButton * button;

- (  void) viewDidLoad {
    [  super  viewDidLoad];
    
    
    CGRect frame  =  CGRectMake( [ UIScreen  mainScreen].bounds.size.width/ 2 -   100.0,  [UIScreen mainScreen].bounds.size.height/ 2 -   25.0,200.0,50.0) ;
    button  = [  UIButton  buttonWithType:  UIButtonTypeSystem] ;
    
    [button setTitle:@"Загрузить данные" forState:UIControlStateNormal]   ;
    button.backgroundColor  = [UIColor  blueColor];
    button.tintColor  = [UIColor  whiteColor];
    button.frame  = frame;
    [button addTarget:self action:@selector(loadDataStart:) forControlEvents: UIControlEventTouchUpInside] ;
    [self.view  addSubview:button];

    self.view.backgroundColor  = [  UIColor  whiteColor];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];

}


- (  void)loadDataStart:( UIButton * )sender
{
    [ [DataManager  sharedInstance] loadData];
}

/*
//  Метод, к оторый  будет  вызван  при  нажатии  на к нопку
- (  void) loadData:( UIButton * )sender
{


}
*/
- (  void) dealloc
{
    [[ NSNotificationCenter  defaultCenter] removeObserver:self  name:kDataManagerLoadDataDidComplete object:nil] ;
}

- (  void) loadDataComplete
{
    self.view.backgroundColor  = [UIColor yellowColor];
    [button removeFromSuperview];
    button = nil;
    
   
    //Теперь перейдем на другой контроллер
    
    self. view.backgroundColor  = [  UIColor  whiteColor];
    CGRect redViewFrame  =  CGRectMake(  40.0,   40.0,  [  UIScreen  mainScreen].bounds.size.width -   80.0,  [ UIScreen  mainScreen].bounds.size.height -   80.0) ;
    UIView * redView  = [ [ UIView  alloc] initWithFrame: redViewFrame];
    redView.backgroundColor  = [  UIColor redColor];
    [ self. view  addSubview: redView];
    
    CGRect labelFrame  =  CGRectMake(  10.0,   10.0,  [  UIScreen  mainScreen].bounds.size.width -   80.0,  [ UIScreen  mainScreen].bounds.size.height -   80.0) ;
    UILabel * label  = [ [ UILabel  alloc] initWithFrame: labelFrame];
    label.font  = [  UIFont  systemFontOfSize: 12.0  weight: UIFontWeightBold] ;
    label.textColor  = [  UIColor  yellowColor];
    label.textAlignment  =  NSTextAlignmentCenter;
    label.text  =  @"Данные были загружены";
    [ redView  addSubview: label];

}



@end
