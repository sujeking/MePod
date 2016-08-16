//
//  HXSAlipayManager.h
//  store
//
//  Created by chsasaw on 15/4/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HXSOrderInfo;

@protocol HXSAlipayDelegate <NSObject>

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result;

@end

@interface HXSAlipayManager : NSObject

@property (nonatomic, weak) id<HXSAlipayDelegate> delegate;

+ (HXSAlipayManager *) sharedManager;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)pay:(HXSOrderInfo *)orderInfo delegate:(id<HXSAlipayDelegate>)delegate;

@end
