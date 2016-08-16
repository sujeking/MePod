//
//  HXSUserAccountModel.m
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSUserAccountModel.h"

#import "HXSUserMyBoxInfo.h"
#import "HXSUserCreditcardInfoEntity.h"

#import "HXSBoxEntry.h"
#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSDormEntry.h"
#import "HXSBuildingEntry.h"
#import "HXStoreWebService.h"
#import "HXSUserKnightInfo.h"
#import "HXSUserBasicInfo.h"
#import "HXSUserFinanceInfo.h"
#import "HXMacrosUtils.h"


#define HXS_URL_CREDIT_CARD_WHOLE_INFO @"creditcard/whole/info"


@implementation HXSUserAccountModel

+ (void)getUserWholeInfo:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block
{
    NSDictionary *paramDic = @{};
    
    [HXStoreWebService getRequest:HXS_USER_WHOLE_INFO
                parameters:paramDic
                  progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       if (kHXSNoError != status) {
                           block(kHXSNoError, msg, nil);
                           
                           return ;
                       }
                       
                       NSMutableDictionary *userInfoMdic = [[NSMutableDictionary alloc] initWithCapacity:5];
                       
                       if (DIC_HAS_DIC(data, KEY_USER_INFO_KNIGHT)) {
                           NSDictionary *knightInfoDic = [data objectForKey:KEY_USER_INFO_KNIGHT];
                           HXSUserKnightInfo *info = [HXSUserKnightInfo createUserKnightInfoWithDic:knightInfoDic];
                           
                           [userInfoMdic setObject:info forKey:KEY_USER_INFO_KNIGHT];
                       }
                       
                       if (DIC_HAS_DIC(data, @"basic_info")) {
                           NSDictionary *basicInfoDic = [data objectForKey:@"basic_info"];
                           HXSUserBasicInfo * info = [[HXSUserBasicInfo alloc] initWithServerDic:basicInfoDic];
                           
                           [userInfoMdic setObject:info forKey:KEY_USER_INFO_BASIC];
                       }
                       
                       if (DIC_HAS_DIC(data, @"finance_info")) {
                           NSDictionary *financeInfoDic = [data objectForKey:@"finance_info"];
                           HXSUserFinanceInfo *info = [[HXSUserFinanceInfo alloc] initWithDictionary:financeInfoDic];
                           
                           [userInfoMdic setObject:info forKey:KEY_USER_INFO_FINANCE];
                       }
                       
                       if (DIC_HAS_DIC(data, @"my_box")) {
                           NSDictionary *myBoxDic = [data objectForKey:@"my_box"];
                           HXSUserMyBoxInfo *info = [HXSUserAccountModel setupMyBoxWithDic:myBoxDic];
                           
                           [userInfoMdic setObject:info forKey:KEY_USER_INFO_MY_BOX];
                       }
                       
                       block(status, msg, userInfoMdic);
                       
                   } failure:^(HXSErrorCode status, NSString *msg, NSDictionary * data) {
                       block(status, msg, nil);
                   }];
}

+ (void)getCreditCardInfo:(void (^)(HXSErrorCode code, NSString *message, HXSUserCreditcardInfoEntity *creditcardInfoEntity))block
{
    [HXStoreWebService getRequest:HXS_URL_CREDIT_CARD_WHOLE_INFO
                       parameters:nil
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  block(status, msg, nil);
                                  
                                  return ;
                              }
                              
                              HXSUserCreditcardInfoEntity *creditcardInfoEntity = [HXSUserCreditcardInfoEntity createEntityWithDictionary:data];
                              
                              block(status, msg, creditcardInfoEntity);
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              block(status, msg, nil);
                          }];
}

+ (void)userSignIn:(void (^)(HXSErrorCode code, NSString *message, NSDictionary *info))block{
    
    NSMutableDictionary *dic =  [NSMutableDictionary dictionary];
    [HXStoreWebService postRequest:HXS_USER_SIGN_IN
                parameters:dic
                   progress:nil
                   success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                       block(status,msg,data);
        
    } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
        block(status,msg,data);
    } ];
}


#pragma mark - 

+ (HXSUserMyBoxInfo *)setupMyBoxWithDic:(NSDictionary *)info
{
    HXSBoxEntry *boxEntry;
    HXSCity *cityEntry;
    HXSSite *siteEntry;
    HXSBuildingEntry *buildingEntry = [[HXSBuildingEntry alloc] init];
    HXSDormEntry *dormentry;
    HXSApplyBoxInfo *applyInfo;
    
    if (DIC_HAS_DIC(info, @"box")) {
        boxEntry = [[HXSBoxEntry alloc] initWithDictionary:[info objectForKey:@"box"]];
    }
    if (DIC_HAS_DIC(info, @"building")) {
        NSDictionary *building = [info objectForKey:@"building"];
        
        if (DIC_HAS_STRING(building, @"building_name")) {
            buildingEntry.buildingNameStr = [building objectForKey:@"building_name"];
        }
        if (DIC_HAS_NUMBER(building, @"dormentry_id")) {
            buildingEntry.dormentryIDNum = [building objectForKey:@"dormentry_id"];
        }
    }
    if (DIC_HAS_DIC(info, @"city")) {
        cityEntry = [[HXSCity alloc] initWithDictionary:[info objectForKey:@"city"]];
    }
    if (DIC_HAS_DIC(info, @"shop")) {
        NSDictionary *shopDic = [info objectForKey:@"shop"];
        
        HXSShopEntity *entity = [[HXSShopEntity alloc] init];
        
        if (DIC_HAS_NUMBER(shopDic, @"shop_id")) {
            entity.shopIDIntNum = [shopDic objectForKey:@"shop_id"];
        }
        
        if (DIC_HAS_STRING(shopDic, @"address")) {
            entity.addressStr = [shopDic objectForKey:@"address"]; // 1号楼 3层
        }
        
        if (DIC_HAS_STRING(shopDic, @"shop_address")) {
            entity.shopAddressStr = [shopDic objectForKey:@"shop_address"]; // "3层"
        }
        
        if (DIC_HAS_NUMBER(shopDic, @"status")) {
            entity.statusIntNum = [shopDic objectForKey:@"status"];  // 0表示关闭，1表示正常营业，2表示未开通
        }
        
        dormentry = [[HXSDormEntry alloc] initWithShopEntity:entity];
    }
    if (DIC_HAS_STRING(info, @"groups_name")) {
        NSString *grounsName = [info objectForKey:@"groups_name"];
        buildingEntry.nameStr = grounsName;
    }
    if (DIC_HAS_DIC(info, @"site")) {
        siteEntry = [[HXSSite alloc] initWithDictionary:[info objectForKey:@"site"]];
    }
    
    if (DIC_HAS_DIC(info, @"apply_box")) {
        applyInfo = [[HXSApplyBoxInfo alloc] initWithDictionary:[info objectForKey:@"apply_box"]];
    }
    
    HXSUserMyBoxInfo *myBoxInfo = [[HXSUserMyBoxInfo alloc] init];
    
    myBoxInfo.boxEntry = boxEntry;
    myBoxInfo.cityEntry = cityEntry;
    myBoxInfo.siteEntry = siteEntry;
    myBoxInfo.buildingEntry = buildingEntry;
    myBoxInfo.dormEntry = dormentry;
    myBoxInfo.applyInfo = applyInfo;
    
    return myBoxInfo;
}



@end
