//
//  HXSAddressInfoTableViewCell.m
//  store
//
//  Created by  黎明 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAddressInfoTableViewCell.h"

@interface HXSAddressInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryInfoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsInfoContraint;

@end

@implementation HXSAddressInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderInfo:(HXSOrderInfo *)orderInfo
{
   [self updateContentHeight:orderInfo];
    
    self.deliveryInfoLabel.text = @"无";
    
    self.addressLabel.text = (orderInfo.consigneeAddressStr.length == 0) ? @"无" : orderInfo.consigneeAddressStr;
    
    self.mobileNumLabel.text = (orderInfo.phone.length == 0) ? @"无" : orderInfo.phone;
    
    self.commentInfoLabel.text = (orderInfo.remark.length == 0) ? @"无" : orderInfo.remark;
}

- (void)updateContentHeight:(HXSOrderInfo *)orderInfo
{
    // 100 is fixed width of padding
    CGFloat addressInfoHeight = [orderInfo.consigneeAddressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, 0)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                          context:nil].size.height;
    
    // 102 is fixed width of padding
    CGFloat remarkInfoHeight = [orderInfo.remark boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 102, 0)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                         context:nil].size.height;
    
    self.addressConstraint.constant         = ( addressInfoHeight == 0 ) ? self.addressConstraint.constant : ceilf(addressInfoHeight);

    if ((remarkInfoHeight == 0) || (remarkInfoHeight < self.commentsInfoContraint.constant)) {
        self.commentsInfoContraint.constant = self.commentsInfoContraint.constant;
    } else {
        self.commentsInfoContraint.constant = ceilf(remarkInfoHeight);
    }
}
@end
