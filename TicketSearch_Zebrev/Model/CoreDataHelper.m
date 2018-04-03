//
//  CoreDataHelper.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 24.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "CoreDataHelper.h"
#import  "FavoriteTicket+CoreDataClass.h"

@interface CoreDataHelper()

@property  ( nonatomic ,  strong )  NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property  ( nonatomic ,  strong )  NSManagedObjectContext  *managedObjectContext;
@property  ( nonatomic ,  strong )  NSManagedObjectModel  *managedObjectModel;

@end

@implementation CoreDataHelper

+ ( instancetype )sharedInstance {
    static   CoreDataHelper  *instance;
    static   dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ CoreDataHelper   alloc ] init ];
        
        [instance  setup ];
        
    });
    
    return  instance;
}

- ( void )setup {
    
    NSURL  *modelURL = [[ NSBundle   mainBundle ]  URLForResource : @"FavoriteTicket"   withExtension : @"momd" ];
    _managedObjectModel  = [[ NSManagedObjectModel   alloc ]  initWithContentsOfURL :modelURL];
    
    NSURL *docsURL = [[[ NSFileManager  defaultManager ]  URLsForDirectory :NSDocumentDirectory inDomains : NSUserDomainMask ]  lastObject ];
    
    NSURL  *storeURL = [docsURL  URLByAppendingPathComponent : @"base.sqlite" ];
    _persistentStoreCoordinator = [[ NSPersistentStoreCoordinator  alloc ] initWithManagedObjectModel : _managedObjectModel ];
    
    NSPersistentStore * store = [_persistentStoreCoordinator addPersistentStoreWithType : NSSQLiteStoreType   configuration : nil   URL :storeURL  options : nil   error : nil ];
    
    if  (!store) {
        abort ();
        
    }
    
    _managedObjectContext = [[ NSManagedObjectContext  alloc ] initWithConcurrencyType : NSMainQueueConcurrencyType ];
    _managedObjectContext . persistentStoreCoordinator  =  _persistentStoreCoordinator ;
}

- ( void )save {
    NSError  *error;
    [ _managedObjectContext   save : &error];
    if  (error) {
        NSLog ( @"%@" , [error  localizedDescription ]);
    }
}

- ( FavoriteTicket  *)favoriteFromTicket:( Ticket  *)ticket {
    NSFetchRequest  *request = [ NSFetchRequest   fetchRequestWithEntityName : @"FavoriteTicket" ];
    request. predicate = [ NSPredicate  predicateWithFormat : @"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld" , ( long )ticket. price . integerValue , ticket.airline , ticket. from , ticket. to , ticket. departure , ticket. expires , ( long )ticket. flightNumber . integerValue ];
    
    return  [[ _managedObjectContext  executeFetchRequest :request  error : nil ]  firstObject ];
}


- ( BOOL )isFavorite:( Ticket  *)ticket {
    return  [ self   favoriteFromTicket :ticket] !=  nil ;
}

- ( void )addToFavorite:( Ticket  *)ticket{
    FavoriteTicket *favorite = [NSEntityDescription  insertNewObjectForEntityForName : @"FavoriteTicket" inManagedObjectContext : _managedObjectContext ];
    
    favorite. price  = ticket. price . intValue ;
    favorite. airline  = ticket. airline ;
    favorite. departure  = ticket. departure ;
    favorite. expires  = ticket. expires ;
    favorite. flightNumber  = ticket. flightNumber . intValue ;
    favorite. returnDate  = ticket. returnDate ;
    favorite. typeTicket  = ticket. typeTicket . intValue ;
    favorite. from  = ticket. from ;
    favorite. to  = ticket. to ;
    favorite. created  = [ NSDate   date ];
    [ self   save ];
}

- ( void )removeFromFavorite:( Ticket  *)ticket {
    FavoriteTicket  *favorite = [ self   favoriteFromTicket :ticket];
    if  (favorite) {
    [ _managedObjectContext   deleteObject :favorite];
    [ self   save ];
        
    }
}

- ( NSArray  *)favorites:(int )typeTicket {
    NSFetchRequest  *request = [ NSFetchRequest   fetchRequestWithEntityName : @"FavoriteTicket" ];
    request.sortDescriptors  =  @[[ NSSortDescriptor   sortDescriptorWithKey : @"created"   ascending : NO ]] ;

    if (typeTicket>0)
        
        request. predicate = [ NSPredicate  predicateWithFormat : @"typeTicket == %ld" , ( long )typeTicket];

    
    return [ _managedObjectContext  executeFetchRequest: request error : nil ];
}

@end

