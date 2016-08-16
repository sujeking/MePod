//
//  HXSMyLoanBankListModel.h
//  59dorm
//
//  Created by J006 on 16/7/21.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXSMyLoanBankModel
@end

@interface HXSMyLoanBankModel : HXBaseJSONModel

@property (nonatomic ,strong) NSString *bankName;
@property (nonatomic ,strong) NSString *bankCode;
@property (nonatomic ,strong) NSString *bankImage;

@end

@interface HXSMyLoanBankListModel : HXBaseJSONModel

@property (nonatomic ,strong) NSArray<HXSMyLoanBankModel> *bankListArray;

@end
