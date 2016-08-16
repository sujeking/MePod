//
//  HXSUserCreditcardInfoEntity.m
//  store
//
//  Created by ArthurWang on 16/2/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSUserCreditcardInfoEntity.h"

@implementation HXSUserCreditcardBaseInfoEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *baseInfoMapping = @{
                                      @"name":              @"nameStr",
                                      @"id_card_no":        @"idCardNoStr",
                                      @"email":             @"emailNameStr",
                                      @"site_name":         @"siteNameStr",
                                      @"entrance_year":     @"entranceYearIntNum",
                                      @"edu_degree":        @"eduDegreeIntNum",
                                      @"major_name":        @"majorNameStr",
                                      @"dorm_address":      @"dormAddressStr",
                                      @"bank_name":         @"bankNameStr",
                                      @"card_no":           @"cardNoStr",
                                      @"phone":             @"phoneStr",
                                      @"apply_step":        @"applyStepIntNum",
                                      @"have_password":     @"havePasswordIntNum",
                                      };
    
    return [[JSONKeyMapper alloc] initWithDictionary:baseInfoMapping];
}

@end

@implementation HXSUserCreditcardInfoEntity

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping = @{
                              @"account_status":        @"accountStatusIntNum",
                              @"account_apply_days":    @"accountApplyDaysIntNum",
                              @"total_credit":          @"totalCreditDoubleNum",
                              @"available_credit":      @"availableCreditDoubleNum",
                              @"available_consume":     @"availableConsumeDoubleNum",
                              @"available_installment": @"availableInstallmentDoubleNum",
                              @"available_loan":        @"availableLoanDoubleNum",
                              @"line_status":           @"lineStatusIntNum",
                              @"line_apply_days":       @"lineApplyDaysIntNum",
                              @"bank_card_tail":        @"bankCardTailStr",
                              @"recent_bill_amount":    @"recentBillAmountDoubleNum",
                              @"old_status":            @"oldStatusIntNum",
                              @"exemption_status":      @"exemptionStatusIntNum",
                              @"account_base_info":     @"baseInfoEntity",
                              };
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

+ (instancetype)createEntityWithDictionary:(NSDictionary *)creditcardInfoDic
{
    return [[HXSUserCreditcardInfoEntity alloc] initWithDictionary:creditcardInfoDic error:nil];
}

@end
