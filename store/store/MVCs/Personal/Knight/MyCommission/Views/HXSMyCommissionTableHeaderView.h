//
//  HXSMyCommissionTableHeaderView.h
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSMyCommissionTableHeaderView : UIView

@property (nonatomic, weak) IBOutlet UILabel *myCommissionLabel;
@property (nonatomic, weak) IBOutlet UIRenderingButton *getCashButton;

+ (id)headerView;
- (void)updategetCashButtonStatus:(BOOL)enable;
@end
