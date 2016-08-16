//
//  HXSShopNoticeTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSLineView, HXSShopEntity;

@interface HXSShopNoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shopNoticeLabel;
@property (nonatomic, readwrite) BOOL         isInTheShopMainView;//是否已经点击进入店铺

- (void)setupCellWithEntity:(HXSShopEntity *)entity;

@end
