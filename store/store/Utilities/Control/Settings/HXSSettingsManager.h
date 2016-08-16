//
//  HXSSettingsManager.h
//  store
//
//  Created by chsasaw on 14/10/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSSettingsManager : NSObject

+ (HXSSettingsManager *)sharedInstance;

- (int)getPayType;
- (NSString *)getPayTypeText;
- (void)setPayType:(int)type;

- (NSString *)getPhoneNum;
- (void)setPhoneNum:(NSString *)num;

- (NSString *)getRoomNum;
- (void)setRoomNum:(NSString *)num;

- (NSString *)getRemarks;
- (void)setRemarks:(NSString *)remarks;

/**
 *  返回云超市下单时的详细地址
 */
- (NSString *)storeDetailAddress;
/**
 *  设置云超市下单时的详细地址
 */
- (void)setStoreDetailAddress:(NSString *)detailAddress;

@end
