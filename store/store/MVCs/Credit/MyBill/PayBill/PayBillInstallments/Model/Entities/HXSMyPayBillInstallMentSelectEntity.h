//
//  HXSMyPayBillInstallMentSelectEntity.h
//  store
//  消费账单分期选择,下拉选择合适的月份返回的分期数和月供
//  Created by J006 on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSMyPayBillInstallMentSelectEntity : HXBaseJSONModel

/**monthly_payments:double  月供 */
@property (nonatomic, strong) NSNumber *monthlyPaymentsNum;
/** installment_number:int  分期数 */
@property (nonatomic, strong) NSNumber *installmentNum;

@end
