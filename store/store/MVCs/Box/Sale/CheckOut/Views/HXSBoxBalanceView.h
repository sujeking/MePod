//
//  HXSBoxBalanceView.h
//  store
//
//  Created by  黎明 on 16/6/17.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXSBoxBalanceViewDelegate <NSObject>

- (void)createOrderAction;

@end

@interface HXSBoxBalanceView : UIView
@property (nonatomic, weak) id<HXSBoxBalanceViewDelegate> delegate;

@end
