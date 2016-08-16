//
//  HXSBorrowPurposeItem.h
//  store
//
//  Created by hudezhi on 15/8/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBorrowPurposeItem : NSObject <NSCoding>

@property (nonatomic, strong) NSString *purposeCode;
@property (nonatomic, strong) NSString *purposeName;
@property (nonatomic, strong) NSString *purposeImageUrlStr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
