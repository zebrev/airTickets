//
//  TicketsViewController.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 26.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "TicketsViewController.h"
#import  "CoreDataHelper.h"
#import  "TicketTableViewCell.h"
#import <Foundation/Foundation.h>
#import "NotificationCenter.h"
#import "NSString+Localize.h"

#define TicketCellReuseIdentifier @"TicketCellIdentifier"

@interface   TicketsViewController  ()

@property  ( nonatomic ,  strong )  NSArray  *tickets;
@property  ( nonatomic ,  strong )  UIDatePicker  *datePicker;
@property  ( nonatomic ,  strong )  UITextField  *dateTextField;



@end

@implementation TicketsViewController {

    BOOL isFavorites;
    TicketTableViewCell  *notificationCell;
}


- ( instancetype )initFavoriteTicketsController {
    self  = [ super   init ];
    
    if  ( self ) {
        isFavorites = YES;
        self.isStartFavorites=1;
        self . tickets  = [ NSArray   new ];
        self . title  =  [@"favorites_header" localize];
        self . tableView . separatorStyle  =  UITableViewCellSeparatorStyleNone ;
        [ self . tableView  registerClass :[ TicketTableViewCell
                                            class ] forCellReuseIdentifier :TicketCellReuseIdentifier];
    }
    return   self ;
}


- ( instancetype )initWithTickets:( NSArray  *)tickets {
    self  = [ super   init ];
    
    self.isStartFavorites=0;
    
    if  ( self )
    {
        _tickets  = tickets;
        self . title  =  [@"tickets_title" localize] ;
        self . tableView . separatorStyle  =  UITableViewCellSeparatorStyleNone ;
        [ self . tableView  registerClass :[ TicketTableViewCell  class ] forCellReuseIdentifier :TicketCellReuseIdentifier];
        
        _datePicker  = [[ UIDatePicker   alloc ]  init ];
        _datePicker . datePickerMode  =  UIDatePickerModeDateAndTime ;
        _datePicker . minimumDate  = [ NSDate   date ];
        _dateTextField  = [[ UITextField   alloc ]  initWithFrame : self . view . bounds ];
        _dateTextField . hidden  =  YES ;
        _dateTextField . inputView  =  _datePicker ;
        
        UIToolbar  *keyboardToolbar = [[ UIToolbar   alloc ]  init ];
        [keyboardToolbar  sizeToFit ];
        UIBarButtonItem  *flexBarButton = [[ UIBarButtonItem   alloc ]
                                           initWithBarButtonSystemItem : UIBarButtonSystemItemFlexibleSpace   target : nil   action : nil ];
        UIBarButtonItem  *doneBarButton = [[ UIBarButtonItem   alloc ] initWithBarButtonSystemItem : UIBarButtonSystemItemDone   target : self action : @selector (doneButtonDidTap:)];
        keyboardToolbar. items  =  @[ flexBarButton, doneBarButton ] ;
        _dateTextField . inputAccessoryView  = keyboardToolbar;
        [ self . view   addSubview : _dateTextField ];
    }
   
    return   self ;
}


- (  void) viewDidLoad {
    [  super  viewDidLoad];
    
}


- ( void )viewDidAppear:( BOOL )animated {
    [ super   viewDidAppear :animated];
 
    if (self.isStartFavorites)
        isFavorites= YES;
    
    //Считаем список избранных билетов из CoreData
    if  ( isFavorites ) {
        
        self . navigationController . navigationBar . prefersLargeTitles  =  YES ;
        _tickets  = [[ CoreDataHelper  sharedInstance ]  favorites ];
        [ self . tableView   reloadData ];
    }

    //Если на старте задан определенный билет - найдем его в списке
    if (self.firstFlightNumber) {
    //NSLog(@"first number = %@",self.firstFlightNumber);
    
        //список массив билетов
        for (id item in self.tickets) {
            
            FavoriteTicket * ticket = item;
            
            //определим индекс билета
            NSUInteger index = [self.tickets indexOfObject:item];
            
//            NSLog(@"index = %ld",index);
            
            int flightNumber =ticket.flightNumber;
            
            if (flightNumber==self.firstFlightNumber.intValue) {

                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

                self.firstFlightNumber=nil;
                break;
            }
        }
    }
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- ( NSInteger )tableView:( UITableView  *)tableView numberOfRowsInSection:( NSInteger )section {
    return   _tickets . count ;
}

- ( UITableViewCell *)tableView:( UITableView *)tableView cellForRowAtIndexPath:( NSIndexPath *)indexPath {
    
   
    TicketTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier :TicketCellReuseIdentifier forIndexPath :indexPath];
    
    if  ( isFavorites ) {
        cell.favoriteTicket  = [ _tickets   objectAtIndex:  indexPath. row ];
    }  else  {
        cell. ticket  = [ _tickets   objectAtIndex :indexPath.row ];
        
    }
    
    //cell. selectionStyle  =  UITableViewCellSelectionStyleNone ;
    //cell. ticket  = [ _tickets   objectAtIndex :indexPath.row ];
    
    //просто обновляем фон ячейки зеленым цветом с эффектом анимации (надо скроллить для наглядности)
    cell.backgroundColor = [UIColor clearColor];
    //UIViewAnimationOptionAllowUserInteraction - это чтобы не блокировался скроллинг
    [UIView animateWithDuration:5.0 delay:0.2 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.backgroundColor = [UIColor greenColor];
    } completion:^(BOOL finished)
     {
         //NSLog(@"Color transformation Completed");
     }];

    
    
return  cell;
    
}

- ( CGFloat )tableView:( UITableView  *)tableView heightForRowAtIndexPath:( NSIndexPath  *)indexPath {
    
    return   140.0 ;
}


- ( void )tableView:( UITableView  *)tableView didSelectRowAtIndexPath:( NSIndexPath  *)indexPath {
    
   
    if  ( isFavorites )  return ;
    
    UIAlertController *alertController = [ UIAlertController  alertControllerWithTitle :[@"actions_with_tickets" localize] message: [@"actions_with_tickets_describe" localize] preferredStyle:UIAlertControllerStyleActionSheet];
    
    //NSLog(@"3! %d",indexPath.row);
    
    UIAlertAction  *favoriteAction;
    
    if  ([[ CoreDataHelper   sharedInstance ]  isFavorite : [ _tickets   objectAtIndex :indexPath.row ]]) {
        
        favoriteAction = [UIAlertAction  actionWithTitle :[@"remove_from_favorite" localize] style: UIAlertActionStyleDestructive  handler:^( UIAlertAction  *  _Nonnull  action) {
            
            [[ CoreDataHelper   sharedInstance ]  removeFromFavorite:  [ _tickets   objectAtIndex :indexPath.row ]];
            
        }];
    }  else  {

       
        favoriteAction = [UIAlertAction  actionWithTitle :[@"add_to_favorite" localize] style: UIAlertActionStyleDefault  handler:^( UIAlertAction  *  _Nonnull  action) {
            
            [[ CoreDataHelper   sharedInstance ]  addToFavorite:  [ _tickets   objectAtIndex :indexPath. row ]];

            TicketsViewController  *ticketsViewController = [[ TicketsViewController   alloc ]
                                                             initFavoriteTicketsController];

            //Анимация для перехода на вкладку "Избранное"
            CATransition *transition = [CATransition animation];
            transition.duration = 1.35;
            transition.timingFunction = [CAMediaTimingFunction      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn;
            transition.subtype =kCATransitionFromRight;
            
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            [[self navigationController] showViewController:ticketsViewController sender :self];

            
        }];
    }
    
    
    UIAlertAction  *notificationAction = [ UIAlertAction   actionWithTitle : [@"remind_me" localize] style:( UIAlertActionStyleDefault ) handler:^( UIAlertAction  *  _Nonnull  action) {
        
        notificationCell  = [tableView  cellForRowAtIndexPath :indexPath];
        
        NSLog(@"notification = %@ ",notificationCell.ticket);
        [ _dateTextField   becomeFirstResponder ];
        
    }];


    UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle : [@"close" localize] style: UIAlertActionStyleCancel handler: nil ];
    
    [alertController  addAction :favoriteAction];
    [alertController  addAction :cancelAction];
      [alertController  addAction :notificationAction];
    
    [ self   presentViewController :alertController  animated : YES   completion : nil ];
}


- ( void )doneButtonDidTap:( UIBarButtonItem  *)sender {
    
    if  ( _datePicker . date  &&  notificationCell ) {
        
        NSString  *message = [ NSString   stringWithFormat : @"%@ - %@ за %@ руб." ,
                              notificationCell . ticket .from,  notificationCell . ticket .to,  notificationCell .ticket .price];
        NSURL  *imageURL;
        
           if  ( notificationCell.airlineLogoView . image ) {
            
               NSString  *path = [[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask ,  YES )  firstObject ]  stringByAppendingString :[ NSString stringWithFormat : @"/%@.png" , notificationCell . ticket . airline ]];
            
               if  (![[ NSFileManager   defaultManager]   fileExistsAtPath :path]) {
                UIImage  *logo =  notificationCell . airlineLogoView . image ;
                NSData  *pngData =  UIImagePNGRepresentation (logo);
                [pngData  writeToFile :path  atomically : YES ];
               }

               imageURL = [ NSURL   fileURLWithPath :path];
            
           }

        Notification  notification =  NotificationMake ( [@"ticket_reminder" localize] , message, _datePicker.date,  imageURL );
        
        //отправляем напоминалку
        [[ NotificationCenter   sharedInstance ]  sendNotification :notification ticketFlightNumber:notificationCell.ticket.flightNumber];

        //сам билет автоматически добавим в избранное, если он еще не добавлен
        if  (![[ CoreDataHelper   sharedInstance ]  isFavorite : notificationCell.ticket])
            [[ CoreDataHelper   sharedInstance ]  addToFavorite:notificationCell.ticket]  ;

        UIAlertController  *alertController = [ UIAlertController   alertControllerWithTitle : [@"success" localize] message:[ NSString   stringWithFormat : @"%@ - %@" ,[@"notification_will_be_sent" localize],_datePicker.date] preferredStyle:( UIAlertControllerStyleAlert )];

        UIAlertAction  *closeAction = [ UIAlertAction   actionWithTitle : [@"close" localize] style: UIAlertActionStyleCancel  handler:^( UIAlertAction  *  _Nonnull  action) {
            
            //после отправки напоминалки возвращаемся на главное окно
            [self.navigationController popToRootViewControllerAnimated:YES];
            

        }];
        
        [alertController  addAction :closeAction];
        
        [ self   presentViewController :alertController  animated : YES   completion : nil ];
        
        
        
    }
    _datePicker . date  = [ NSDate   date ];

    //обнуляем
    notificationCell  =  nil ;

    [ self . view   endEditing : YES ];
}

@end

