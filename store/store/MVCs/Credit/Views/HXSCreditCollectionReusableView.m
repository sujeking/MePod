//
//  HXSCreditCollectionReusableView.m
//  store
//
//  Created by ArthurWang on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditCollectionReusableView.h"


#define HIGHT_AMOUNT  8000.00

static NSString *DidNotOpenCreditCardPromptString = @"59钱包开通后最高可享额度（元）";
static NSString *CreditCardAmountPromptString     = @"59钱包可用总额度（元）";
static NSString *DidLoginPromptString             = @"登录后查看钱包额度";

@interface HXSCreditCollectionReusableView ()

// credit info
@property (weak, nonatomic) IBOutlet UILabel *creditAmountTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *freezeImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

@implementation HXSCreditCollectionReusableView

- (void)awakeFromNib
{
    [self initialView];
}


#pragma mark - Initial View

- (void)initialView
{
    [self.creditAmountLabel      setHidden:YES];
    [self.freezeImageView        setHidden:YES];
    [self.loginLabel             setHidden:YES];
    
    [self.opreationBtn           setHidden:YES];
    [self.amountLayoutBtn        setHidden:YES];
    [self.openInTimeBtn          setHidden:YES];
}


#pragma mark - Public Methods

- (void)updateHeaderView
{
    [self initialView];
    
    if ([HXSUserAccount currentAccount].isLogin) {
        [self.creditAmountLabel      setHidden:NO];
        
        HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
        
        switch ([creditCardInfo.accountStatusIntNum intValue]) {
            case kHXSCreditAccountStatusNotOpen:
            {
                [self.openInTimeBtn setHidden:NO];
                
                [self.creditAmountTitleLabel setText:DidNotOpenCreditCardPromptString];
                [self.creditAmountLabel setText:[NSString stringWithFormat:@"%0.2f", HIGHT_AMOUNT]];
                [self.creditAmountLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.4]];
            }
                break;
                
            case kHXSCreditAccountStatusOpened:
            {
                [self.opreationBtn    setHidden:NO];
                [self.amountLayoutBtn setHidden:NO];
                [self.opreationBtn    setEnabled:YES];
                
                [self.creditAmountTitleLabel setText:CreditCardAmountPromptString];
                [self.creditAmountLabel setText:[NSString stringWithFormat:@"%0.2f", [creditCardInfo.availableCreditDoubleNum doubleValue]]];
                [self.creditAmountLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0]];
                
                switch ([creditCardInfo.lineStatusIntNum intValue]) {
                    case kHXSCreditLineStatusInit:
                    {
                        // Do nothing
                    }
                        break;
                        
                    case kHXSCreditLineStatusChecking:
                    {
                        [self.opreationBtn    setEnabled:NO];
                    }
                        break;
                        
                    case kHXSCreditLineStatusDone:
                    {
                        [self.opreationBtn    setHidden:YES];
                    }
                        break;
                        
                    case kHXSCreditLineStatusFailed:
                    {
                        [self.opreationBtn    setEnabled:NO];
                    }
                        break;
                        
                    case kHXSCreditLineStatusDataNotClear:
                    {
                        // Do nothing
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
                
            case kHXSCreditAccountStatusNormalFreeze:
            case kHXSCreditAccountStatusAbnormalFreeze:
            {
                [self.freezeImageView setHidden:NO];
                [self.amountLayoutBtn setHidden:NO];
                
                [self.creditAmountTitleLabel setText:CreditCardAmountPromptString];
                [self.creditAmountLabel setText:[NSString stringWithFormat:@"%0.2f", [creditCardInfo.availableCreditDoubleNum doubleValue]]];
                [self.creditAmountLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.4]];
            }
                break;
                
            case kHXSCreditAccountStatusChecking:
            {
                [self.creditAmountTitleLabel setText:DidNotOpenCreditCardPromptString];
                [self.creditAmountLabel setText:[NSString stringWithFormat:@"%0.2f", HIGHT_AMOUNT]];
                [self.creditAmountLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.4]];
            }
                break;
                
            case kHXSCreditAccountStatusCheckFailed:
            {
                [self.creditAmountTitleLabel setText:DidNotOpenCreditCardPromptString];
                [self.creditAmountLabel setText:[NSString stringWithFormat:@"%0.2f", HIGHT_AMOUNT]];
                [self.creditAmountLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:0.4]];
            }
                break;
                
            default:
                break;
        }
    } else { // 未登录
        [self.loginLabel                setHidden:NO];
        
        [self.creditAmountTitleLabel setText:CreditCardAmountPromptString];
    }
}

@end
