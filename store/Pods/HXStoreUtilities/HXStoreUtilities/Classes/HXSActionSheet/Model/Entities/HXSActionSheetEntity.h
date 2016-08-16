//
//  HXSActionSheetEntity.h
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXBaseJSONModel.h"

@interface HXSActionSheetEntity : HXBaseJSONModel

@property (nonatomic, strong) NSNumber *payTypeIntNum;  // 0表示现金，1表示支付宝，2表示微信支付，3表示信用钱包，4表示支付宝扫码付
@property (nonatomic, strong) NSString *nameStr;        // 名称
@property (nonatomic, strong) NSString *iconURLStr;     // 图标
@property (nonatomic, strong) NSString *descriptionStr; // 描述
@property (nonatomic, strong) NSString *promotionStr;   // 促销信息  // 有促销信息时显示促销信息，否则显示描述信息

+ (NSArray *)createActionSheetEntityWithPaymentArr:(NSArray *)paymentArr;

@end
