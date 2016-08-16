//
//  HXSOrderDetailInfoView.h
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileConfirmOrderViewController;
@class HXSConfirmOrderEntity;
@protocol HXSAddressDetailInfoDelegate <NSObject>

- (void)addRemarkAction;
- (void)showCouponAction;
- (void)addMoreInfoForInstallmentAction;
- (void)changeInstallmentAction:(UISwitch *)switchView;
- (void)selectInstallmentDetailAction;
- (void)showInstallmentTip;

@end

@interface HXSOrderDetailInfoView : UIView

@property (nonatomic, weak) id <HXSAddressDetailInfoDelegate> delegate;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
/** 名称 */
@property (weak, nonatomic) IBOutlet UITextView *goodsName;
/** 价格 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
/** 数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
/** 合计 */
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
/** 商品型号 */
@property (weak, nonatomic) IBOutlet UILabel *goodsProperty;
/** 售后 */
@property (weak, nonatomic) IBOutlet UILabel *goodsService;
/** 留言 */
@property (weak, nonatomic) IBOutlet UILabel *remark;
/** 优惠券 */
@property (weak, nonatomic) IBOutlet UILabel *coupon;
/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *carriage;
/** 首付 */
@property (weak, nonatomic) IBOutlet UILabel *downPayment;
/** 月供 */
@property (weak, nonatomic) IBOutlet UILabel *monthPayments;
/** 分期时间 */
@property (weak, nonatomic) IBOutlet UILabel *installmentTime;
/** 手续费 */
@property (weak, nonatomic) IBOutlet UILabel *installmentPayment;
@property (weak, nonatomic) IBOutlet UIButton *installmentTipButton;

@property (weak, nonatomic) IBOutlet UISwitch *installSwitch;
@property (weak, nonatomic) IBOutlet UILabel *noInstallmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoForInstallment;
@property (weak, nonatomic) IBOutlet UIButton *creditCardInfoButton;
@property (weak, nonatomic) IBOutlet UIImageView *installmentArrowIcon;

@property (weak, nonatomic) IBOutlet UIView *installInfoView;

- (void)initOrderDetailInfo:(HXSConfirmOrderEntity *)orderDetail;
@end
