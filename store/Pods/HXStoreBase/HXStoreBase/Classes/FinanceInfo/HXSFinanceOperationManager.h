//
//  HXSFinanceOperationManager.h
//  store
//
//  Created by hudezhi on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSBorrowSubmitInfo.h"

@interface HXSFinanceOperationManager : NSObject <NSCoding>

+ (HXSFinanceOperationManager *)sharedManager;

- (void)save;
- (void)clearBorrowInfo;

@property (nonatomic, strong) HXSBorrowSubmitInfo *borrowInfo; // post when operationType is 'HXSFinanceOperation59Borrow'

@property (nonatomic, strong) NSString *borrowSerialNum;    // 59借交易流水号

@end
