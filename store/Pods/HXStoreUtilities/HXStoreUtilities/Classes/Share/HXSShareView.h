//
//  HXSShareView.h
//  store
//
//  Created by ArthurWang on 16/3/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXMacrosEnum.h"

typedef NS_ENUM(NSUInteger, HXSShareType) {
    kHXSShareTypeWechatFriends = 0,
    kHXSShareTypeWechatMoments = 1,
    kHXSShareTypeSina          = 2,
    kHXSShareTypeMessage       = 3,   // Do nothing
    kHXSShareTypeQQMoments     = 4,
    kHXSShareTypeQQFriends     = 5,
    kHXSShareTypeCopyLink      = 6
};

/**
 *  入参的类
 */
@interface HXSShareParameter : NSObject

@property (nonatomic, strong) NSArray *shareTypeArr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *textStr;
@property (nonatomic, strong) NSString *imageURLStr;
@property (nonatomic, strong) NSString *shareURLStr;

@end


typedef void (^HXSShareCallbackBlock)(HXSShareResult shareResult, NSString * msg);

/**
 * 分享的界面
 */
@interface HXSShareView : UIView

@property (nonatomic, strong) HXSShareParameter *shareParameter;
@property (nonatomic, copy) HXSShareCallbackBlock shareCallBack;

- (instancetype)initShareViewWithParameter:(HXSShareParameter *)shareParameter callBack:(HXSShareCallbackBlock)callBack;

- (void)show;
- (void)close;

@end
