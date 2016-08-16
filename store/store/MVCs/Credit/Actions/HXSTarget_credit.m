//
//  HXSTarget_credit.m
//  store
//
//  Created by ArthurWang on 16/6/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTarget_credit.h"

#import "HXSCreditWalletViewController.h"

@implementation HXSTarget_credit

/** 跳转信用钱包页面 */
- (UIViewController *)Action_creditWallet:(NSDictionary *)paramsDic
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:nil];
    HXSCreditWalletViewController *creditWalletVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSCreditWalletViewController"];
    
    return creditWalletVC;
}

@end
