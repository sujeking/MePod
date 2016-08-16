//
//  HXSDigitalMobileAddressViewController.h
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSPickView.h"
#import "HXSAddressEntity.h"

@protocol HXSAddressControllerDelegate <NSObject>

- (void)didSaveAddress:(HXSAddressEntity *)addressInfo;

@end

@interface HXSDigitalMobileAddressViewController : HXSBaseViewController<HXSPickViewDelegate>

@property (nonatomic, weak) id<HXSAddressControllerDelegate> delegate;

- (void)initData:(HXSAddressEntity *)addressInfo;
@end
