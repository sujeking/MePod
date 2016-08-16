//
//  HXSApplyResultInfoModel.m
//  store
//
//  Created by  黎明 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSApplyResultInfoModel.h"

@implementation HXSApplyResultInfoModel

+ (instancetype)initWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.boxerNameStr      = [dict valueForKey:@"boxer_name"];
        self.enrollmentYearNum = [dict valueForKey:@"enrollment_year"];
        self.genderNum         = [dict valueForKey:@"gender"];
        self.boxerMobileStr    = [dict valueForKey:@"boxer_mobile"];
        self.addressStr        = [dict valueForKey:@"address"];
        self.dormerMobileStr   = [dict valueForKey:@"dorm_mobile"];
        self.dormNameStr       = [dict valueForKey:@"dorm_name"];
    }
    
    return self;
}
@end
