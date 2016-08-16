//
//  HXSEncashmentCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSCreditCardLoanInfoModel;

@protocol HXSEncashmentCollectionViewCellDelegate <NSObject>

@required
- (void)didSelectLoanInfo:(HXSCreditCardLoanInfoModel *)loanInfoModel;

- (void)didSelectLoanAgreement;

@end

@interface HXSEncashmentCollectionViewCell : UICollectionViewCell

- (void)setupEncahmentCollectionViewCellWithLoanInfo:(NSArray *)loanInfoArr
                                            delegate:(id<HXSEncashmentCollectionViewCellDelegate>)delegate;

@end
