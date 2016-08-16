//
//  HXSUserCreditcardInfoEntity.h
//  store
//
//  Created by ArthurWang on 16/2/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@interface HXSUserCreditcardBaseInfoEntity : HXBaseJSONModel

@property (nonatomic, strong) NSString *nameStr;                // 姓名
@property (nonatomic, strong) NSString *idCardNoStr;            // 身份证号
@property (nonatomic, strong) NSString *emailNameStr;           // 邮箱
@property (nonatomic, strong) NSString *siteNameStr;            // 学校名称
@property (nonatomic, strong) NSNumber *entranceYearIntNum;     // 入学年份
@property (nonatomic, strong) NSNumber *eduDegreeIntNum;        // 学历 "1", "博士"；"2", "硕士"；"3", "本科"；"4", "专科"；
@property (nonatomic, strong) NSString *majorNameStr;           // 专业名称
@property (nonatomic, strong) NSString *dormAddressStr;         // 宿舍地址
@property (nonatomic, strong) NSString *bankNameStr;            // 所属银行名称
@property (nonatomic, strong) NSString *cardNoStr;              // 银行卡号
@property (nonatomic, strong) NSString *phoneStr;               // 预留手机号码
@property (nonatomic, strong) NSNumber *applyStepIntNum;        // 申请步骤
@property (nonatomic, strong) NSNumber *havePasswordIntNum;             // 是否设置密码 0无密码，1有密码,

@end


@interface HXSUserCreditcardInfoEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *accountStatusIntNum;        // 是否开通 0:未开通 1:已开通（正常） 2:冻结账户(逾期等)；3:异常冻结（被盗） 4.电审审核中（初始额度0） 5.审核失败
@property (nonatomic, strong) NSNumber *accountApplyDaysIntNum;     // 账户申请剩余天数，账户审核失败后才有
@property (nonatomic, strong) NSNumber *totalCreditDoubleNum;       // 总信用额度
@property (nonatomic, strong) NSNumber *availableCreditDoubleNum;   // 可用总额度
@property (nonatomic, strong) NSNumber *availableConsumeDoubleNum;  // 可消费额度
@property (nonatomic, strong) NSNumber *availableInstallmentDoubleNum;      // 可分期额度
@property (nonatomic, strong) NSNumber *availableLoanDoubleNum;             // 可取现额度
@property (nonatomic, strong) NSNumber *lineStatusIntNum;               // 额度状态   0:初始额度；1:提升额度审核中；2:已提升额度; 3:额度提升失败
@property (nonatomic, strong) NSNumber *lineApplyDaysIntNum;            // 账户提升额度申请剩余天数，账户提升额度审核失败后才有
@property (nonatomic, strong) NSNumber *recentBillAmountDoubleNum;      // 近期账单金额
@property (nonatomic, strong) NSNumber *oldStatusIntNum;                // 0老用户，1新用户
@property (nonatomic, strong) NSString *bankCardTailStr;                // 银行卡尾号
@property (nonatomic, strong) NSNumber *exemptionStatusIntNum;          // 是否免密 0不免密；1免密；

@property (nonatomic, strong) HXSUserCreditcardBaseInfoEntity *baseInfoEntity;    // 兼容原白花花数据迁移添加


+ (instancetype)createEntityWithDictionary:(NSDictionary *)creditcardInfoDic;

@end
