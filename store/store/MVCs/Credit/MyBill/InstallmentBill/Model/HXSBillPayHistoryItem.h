//
//  HXSBillPayHistoryItem.h
//  store
//
//  Created by hudezhi on 15/8/18.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSBillPayHistoryItem : NSObject

@property (nonatomic) NSString *billDate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
