//
//  HXSShareToWechatActionView.h
//  store
//
//  Created by ArthurWang on 15/9/18.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HXSShareToWechatActionView : UIView

- (instancetype)initShareToWechatView:(void (^)(BOOL success, BOOL timeline))finished;

- (void)start;
- (void)end;

@end
