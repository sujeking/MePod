//
//  HXSBorrowMonthlyMortgageResponse.m
//  store
//
//  Created by hudezhi on 15/8/3.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowMonthlyMortgageInfo.h"

#import "HXMacrosUtils.h"

static NSString *InstallmentMonthlyMortgageAmountKey = @"installment_amount";
static NSString *InstallmentMonthlyMortgageNumberKey = @"installment_num";

static NSString *InstallmentMArrKey = @"installmentMArr";

@implementation HXSInstallmentSelectEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.installmentNum = [dictionary objectForKey:InstallmentMonthlyMortgageNumberKey];
        self.installmentAmountNum = [dictionary objectForKey:InstallmentMonthlyMortgageAmountKey];
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.installmentAmountNum forKey:InstallmentMonthlyMortgageAmountKey];
    [aCoder encodeObject:self.installmentNum forKey:InstallmentMonthlyMortgageNumberKey];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.installmentAmountNum = [aDecoder decodeObjectForKey:InstallmentMonthlyMortgageAmountKey];
        self.installmentNum = [aDecoder decodeObjectForKey:InstallmentMonthlyMortgageNumberKey];
    }
    
    return self;
}

@end

@implementation HXSBorrowMonthlyMortgageInfo

- (instancetype)initWithDictionary:(NSDictionary *)response
{
    self = [super init];
    if(self) {
        if (DIC_HAS_ARRAY(response, @"installment")) {
            NSMutableArray *installmentMArr = [[NSMutableArray alloc] init];
            NSArray *installmentArray = [response objectForKey:@"installment"];
            for (NSDictionary *installmentDict in installmentArray) {
                HXSInstallmentSelectEntity *installmentEntity = [[HXSInstallmentSelectEntity alloc] initWithDictionary:installmentDict];
                [installmentMArr addObject:installmentEntity];
            }
            
            self.installmentMArr = installmentMArr;
        }
    }
    
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.installmentMArr forKey:InstallmentMArrKey];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.installmentMArr = [aDecoder decodeObjectForKey:InstallmentMArrKey];
    
    }
    
    return self;
}



@end
