//
//  HXSPrintOrderDetaiNoPaylFooterView.m
//  store
//
//  Created by 格格 on 16/4/8.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderDetaiNoPaylFooterView.h"
#import "HXSPrintOrderInfo.h"

@interface HXSPrintOrderDetaiNoPaylFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCreateTimeLabel;

@end

@implementation HXSPrintOrderDetaiNoPaylFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setPrintOrderEntity:(HXSPrintOrderInfo *)printOrderEntity{
    _printOrderEntity = printOrderEntity;
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",printOrderEntity.orderSnLongNum];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.addTimeLongNum.longValue];
    _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
    
}

@end
