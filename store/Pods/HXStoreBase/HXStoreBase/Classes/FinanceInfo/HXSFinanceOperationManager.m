//
//  HXSFinanceOperationManager.m
//  store
//
//  Created by hudezhi on 15/7/30.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSFinanceOperationManager.h"

#import "ApplicationSettings.h"

static HXSFinanceOperationManager * finance_operation_mgr = nil;

static NSString *FinanceOperationBorrowInfoKey = @"FinanceOperationBorrowInfo";
static NSString *FinanceOperationTypeKey = @"FinanceOperationBorrowType";

@implementation HXSFinanceOperationManager

+ (HXSFinanceOperationManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (finance_operation_mgr == nil) {
            finance_operation_mgr = [[ApplicationSettings instance] financeOperationManager];
            if (finance_operation_mgr == nil) {
                finance_operation_mgr = [[HXSFinanceOperationManager alloc] init];
            }
        }
    });
    return finance_operation_mgr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.borrowInfo = [[HXSBorrowSubmitInfo alloc] init];
    }
    
    return self;
}

- (void)save
{
    [[ApplicationSettings instance] setFinanceOperationManager:self];
}

- (void)clearBorrowInfo
{
    [[ApplicationSettings instance] clearFinanceOperationManager];
    self.borrowInfo = [[HXSBorrowSubmitInfo alloc] init]; // 重新alloc一个空的
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_borrowInfo forKey:FinanceOperationBorrowInfoKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.borrowInfo = [aDecoder decodeObjectForKey:FinanceOperationBorrowInfoKey];
    }
    
    return self;
}

@end
