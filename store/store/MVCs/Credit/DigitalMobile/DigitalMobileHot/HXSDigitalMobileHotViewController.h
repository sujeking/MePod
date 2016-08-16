//
//  HXSDigitalMobileHotViewController.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@interface HXSDigitalMobileHotViewController : HXSBaseViewController

@property (nonatomic, strong) NSNumber *categoryIDIntNum;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^updateSelectionTitle)(NSInteger index);
@property (nonatomic, copy) void(^scrollviewScrolled)(CGPoint contentOffset);

@end
