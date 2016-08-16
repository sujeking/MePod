//
//  HXSDigitalMobileHeaderTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileDetailEntity;

@interface HXSDigitalMobileHeaderTableViewCell : UITableViewCell

+ (CGFloat)heightOfHeaderViewForOrder:(HXSDigitalMobileDetailEntity *)detailEntity;

- (void)setupCellWithEntity:(HXSDigitalMobileDetailEntity *)detailEntity;

@end
