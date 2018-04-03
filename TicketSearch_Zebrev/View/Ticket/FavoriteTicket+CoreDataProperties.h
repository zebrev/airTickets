//
//  FavoriteTicket+CoreDataProperties.h
//  
//
//  Created by Rapax on 24.03.2018.
//
//

#import "FavoriteTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) int64_t price;
@property (nonatomic) int16_t flightNumber;
@property (nonatomic) int16_t typeTicket;       //=1 - это избранные билеты из поиска, =2 - избранные билеты с карты

@end

NS_ASSUME_NONNULL_END
