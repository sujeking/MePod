//
//  HXSCreditCollectionReusableView.h
//  store
//
//  Created by ArthurWang on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSBannerHeaderView.h"

#define HEIGHT_CREDIT_CARD_INFO_VIEW    124

@interface HXSCreditCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *creditCardInforView;
@property (weak, nonatomic) IBOutlet UILabel *creditAmountLabel;
@property (weak, nonatomic) IBOutlet UIButton *opreationBtn;
@property (weak, nonatomic) IBOutlet UIButton *amountLayoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *openInTimeBtn;

- (void)updateHeaderView;

@end
