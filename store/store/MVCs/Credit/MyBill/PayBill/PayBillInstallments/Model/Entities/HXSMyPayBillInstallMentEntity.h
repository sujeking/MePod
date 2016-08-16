//
//  HXSMyPayBillInstallMentEntity.h
//  store
//  消费类账单分期
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSMyPayBillInstallMentEntity : HXBaseJSONModel

/**bill_amount Double 分期金额 */
@property (nonatomic, strong) NSNumber *billAmountNum;
/**installment_amount:Double 月供 */
@property (nonatomic, strong) NSNumber *installmentAmount;
/**installment_num: Integer 10 分期期数 */
@property (nonatomic, strong) NSNumber *installmentNum;
/**first_date:str   第一笔还款日期时间戳 */
@property (nonatomic, strong) NSString *firstDateStr;
/**end_date:str   最后一笔还款日期时间戳 */
@property (nonatomic, strong) NSString *endDateStr;

@end
