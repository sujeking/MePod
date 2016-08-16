//
//  HXSMyLoanParamModel.h
//  59dorm
//
//  Created by J006 on 16/7/22.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSSubscribeBankParamModel : NSObject

/**银行名称 */
@property (nonatomic, strong) NSString *bankNameStr;
/**银行编码 */
@property (nonatomic, strong) NSString *bankCodeStr;
/**银行卡号 */
@property (nonatomic, strong) NSString *cardNoStr;
/**预留手机号码 */
@property (nonatomic, strong) NSString *telephoneStr;
/**验证码 */
@property (nonatomic, strong) NSString *verifyCodeStr;

@end

@interface HXSSubscribeStudentParamModel : NSObject

/** 学校名称 */
@property (nonatomic, strong) NSString *siteNameStr;
/** 入学年份 */
@property (nonatomic, strong) NSString *entranceYearStr;
/** 学历层次  "1", "博士"；"2", "硕士"；"3", "本科"；"4", "专科"；*/
@property (nonatomic, strong) NSNumber *eduDegreeNum;
/** 专业名称 */
@property (nonatomic, strong) NSString *majorNameStr;
/** 宿舍地址 */
@property (nonatomic, strong) NSString *dormAddressStr;

@end

@interface HXSSubscribeIDParamModel : NSObject

/** 姓名 */
@property (nonatomic, strong) NSString *nameStr;
/** 身份证号码 */
@property (nonatomic, strong) NSString *idCardNoStr;
/** 邮箱地址 */
@property (nonatomic, strong) NSString *emailStr;
/** 邀请码 */
@property (nonatomic, strong) NSString *invitationCodeStr;

@end

@interface HXSUploadPhotoParamModel : NSObject

/**type 1.正面;2.背面;3.手持;4.学生证/一卡通正面;5.学生证/一卡通背面;6.校园经理合照 */
@property (nonatomic, strong) NSNumber *uploadTypeNum;
/**picture 图片本身 类型->MultipartFile */
@property (nonatomic, strong) UIImage  *image;
/**status: 1.用户端;2.店长端  int */
@property (nonatomic, strong) NSNumber *statusNum;
@end

/**
 *  学籍信息上传图片
 */
@interface HXSMySubscribeStudentPhotoParamModel : NSObject

/**id card 正面URL */
@property (nonatomic, strong) NSString *urlIdCardFrontStr;
/**id card 反面URL */
@property (nonatomic, strong) NSString *urlIdCardBackStr;
/**入学缴费照片URL */
@property (nonatomic, strong) NSString *urlnoticeStr;

@end

@interface HXSMyLoanParamModel : NSObject

@end
