
//
//  HXSMyNewPayBillInstallmentHeaderView.m
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyNewPayBillInstallmentHeaderView.h"

@interface HXSMyNewPayBillInstallmentHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView      *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel          *confirmSuccessLabel;

@end

@implementation HXSMyNewPayBillInstallmentHeaderView

+ (id)myNewPayBillInstallmentHeaderView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

- (void)awakeFromNib
{
}

@end
