//
//  HXSCouponViewCell.h
//  store
//
//  Created by 格格 on 16/5/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCouponViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * yuanLabel;
@property (nonatomic, weak) IBOutlet UILabel * discountLabel;
@property (nonatomic, weak) IBOutlet UILabel * materialLabel;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * codeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * codeLabel;
@property (nonatomic, weak) IBOutlet UILabel * expireTimeNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * expireTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * couponTipLabel;

@property (nonatomic, weak) IBOutlet UIImageView * imageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;


@end
