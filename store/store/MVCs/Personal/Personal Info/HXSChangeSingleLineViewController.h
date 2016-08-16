//
//  HXSChangeNicknameViewController.h
//  store
//
//  Created by ranliang on 15/7/21.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

typedef NS_ENUM(NSUInteger, HXSModifyAccountInfoType ) {
    HXSModifyAccountInfoNickname = 0,
    HXSModifyAccountInfoUsername,
    HXSModifyAccountInfoCellNumber,
};

@interface HXSChangeSingleLineViewController : HXSBaseViewController

@property (nonatomic, assign) HXSModifyAccountInfoType type;

/* the text in the only textField */
@property (nonatomic, copy) NSString *text;

@end
