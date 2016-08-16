//
//  HXSBusinessLoanViewModel.m
//  59dorm
//
//  Created by J006 on 16/7/19.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import "HXSBusinessLoanViewModel.h"

static NSString * const kLoanFetchInfor      = @"creditcard/info";// 查询查询信用钱包额度、用户基础信息接口
static NSString * const kLoanOpen            = @"creditcard/apply/open";// 金融开通接口
static NSString * const kLoanAddIdentify     = @"creditcard/add/identity/info" ;// 身份信息校验接口
static NSString * const kLoanAddSchool       = @"creditcard/add/school/roll"   ;// 学籍信息校验接口
static NSString * const kLoanVeritycode      = @"creditcard/bank_card/verify_code/send";// 发送手机验证码
static NSString * const kLoanAddBank         = @"creditcard/bank_card/update" ;// 银行信息校验接口
static NSString * const kLoanFetchBanklist   = @"creditcard/bank_list";// 银行列表
static NSString * const kLoanAccountUpdate   = @"creditcard/account/pay_password/update";// 设置或者修改密码
static NSString * const kLoanPhotoUpload     = @"creditcard/upload/picture";// 设置或者修改密码
static NSString * const kLoanAuthorizeNext   = @"creditcard/authorize/next"   ;// 授权完成后，进入学籍校验接口
static NSString * const kLoanAddPositionInfo = @"creditcard/add/position/info" ;// 定位授权
static NSString * const kLoanAddContactsInfo = @"creditcard/add/contacts/info";// 通讯录授权
static NSString * const kLoanPhotoUploadIos  = @"creditcard/upload/picture/ios";// 照片上传iOS

@interface HXSBusinessLoanViewModel()

@property (nonatomic, strong) HXSMyLoanBankListModel     *myLoanBankListModel;

@end

@implementation HXSBusinessLoanViewModel

+ (instancetype)sharedManager
{
    static HXSBusinessLoanViewModel *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

- (void)openMyLoanComplete:(void (^)(HXSErrorCode code, NSString *message, BOOL isOpen))block
{
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    NSDictionary *paramsDic = @{
                                @"type": @1,
                                @"sdk_str": manager->getDeviceInfo(),
                                };
    
    [HXStoreWebService postRequest:kLoanOpen
                        parameters:paramsDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status,msg,NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)addIdentifyInforWithParamModel:(HXSSubscribeIDParamModel *)model
                              Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;
{
    NSDictionary *parameterDic = @{
                                   @"name":                     model.nameStr,
                                   @"id_card_no":               model.idCardNoStr,
                                   @"email":                    model.emailStr,
                                   };
    
    [HXStoreWebService postRequest:kLoanAddIdentify
                        parameters:parameterDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status, msg, NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)fetchVerifyCodeWithPhone:(NSString *)phoneStr
                        Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *parameterDic = @{
                                   @"phone":                     phoneStr,
                                   };
    
    [HXStoreWebService getRequest:kLoanVeritycode
                       parameters:parameterDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status)
                              {
                                  block(kHXSNoError, msg, YES);
                              }
                              else
                              {
                                  block(status,msg,NO);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                            block(status, msg, NO);
                          }];
}

- (void)addSchoolIdentifyWithParamModel:(HXSSubscribeStudentParamModel *)model
                               Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *parameterDic = @{
                                   @"site_name":                        model.siteNameStr,
                                   @"entrance_year":                    model.entranceYearStr,
                                   @"edu_degree":                       model.eduDegreeNum,
                                   @"major_name":                       model.majorNameStr,
                                   @"dorm_address":                     model.dormAddressStr,
                                   @"type":                             @1,
                                   };
    
    
    [HXStoreWebService postRequest:kLoanAddSchool
                        parameters:parameterDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status,msg,NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)addBankIdentifyWithParamModel:(HXSSubscribeBankParamModel *)model
                             Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *parameterDic = @{
                                   @"bank_name":                        model.bankNameStr,
                                   @"bank_code":                        model.bankCodeStr,
                                   @"card_no":                          model.cardNoStr,
                                   @"telephone":                        model.telephoneStr,
                                   @"verify_code":                      model.verifyCodeStr,
                                   @"type":                             @1,                     // 1用户端，2店长端
                                   };
    
    [HXStoreWebService postRequest:kLoanAddBank
                        parameters:parameterDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status,msg,NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];

}

- (void)fetchBankListComplete:(void (^)(HXSErrorCode code, NSString *message, HXSMyLoanBankListModel *model))block;
{
    [HXStoreWebService getRequest:kLoanFetchBanklist
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status)
                              {
                                  HXSMyLoanBankListModel *model;
                                  if([data isKindOfClass:[NSDictionary class]])
                                  {
                                      model = [self createMyLoanBankListModelWithData:data];
                                      _myLoanBankListModel = model;
                                  }
                                  block(kHXSNoError, msg, model);
                              }
                              else
                              {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)settingThePasswordForWalletWithOldPassword:(NSString *)oldPasswordStr
                                    andNewPassword:(NSString *)newPasswordStr
                                          Complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *parameterDic;
    
    if(oldPasswordStr)
    {
        parameterDic = @{
                         @"old_password":                        oldPasswordStr,
                         @"new_password":                        newPasswordStr
                         };
    }
    else
    {
        parameterDic = @{
                         @"new_password":                        newPasswordStr
                         };
    }
    
    
    [HXStoreWebService postRequest:kLoanAccountUpdate
                        parameters:parameterDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status,msg,NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)uploadThePhotoWithParam:(HXSUploadPhotoParamModel *)paramModel
                       Complete:(void (^)(HXSErrorCode code, NSString *message, NSString *urlStr))block
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSMutableArray *formDataArray = [[NSMutableArray alloc]init];
    NSData *data = UIImageJPEGRepresentation(paramModel.image,1.0);
    NSString *imageNameStr = [self createCameraImageNameByDate];
    [formDataArray addObject:data];
    [formDataArray addObject:imageNameStr];
    [formDataArray addObject:[NSString stringWithFormat:@"%@.jpg",imageNameStr]];
    [formDataArray addObject:@"image/jpg"];
    
    
    [paramDict setValue:paramModel.uploadTypeNum forKey:@"type"];
    [paramDict setValue:paramModel.statusNum forKey:@"status"];
    
    [HXStoreWebService uploadRequest:kLoanPhotoUploadIos
                          parameters:paramDict
                       formDataArray:formDataArray
                            progress:nil
                             success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                                 if (kHXSNoError == status)
                                 {
                                     if([data isKindOfClass:[NSDictionary class]])
                                     {
                                         NSString *urlStr = [data objectForKey:@"url"];
                                         block(status, msg, urlStr);
                                     }
                                 }
                                 else
                                 {
                                     block(status,msg,nil);
                                 }
                             } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                                 block(status,msg,nil);
                             }];

}

- (void)fetchAuthStatusComplete:(void (^)(HXSErrorCode code, NSString *message, HXSUpgradeAuthStatusEntity *model))block
{
    [HXStoreWebService getRequest:kLoanFetchBanklist
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status)
                              {
                                  HXSUpgradeAuthStatusEntity *model;
                                  if([data isKindOfClass:[NSDictionary class]])
                                  {
                                      model = [HXSUpgradeAuthStatusEntity createEntityWithDictionary:data];
                                  }
                                  block(kHXSNoError, msg, model);
                              }
                              else
                              {
                                  block(status,msg,nil);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

- (void)finishAuthorzieComplete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSDictionary *paramsDic = @{
                                @"type":@1, // 1.用户端;2.店长端
                                };
    
    [HXStoreWebService postRequest:kLoanAuthorizeNext
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError == status)
                              {
                                  block(kHXSNoError, msg, YES);
                              }
                              else
                              {
                                  block(status,msg,NO);
                              }
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, NO);
                          }];
}

- (void)uploadLocationInfoWithLatitude:(double)latitude longitude:(double)longitude complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block
{
    NSString *versionStr = [[HXAppConfig sharedInstance] appVersion];
    NSDictionary *positionInfoDic = @{
                                @"auth_position":@{
                                        @"latitude":[NSNumber numberWithDouble:latitude],
                                        @"longitude":[NSNumber numberWithDouble:longitude],
                                        },
                                @"auth_setup":@{
                                        @"platform":@"iOS",
                                        @"version":versionStr,
                                        @"uuid" : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                        },
                                };
    NSData *positionData = [NSJSONSerialization dataWithJSONObject:positionInfoDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
    NSString *positionStr = [[NSString alloc] initWithData:positionData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *paramsDic = @{
                                @"position_info": positionStr,
                                };
    
    [HXStoreWebService postRequest:kLoanAddPositionInfo
                        parameters:paramsDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status, msg, NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (void)uploadContactsInfo:(NSString *)contactsStr complete:(void (^)(HXSErrorCode code, NSString *message, BOOL isSuccess))block;
{
    NSDictionary *paramsDic = @{
                                @"contacts_info": contactsStr,
                                };
    
    [HXStoreWebService postRequest:kLoanAddContactsInfo
                        parameters:paramsDic
                          progress:nil
                           success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               if (kHXSNoError == status)
                               {
                                   block(kHXSNoError, msg, YES);
                               }
                               else
                               {
                                   block(status, msg, NO);
                               }
                           } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                               block(status, msg, NO);
                           }];
}

- (NSData *)checkTheImage:(UIImage *)image
        andScaleToTheSize:(CGFloat)sizeM
{
    if(!image || sizeM == 0.0)
        return nil;
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    CGFloat scale     = sizeM/(imageData.length/1024.0);
    NSData *newData   = UIImageJPEGRepresentation(image, scale);
    return newData;
}

- (HXSMyLoanBankListModel *)getMyLoanBankListModel
{
    return _myLoanBankListModel;
}

#pragma mark private methods

- (NSString *)createCameraImageNameByDate
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *newStr = [NSString stringWithFormat:@"%f",currentTime];
    
    return newStr;
}

- (HXSMyLoanBankListModel *)createMyLoanBankListModelWithData:(NSDictionary *)dic
{
    HXSMyLoanBankListModel *model = [[HXSMyLoanBankListModel alloc] initWithDictionary:dic error:nil];
    
    return model;
}


@end
