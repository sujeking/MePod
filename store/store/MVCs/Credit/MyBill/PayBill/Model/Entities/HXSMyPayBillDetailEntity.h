//
//  HXSMyPayBillDetailEntities.h
//  store
//
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HXSMyPayBillDetailEntity
@end

@interface HXSMyPayBillDetailEntity : HXBaseJSONModel

/**消费说明 */
@property (nonatomic, strong) NSString *textStr;
/**消费时间 */
@property (nonatomic, strong) NSNumber *timeStrNum;
/**消费金额 */
@property (nonatomic, strong) NSNumber *amountNum;
/**int 消费类型 0:零食  1:电影 2:充值 3.酒店 4.KTV 5.美食 */
@property (nonatomic, readwrite) HXSMyBillConsumeBillDetailsType typeNum;
/**图标地址 */
@property (nonatomic, strong) NSString *urlStr;

@end

@interface HXSMyPayBillEntity : HXBaseJSONModel

/**bill_id */
@property (nonatomic, strong) NSNumber *billIDNum;
/**bill_time 出账日 long */
@property (nonatomic, strong) NSNumber *billTimeNum;
/**bill_amount 账单金额 double */
@property (nonatomic, strong) NSNumber *billAmountNum;
/**int   账单状态 0未还款  1已还款 2已逾期 */
@property (nonatomic, readwrite) HXSMyBillConsumeStatus billStatusNum;
/**service_fee_desc:str   服务费说明 */
@property (nonatomic, strong) NSString *billServiceFeeDescStr;
/**int  是否分期  0未分期；1已分期； */
@property (nonatomic, readwrite) HXSMyBillConsumeInstallmentStatus installmentStatusNums;
/**installment_amount double 可分期金额*/
@property (nonatomic, strong) NSNumber *installmentAmountNum;

@property (nonatomic, strong) NSArray<HXSMyPayBillDetailEntity> *detailArr;

@end;

