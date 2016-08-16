//
//  HXSApplyInfoEntity.h
//  store
//
//  Created by  黎明 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSApplyInfoEntity : NSObject

//申请人姓名
@property (nonatomic, strong) NSString *applyUserNameStr;
//申请人性别
@property (nonatomic, strong) NSNumber *applyUserGenderNum;
//申请人入学时间
@property (nonatomic, strong) NSString *applyUserAdmissionDateStr;
//申请人手机号
@property (nonatomic, strong) NSString *applyUserMobileStr;
//楼栋ID
@property (nonatomic, strong) NSNumber *applyUserDormentryIdNum;
//宿舍号
@property (nonatomic, strong) NSString *applyUserRoomStr;
//申请人宿舍地址
@property (nonatomic, strong) NSString *applyUserDormAddressStr;
// 店长ID
@property (nonatomic, strong) NSNumber *applyUserdormIdNum;

@end
