//
//  HXSPrintOrderDetailFooterView.m
//  store
//
//  Created by 格格 on 16/3/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintOrderDetailFooterView.h"
#import "HXSPrintOrderInfo.h"

@interface HXSPrintOrderDetailFooterView()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCreateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPayTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPayTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancleResonLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancleResonLabelHeight;


@end

@implementation HXSPrintOrderDetailFooterView

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)setPrintOrderEntity:(HXSPrintOrderInfo *)printOrderEntity{
    
    _printOrderEntity = printOrderEntity;
    
    // 未支付
    if(HXSPrintOrderStatusNotPay == _printOrderEntity.statusIntNum.intValue){
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",printOrderEntity.orderSnLongNum];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.addTimeLongNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        _orderPayTimeLabel.text = @"";
        _orderPayTypeLabel.text = @"";
        _cancleResonLabel.text = @"";
    }else if(HXSPrintOrderStatusCanceled == _printOrderEntity.statusIntNum.intValue){// 取消订单
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",printOrderEntity.orderSnLongNum];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.addTimeLongNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        // 在有支付方式和退款方式同时存在的情况下才显示支付方式
        if(printOrderEntity.paytypeIntNum&&printOrderEntity.refundStatusCodeNum){
            _orderPayTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@",[self payTypeStr]];
            
            date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.payTimeLongNum.longValue];
            _orderPayTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
            
            _cancleResonLabel.text = [NSString stringWithFormat:@"取消理由：%@",printOrderEntity.cancelReasonStr];
            _cancleResonLabelHeight.constant = 13 + [printOrderEntity getCancleResonLabelHeight];
        }else{
            _orderPayTypeLabel.text = @"";
            
            _orderPayTimeLabel.text = @"";
            
            _cancleResonLabel.text = @"";
        }
    }else{
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",printOrderEntity.orderSnLongNum];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.addTimeLongNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        if(printOrderEntity.payTimeLongNum){
            date = [NSDate dateWithTimeIntervalSince1970:printOrderEntity.payTimeLongNum.longValue];
            _orderPayTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        }else{
            _orderPayTimeLabel.text = @"支付时间：";
        }
        _orderPayTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@",[self payTypeStr]];
        _cancleResonLabel.text = @"";
    }
}

- (NSString *)payTypeStr
{
    return [NSString payTypeStringWithPayType:[_printOrderEntity.paytypeIntNum intValue] amount:_printOrderEntity.orderAmountDoubleNum];
}

- (void)setBoxOrderModel:(HXSBoxOrderModel *)boxOrderModel{
    _boxOrderModel = boxOrderModel;
    // 未支付
    if(kHXSBoxOrderStayusNotPay == boxOrderModel.orderStatusNum.intValue){
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",boxOrderModel.orderIdStr];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:boxOrderModel.createTimeNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        _orderPayTimeLabel.text = @"";
        _orderPayTypeLabel.text = @"";
        _cancleResonLabel.text = @"";
    }else if(kHXSBoxOrderStayusCancled == boxOrderModel.orderStatusNum.intValue){// 取消订单
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",boxOrderModel.orderIdStr];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:boxOrderModel.createTimeNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        // 在有支付方式和退款方式同时存在的情况下才显示支付方式
        if(boxOrderModel.orderPayArr.count > 0){
            
            HXSBoxOrderPayItemModel *payItem = [boxOrderModel.orderPayArr objectAtIndex:0];
            _orderPayTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@",payItem.nameStr];
            
            date = [NSDate dateWithTimeIntervalSince1970:payItem.updateTimeNum.longValue];
            _orderPayTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
            _cancleResonLabel.text = @"";
        }else{
            _orderPayTypeLabel.text = @"";
            
            _orderPayTimeLabel.text = @"";
            
            _cancleResonLabel.text = @"";
        }
    }else{
        _orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@",boxOrderModel.orderIdStr];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:boxOrderModel.createTimeNum.longValue];
        _orderCreateTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        
        HXSBoxOrderPayItemModel *payItem = [boxOrderModel.orderPayArr objectAtIndex:0];
        _orderPayTypeLabel.text = [NSString stringWithFormat:@"支付方式：%@",payItem.nameStr];
        
        date = [NSDate dateWithTimeIntervalSince1970:payItem.updateTimeNum.longValue];
        _orderPayTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd HH:mm:ss"]];
        _cancleResonLabel.text = @"";
    }
}
@end
