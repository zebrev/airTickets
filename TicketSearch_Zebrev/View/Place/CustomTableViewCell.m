//
//  CustomTableViewCell.m
//  TicketSearch_Zebrev
//
//  Created by Rapax on 03.02.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (instancetype) initWithStyle:( UITableViewCellStyle) style reuseIdentifier:( NSString *)reuseIdentifier
{
    self = [ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [[ UILabel alloc] initWithFrame: CGRectMake(  0.0,  0.0, [ UIScreen mainScreen].bounds.size.width /  2.0,  44.0) ];
        _leftLabel.textAlignment =  NSTextAlignmentCenter;
        [ self. contentView addSubview:_leftLabel];
        _rightLabel = [[ UILabel alloc] initWithFrame:  CGRectMake( [ UIScreen mainScreen].bounds.size.width / 2.0,  0.0, [ UIScreen mainScreen].bounds.size.width /  2.0,  44.0) ];
        _rightLabel.textAlignment =  NSTextAlignmentCenter;
        [ self. contentView addSubview:_rightLabel];
        
    }
    return  self;
    
}

@end
