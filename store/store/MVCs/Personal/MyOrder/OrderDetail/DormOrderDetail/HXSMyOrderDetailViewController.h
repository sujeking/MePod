//
//  HXSMyOrderDetailViewController.h
//  store
//
//  Created by ranliang on 15/4/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"


typedef NS_ENUM(NSInteger, ORDERINFO_SECTION){
    ORDERINFO_SECTION_ADDRESS   = 0,    //地址、配送信息
    ORDERINFO_SECTION_GOODS     = 1,    //商品信息
    ORDERINFO_SECTION_REWARD    = 2,    //活动奖品【满就送】
    ORDERINFO_SECTION_ORDERNUM  = 3,    //订单号信息
};



@class HXSOrderInfo;


@interface HXSMyOrderDetailViewController : HXSBaseViewController

@property (nonatomic, strong) HXSOrderInfo *order;

@end
