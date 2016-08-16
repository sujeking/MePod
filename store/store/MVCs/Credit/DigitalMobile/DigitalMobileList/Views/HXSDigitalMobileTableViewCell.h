//
//  HXSDigitalMobileTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileItemListEntity;

@interface HXSDigitalMobileTableViewCell : UITableViewCell

- (void)setupCellWithEntity:(HXSDigitalMobileItemListEntity *)itemListEntity;

@end
