//
//  HXSActionSheet.h
//  Test
//
//  Created by hudezhi on 15/11/25.
//  Copyright © 2015年 59store. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSActionSheetModel.h"
#import "HXSActionSheetEntity.h"

@class HXSAction;

typedef void (^HXSActionHandler)(HXSAction* action);

@interface HXSAction : NSObject

// image, handler: nullable
+ (instancetype)actionWithMethods:(HXSActionSheetEntity *)methodsEntity handler: (HXSActionHandler)handler;

@end


@interface HXSActionSheet : UIView

// message, cancelTitle: nullable
+ (instancetype)actionSheetWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;
- (void)addAction:(HXSAction *)action;
- (void)show;

@end
