//
//  ProgressView.h
//  TicketSearch_Zebrev
//
//  Created by Rapax on 24.03.2018.
//  Copyright © 2018 Rapax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (instancetype)sharedInstance;
- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;


@end
