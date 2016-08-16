//
//  HXSAmountCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSAmountCollectionViewCell.h"

@interface HXSAmountCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *consumptionAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *encashmentAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentAmountLabel;

@end


@implementation HXSAmountCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark - Public Methods

- (void)updateAmountValues
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    [self.consumptionAmountLabel setText:[NSString stringWithFormat:@"%0.2f", [creditCardInfo.availableConsumeDoubleNum doubleValue]]];
    [self.encashmentAmountLabel setText:[NSString stringWithFormat:@"%0.2f", [creditCardInfo.availableLoanDoubleNum doubleValue]]];
    [self.installmentAmountLabel setText:[NSString stringWithFormat:@"%0.2f", [creditCardInfo.availableInstallmentDoubleNum doubleValue]]];
}

@end
