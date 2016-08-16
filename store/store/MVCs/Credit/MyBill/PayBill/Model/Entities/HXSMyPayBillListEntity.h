//
//  HXSMyPayBillListEntities.h
//  store
//  消费类账单列表,只是列表，详细信息需要单独请求
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSMyPayBillDetailEntity.h"

@interface HXSMyPayBillListEntity : HXBaseJSONModel

/**bill_id */
@property (nonatomic, strong) NSNumber *billIDNum;
/**bill_time int long*/
@property (nonatomic, strong) NSNumber *billTimeNum;
/**账单金额 double*/
@property (nonatomic, strong) NSNumber *billAmountNum;
/**int   账单状态 0未还款  1已还款 2已逾期*/
@property (nonatomic, readwrite) HXSMyBillConsumeStatus billStatusNum;
/**service_fee_desc:str   服务费说明*/
@property (nonatomic, strong) NSString *billServiceFeeDescStr;
/**int   账单类型 0本期账单  1下期账单 2历史账单*/
@property (nonatomic, readwrite) HXSMyBillConsumeType billTypeNum;
/**int  是否分期  0未分期；1已分期；*/
@property (nonatomic, readwrite) HXSMyBillConsumeInstallmentStatus installmentStatusNums;
/**installment_amount double 可分期金额*/
@property (nonatomic, strong) NSNumber *installmentAmountNum;
/**在拿取列表的接口中无法获得,只用以后期赋值*/
@property (nonatomic, strong) HXSMyPayBillEntity *billEntity;


@end
