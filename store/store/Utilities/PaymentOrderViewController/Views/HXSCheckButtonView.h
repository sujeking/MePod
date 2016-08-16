//
//  HXSCheckButtonView.h
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSCheckButtonView : UIView

@property (weak, nonatomic) IBOutlet HXSRoundedButton *checkButton;
/**
 *  确认支付操作
 */
@property (copy, nonatomic) void (^paymentAction)();

@end
