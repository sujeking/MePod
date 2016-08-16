//
//  HXSAddressInfoView.h
//  store
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSAddressEntity;

@protocol HXSEditAddressInfoDelegate <NSObject>

- (void)gotoEditAddressViewcontroller;

@end

@interface HXSAddressInfoView : UIView

@property (nonatomic, weak) id <HXSEditAddressInfoDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;


- (void)initBuyerInfo:(HXSAddressEntity *)addressInfo;
@end
