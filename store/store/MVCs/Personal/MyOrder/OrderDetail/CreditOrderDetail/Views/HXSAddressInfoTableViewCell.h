//
//  HXSAddressInfoTableViewCell.h
//  store
//
//  Created by  黎明 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSOrderInfo.h"


@interface HXSAddressInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *deliveryInfoLabel;    //配送信息
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;         //收货地址
@property (weak, nonatomic) IBOutlet UILabel *mobileNumLabel;       //手机号
@property (weak, nonatomic) IBOutlet UILabel *commentInfoLabel;     //备注


@property (nonatomic, strong) HXSOrderInfo *orderInfo;

@end
