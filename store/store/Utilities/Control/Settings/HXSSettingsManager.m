//
//  HXSSettingsManager.m
//  store
//
//  Created by chsasaw on 14/10/21.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSettingsManager.h"

#import "HXSShopManager.h"

static HXSSettingsManager *settingsManagerSharedInstance = nil;

@implementation HXSSettingsManager

+ (HXSSettingsManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingsManagerSharedInstance = [[self alloc]init];
    });
    return settingsManagerSharedInstance;
}

- (int)getPayType {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"dorm_pay_type"] intValue];
}

- (NSString *)getPayTypeText
{
    return [NSString payTypeStringWithPayType:[self getPayType]];
}

- (void)setPayType:(int)type {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:type] forKey:@"dorm_pay_type"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getPhoneNum {
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    NSString *phoneNumKey = [NSString stringWithFormat:@"dorm_user_phone_%d", shopManager.currentEntry.shopEntity.shopIDIntNum.intValue];
    NSString * phone = [[NSUserDefaults standardUserDefaults] objectForKey:phoneNumKey];
    if(!phone || phone.length == 0) {
        phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"dorm_user_phone"];
        
        return phone;
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:phoneNumKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return phone;
}

- (void)setPhoneNum:(NSString *)num {
    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"dorm_user_phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getRoomNum
{
    HXSShopManager *shopManager = [HXSShopManager shareManager];
    NSString *roomKey = [NSString stringWithFormat:@"dorm_user_room_%d", shopManager.currentEntry.shopEntity.shopIDIntNum.intValue];
    NSString * room = [[NSUserDefaults standardUserDefaults] objectForKey:roomKey];
    if(!room || room.length == 0) {
        room = [[NSUserDefaults standardUserDefaults] objectForKey:@"dorm_user_room"];
        
        return room;
    }
    else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:roomKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return room;
}

- (void)setRoomNum:(NSString *)num {
    [[NSUserDefaults standardUserDefaults] setObject:num forKey:@"dorm_user_room"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setRemarks:(NSString *)remarks {
    [[NSUserDefaults standardUserDefaults] setObject:remarks forKey:@"dorm_user_remark"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getRemarks {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"dorm_user_remark"];
}

- (void)setStoreDetailAddress:(NSString *)detailAddress {
    [[NSUserDefaults standardUserDefaults] setObject:detailAddress forKey:@"store_detail_adddress"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)storeDetailAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"store_detail_adddress"];
}

@end
