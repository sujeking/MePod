//
//  HXSCashModel.h
//  store
//
//  Created by 格格 on 16/5/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSKnightInfo.h"

@interface HXSCashModel : NSObject
/**
 *  获取个人信息
 *
 *  @param block
 */
+ (void)getKnightInfo:(void(^)(HXSErrorCode code, NSString * message, HXSKnightInfo * knightInfo))block;

/**
 *  佣金提现
 *
 *  @param amount         提现金额
 *  @param bank_card_no   银行卡号
 *  @param bank_name      银行名称
 *  @param bank_city      开户城市
 *  @param bank_user_name 开户人
 *  @param bank_site      开户网点
 *  @param bankCode       银行类型对应的code
 *  @param block
 */
+ (void)knightWithdrawWithAmount:(NSNumber *)amount
                      bankCardNo:(NSString *)bank_card_no
                        bankName:(NSString *)bank_name
                        bankCity:(NSString *)bank_city
                    bankUserName:(NSString *)bank_user_name
                        bankSite:(NSString *)bank_site
                        bankCode:(NSString *)bank_code
                        complete:(void(^)(HXSErrorCode code, NSString * message, NSDictionary *data))block;



@end
