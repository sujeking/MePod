//
//  HXSApplyResultInfoModel.h
//  store
//
//  Created by  黎明 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSApplyResultInfoModel : NSObject

/** 盒主名字【申请人】 */
@property (nonatomic, strong) NSString *boxerNameStr;
/** 申请日期 */
@property (nonatomic, strong) NSNumber *enrollmentYearNum;
/**  0:男,1:女 */
@property (nonatomic, strong) NSNumber *genderNum;
/** 盒主手机号 */
@property (nonatomic, strong) NSString *boxerMobileStr;
/** 供应店长 */
@property (nonatomic, strong) NSString *dormNameStr;
/** 地址 */
@property (nonatomic, strong) NSString *addressStr;
/** 店长手机号 */
@property (nonatomic, strong) NSString *dormerMobileStr;

+ (instancetype)initWithDict:(NSDictionary *)dict;

@end
