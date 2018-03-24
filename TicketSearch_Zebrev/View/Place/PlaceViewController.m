//
//  PlaceViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 03.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "PlaceViewController.h"
#import "DataManager.h"
#import "CustomTableViewCell.h"

#define ReuseIdentifier @"CellIdentifier"

@interface  PlaceViewController () < UISearchResultsUpdating>

/*
 Изначально объявляются приватные свойства:
 ● placeType - для хранение типа места (отправление или прибытие);
 ● table hidesSearchBarWhenScrollingiew - таблица, в которой будут выводиться данные о городах или аэропортах;
 ● segmentedControl - переключатель для выбора источника данных;
 ● currentArray - массив для хранения и вывода значений для текущего источника данных.
 */
@property (nonatomic) PlaceType placeType;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISegmentedControl * segmentedControl;
@property (nonatomic,strong) NSArray * currentArray;
@property  ( nonatomic ,  strong )  NSArray  *searchArray;
@property  ( nonatomic ,  strong )  UISearchController  *searchController;

@end

@implementation  PlaceViewController

- (instancetype) initWithType:(PlaceType)type {
    self = [ super init];
    if (self)  {
        _placeType = type;
        
    }
    return  self;
    
}

- ( void) viewDidLoad {
    [ super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [ UIColor blackColor];

    _searchController  = [[ UISearchController   alloc ]  initWithSearchResultsController : nil ];
    _searchController . dimsBackgroundDuringPresentation  =  NO ;
    _searchController . searchResultsUpdater  =  self ;
    _searchArray  = [ NSArray   new ];
    
    //чтоб поиск был всегда виден
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    
    
    _tableView = [[ UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain] ;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if  ( @available (iOS  11.0 , *)) {
        self . navigationItem . searchController  =  _searchController ;
        
    }  else  {
       _tableView . tableHeaderView  =  _searchController . searchBar ;
    }
    
    [self.view addSubview:_tableView]
    ;
    _segmentedControl = [[ UISegmentedControl alloc] initWithItems:@[@"Города",@"Аэропорты"]];
    [_segmentedControl addTarget: self action: @selector( changeSource) forControlEvents: UIControlEventValueChanged] ;
    _segmentedControl.tintColor = [ UIColor blackColor];
    
    self. navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex =  0;
    [ self changeSource];
    
    
    if (_placeType == PlaceTypeDeparture) {
        self. title =  @"Откуда";
    }
    else {
        self. title =  @"Куда";
    }
    
}

- ( void) changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case  0:
            _currentArray = [[DataManager sharedInstance] cities];
            break;
        case  1:
            _currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
        
        break;
            
    }
    [ self. tableView reloadData];
    
}


#pragma mark - UISearchResultsUpdating
- ( void )updateSearchResultsForSearchController:( UISearchController  *)searchController {
    if  (searchController. searchBar . text ) {
    
        NSPredicate  *predicate = [ NSPredicate   predicateWithFormat : @"SELF.name CONTAINS[cd] %@" , searchController. searchBar . text ];
    
        _searchArray  = [ _currentArray  filteredArrayUsingPredicate : predicate];
        
    [ _tableView   reloadData ];
        
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger) tableView:( UITableView *)tableView numberOfRowsInSection:( NSInteger) section
{
    if  ( _searchController . isActive  && [ _searchArray   count ] >  0 ) {
        return  [ _searchArray   count ];
    }

    return [_currentArray count];
}


- (UITableViewCell*)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ UITableViewCell alloc] initWithStyle:  UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        
    }
    /*
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier] ;
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier] ;
    }
*/
    //NSString * strCode, *strName;
  /*
    if (_segmentedControl.selectedSegmentIndex ==  0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];


        strName = city.name;
        strCode = [NSString stringWithFormat:@"(%@)",city.code];
        
        //cell.textLabel.text = city.name;
        //cell.detailTextLabel.text = city.code;
    }
    else
        if (_segmentedControl.selectedSegmentIndex ==  1) {
            Airport *airport = [_currentArray objectAtIndex:indexPath.row];

            strName = airport.name;
            strCode = [NSString stringWithFormat:@"(%@)",airport.code];
            
//            cell.textLabel.text = airport.name;
//            cell.detailTextLabel.text = airport.code;
        }
   
    cell.leftLabel.text =  strName;
    cell.rightLabel.text = strCode;
    */
    
    if  ( _segmentedControl . selectedSegmentIndex  ==  0 ) {
        City  *city = ( _searchController . isActive  && [ _searchArray   count ] >  0 ) ?
        [ _searchArray objectAtIndex :indexPath. row ] :
        [ _currentArray   objectAtIndex :indexPath. row ];
        
        cell. textLabel . text  = city. name ;
        
        cell. detailTextLabel . text  = city. code ;
        
    }
    else
        if  ( _segmentedControl . selectedSegmentIndex  ==  1 ) {
       
            Airport  *airport = ( _searchController . isActive  && [ _searchArray   count ] >  0 ) ?
            [ _searchArray  objectAtIndex :indexPath. row ] :
            [ _currentArray   objectAtIndex :indexPath. row ];
            cell. textLabel . text  = airport. name ;
            
            cell. detailTextLabel . text  = airport. code ;
            
        }

    return cell;
    
}

- ( void) tableView:( UITableView *)tableView commitEditingStyle:( UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:( NSIndexPath *)indexPath
{
}

#pragma mark - UITableViewDelegate

- ( void) tableView:( UITableView *)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) +  1;
   // [ self. delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    //[ self. navigationController popViewControllerAnimated: YES] ;
    
    if  ( _searchController . isActive  && [ _searchArray   count ] >  0 ) {
        
        [ self . delegate   selectPlace :[ _searchArray   objectAtIndex :indexPath. row ]  withType:   _placeType andDataType :dataType];
        
        _searchController . active  =  NO ;
        
    }  else  {
        
            [ self . delegate   selectPlace :[ _currentArray   objectAtIndex :indexPath. row ]  withType:   _placeType andDataType :dataType];
        }
    
    [ self . navigationController   popViewControllerAnimated : YES ];
}

@end
