//
//  HXSPromptCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPromptCollectionViewCell.h"

@interface HXSPromptCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end

@implementation HXSPromptCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark - Public Methods

- (void)updatePromptLabel
{
    NSString *messageStr = nil;
    
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        {
            // Do nothing
        }
            break;
            
        case kHXSCreditAccountStatusOpened:
        {
            switch ([creditCardInfo.lineStatusIntNum intValue]) {
                case kHXSCreditLineStatusInit:
                {
                    // Do nothing
                }
                    break;
                    
                case kHXSCreditLineStatusChecking:
                {
                    messageStr = @"您的59钱包开通申请正在审核中...";
                }
                    break;
                    
                case kHXSCreditLineStatusDone:
                {
                    // Do nothing
                }
                    break;
                    
                case kHXSCreditLineStatusFailed:
                {
                    if (0 < [creditCardInfo.lineApplyDaysIntNum integerValue]) {
                        messageStr = [NSString stringWithFormat:@"审核未通过，%@天后可重新申请", creditCardInfo.lineApplyDaysIntNum];
                    } else {
                        messageStr = [NSString stringWithFormat:@"审核未通过"];
                    }
                }
                    break;
                    
                case kHXSCreditLineStatusDataNotClear:
                {
                    messageStr = @"您的59钱包提额申请资料被打回，请重新上传";
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
            // Do nothing
        }
            break;
            
        case kHXSCreditAccountStatusChecking:
        {
            messageStr = @"您的59钱包开通申请正在审核中...";
        }
            break;
            
        case kHXSCreditAccountStatusCheckFailed:
        {
            if (0 < [creditCardInfo.accountApplyDaysIntNum integerValue]) {
                messageStr = [NSString stringWithFormat:@"审核未通过，%@天后可重新申请", creditCardInfo.accountApplyDaysIntNum];
            } else {
                messageStr = [NSString stringWithFormat:@"审核未通过"];
            }
        }
            break;
            
        default:
            break;
    }
    
    self.promptLabel.text = messageStr;
}

+ (BOOL)shouldDisplayPromptView
{
    BOOL display = NO;
    
    HXSUserCreditcardInfoEntity *creditCardInfo = [HXSUserAccount currentAccount].userInfo.creditCardInfo;
    
    switch ([creditCardInfo.accountStatusIntNum intValue]) {
        case kHXSCreditAccountStatusNotOpen:
        {
            // Do nothing
        }
            break;
            
        case kHXSCreditAccountStatusOpened:
        {
            switch ([creditCardInfo.lineStatusIntNum intValue]) {
                case kHXSCreditLineStatusInit:
                {
                    // Do nothing
                }
                    break;
                    
                case kHXSCreditLineStatusChecking:
                {
                    display = YES;
                }
                    break;
                    
                case kHXSCreditLineStatusDone:
                {
                    // Do nothing
                }
                    break;
                    
                case kHXSCreditLineStatusFailed:
                {
                    display = YES;
                }
                    break;
                    
                case kHXSCreditLineStatusDataNotClear:
                {
                    display = YES;
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
            // Do nothing
        }
            break;
            
        case kHXSCreditAccountStatusChecking:
        {
            display = YES;
        }
            break;
            
        case kHXSCreditAccountStatusCheckFailed:
        {
            display = YES;
        }
            break;
            
        default:
            break;
    }
    
    return display;
}

@end
