//
//  HXSBestPayApiManager.h
//  store
//
//  Created by ArthurWang on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSOrderInfo.h"

typedef NS_ENUM(NSInteger, HXSBestPayStatus){
    kHXSBestPayStatusSuccess = 0,
    kHXSBestPayStatusFailed  = 1,
    kHXSBestPayStatusExit    = 2,
};

@protocol HXSBestPayApiManagerDelegate <NSObject>

@required
- (void)bestPayCallBack:(HXSBestPayStatus)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface HXSBestPayApiManager : NSObject

+ (instancetype)sharedManager;

- (void)bestPayWithOrderInfo:(HXSOrderInfo *)orderInfo
                        from:(UIViewController *)fromViewController
                    delegate:(id<HXSBestPayApiManagerDelegate>)bestPayDelegate;

- (BOOL)handleOpenURL:(NSURL *)url;

@end
