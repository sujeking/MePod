//
//  UIBarButtonItem+HXSRedPoint.h
//  store
//
//  Created by ArthurWang on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HXSRedPoint)

@property (strong, atomic) UILabel *redPointBadge;
// Badge value to be display
@property (nonatomic) NSString *redPointBadgeValue;

@end
