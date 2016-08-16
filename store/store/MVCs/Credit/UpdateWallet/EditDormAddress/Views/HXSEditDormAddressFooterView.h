//
//  HXSInfoSubmitCompleteFooterView.h
//  store
//
//  Created by  黎明 on 16/7/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSEditDormAddressFooterView : UIView

@property (weak, nonatomic) IBOutlet HXSRoundedButton *commitButton;
@property (nonatomic, copy) void (^submitButtonClickBlock)();

@end
