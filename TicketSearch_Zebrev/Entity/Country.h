//
//  Country.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 31.01.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Country : NSObject

@property (  nonatomic,   strong)   NSString * name;
@property (  nonatomic,   strong)   NSString * currency;
@property (  nonatomic,   strong)   NSDictionary * translations;
@property (  nonatomic,   strong)   NSString * code;

- (instancetype) initWithDictionary:( NSDictionary * )dictionary;

@end
