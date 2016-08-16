//
//  HXSMyLoanBankListModel.m
//  59dorm
//
//  Created by J006 on 16/7/21.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSMyLoanBankListModel.h"

@implementation HXSMyLoanBankModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mappingBankModel= [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"bankCode",  @"code",
                                     @"bankName",  @"name",
                                     @"bankImage", @"image",nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mappingBankModel];
}

@end

@implementation HXSMyLoanBankListModel

+ (JSONKeyMapper *)keyMapper
{
    NSDictionary *mapping= [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"bankListArray",  @"list", nil];
    
    return [[JSONKeyMapper alloc] initWithDictionary:mapping];
}

@end
