//
//  HXSBankCardItem.h
//  store
//
//  Created by hudezhi on 15/8/5.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBankCardItem : NSObject<NSCoding>

@property(nonatomic) NSString *cardNum;
@property(nonatomic) NSString *bankName;
@property(nonatomic) NSString *bankCode;
@property(nonatomic) NSString *bankLogo;
@property(nonatomic) NSString *boundPhone;
@property(nonatomic, assign) BOOL isBindingByJiufu;

- (instancetype)initWithDictionary:(NSDictionary *)response;

@end
