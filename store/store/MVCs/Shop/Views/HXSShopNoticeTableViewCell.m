//
//  HXSShopNoticeTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopNoticeTableViewCell.h"

// Model
#import "HXSShopEntity.h"

// Views
#import "HXSLineView.h"

@interface HXSShopNoticeTableViewCell ()

@end

@implementation HXSShopNoticeTableViewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSShopEntity *)entity
{
    // notice 只有云超市才显示营业时间
    if (entity.statusIntNum.integerValue == kHXSShopStatusClosed
        && entity.shopTypeIntNum.integerValue == kHXSShopTypeStore) {
        self.shopNoticeLabel.text = [NSString stringWithFormat:@"同学很抱歉,该店铺已经打烊了,营业时间: %@", entity.businesHoursStr];
    } else {
        self.shopNoticeLabel.text = entity.noticeStr;
    }
}

@end
