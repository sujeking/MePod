//
//  HXSWalletApplicationView.m
//  store
//
//  Created by ArthurWang on 16/7/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSWalletApplicationView.h"

@interface HXSWalletApplicationView ()

@property (weak, nonatomic) IBOutlet UIView *applicationView;
/**  申请提示信息 */
@property (weak, nonatomic) IBOutlet UILabel *applicationTipLabel;

@end

@implementation HXSWalletApplicationView

#pragma mark - Public Methods

+ (instancetype)createWalletApplicationView;
{
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                     owner:nil
                                                   options:nil];
    
    HXSWalletApplicationView *applicationView = [viewArr firstObject];
    
    
    return applicationView;
}


#pragma mark - Initial Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialView];
}

- (void)drawRect:(CGRect)rect
{
    [self drawBorderLayer];
}

- (void)initialView
{
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    switch ([creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        case kHXSCreditAccountStatusOpened:
        case kHXSCreditAccountStatusNormalFreeze:
        case kHXSCreditAccountStatusAbnormalFreeze:
        {
            // Do nothing
        }
            break;
        case kHXSCreditAccountStatusChecking:
        {
            self.applicationTipLabel.text = @"您的钱包申请资料已成功提交，我们的工作人员正在快马加鞭进行审核中，请您耐心等待，期间您可能会接到59工作人员的电话向您核实信息，请保持电话畅通。";
        }
            break;
        case kHXSCreditAccountStatusCheckFailed:
        {
            NSString *previousStr = @"抱歉，您的钱包申请暂未通过审核，";
            NSString *daysStr = [NSString stringWithFormat:@"%d天", [creditCardInfo.accountApplyDaysIntNum intValue]];
            NSString *endingStr = @"后再来申请试试吧~";
            NSString *wholeStr = [NSString stringWithFormat:@"%@%@%@", previousStr, daysStr, endingStr];
            
            NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:wholeStr];
            [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(previousStr.length, daysStr.length)];
            
            self.applicationTipLabel.attributedText = mutableAttributedStr;
        }
            break;
            
        default:
            break;
    }
    
    [self layoutIfNeeded];
}

- (void)drawBorderLayer
{
    //View的边框为虚线
    self.applicationView.backgroundColor = [UIColor colorWithRGBHex:0xF6FDFF];
    self.applicationView.layer.cornerRadius = 3;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    CGRect verifyViewRect = self.applicationView.bounds;
    borderLayer.bounds = verifyViewRect;
    borderLayer.position = CGPointMake(CGRectGetMidX(verifyViewRect), CGRectGetMidY(verifyViewRect));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:3].CGPath;
    borderLayer.lineWidth = 0.5;
    borderLayer.lineDashPattern = @[@3, @3];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
    [self.applicationView.layer addSublayer:borderLayer];
}

@end
