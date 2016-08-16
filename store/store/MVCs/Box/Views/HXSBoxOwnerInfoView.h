//
//  HXSBoxOwnerInfoView.h
//  store
//
//  Created by  黎明 on 16/6/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXSBoxInfoEntity;

/**
 *  盒主信息View
 */

@interface HXSBoxOwnerInfoView : UIView

+ (HXSBoxOwnerInfoView *)initFromXib;

- (void)initialBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity;

@end
