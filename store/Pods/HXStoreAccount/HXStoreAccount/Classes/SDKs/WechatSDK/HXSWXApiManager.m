//
//  HXSWXApiManager.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSWXApiManager.h"

#import "WXApi.h"
#import "HXSUserAccount.h"
#import "HXStoreWebService.h"
#import "HXSOrderInfo.h"
#import "ApplicationSettings.h"

static HXSWXApiManager * wx_instance = nil;


#define HXS_WXPAY_PREPAY_ID           @"pay/wxpay/prepay_id"     // 获取预支付订单id

// 账号帐户资料
//wechat
#define kWeixinAppId     @"wx61b107d5dc55114c"
#define kWeixinAppSecret @"0246152cee5409123eac125be1657efb"


@interface HXSWXApiManager ()

@property (nonatomic, strong) HXSOrderInfo *orderInfo;


@end

@implementation HXSWXApiManager

+ (HXSWXApiManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (wx_instance == nil) wx_instance = [[HXSWXApiManager alloc] init];
    });
    return wx_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        [WXApi registerApp:kWeixinAppId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *wechatInfo = [defaults objectForKey:@"WXAuthData"];
        if ([wechatInfo objectForKey:@"AccessTokenKey"] && [wechatInfo objectForKey:@"ExpirationDateKey"] && [wechatInfo objectForKey:@"UserIDKey"] && [wechatInfo objectForKey:@"RefreshToken"])
        {
            self.accessToken = [wechatInfo objectForKey:@"AccessTokenKey"];
            self.expirationDate = [wechatInfo objectForKey:@"ExpirationDateKey"];
            self.userID = [wechatInfo objectForKey:@"UserIDKey"];
            self.refresh_token = [wechatInfo objectForKey:@"RefreshToken"];
        }
    }
    
    return self;
}

- (BOOL)isWechatInstalled {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.accessToken, @"AccessTokenKey",
                              self.expirationDate, @"ExpirationDateKey",
                              self.userID, @"UserIDKey",
                              self.refresh_token, @"RefreshToken", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"WXAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WXAuthData"];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)isLoggedIn {
    return self.accessToken != nil;
}

- (void)logIn {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)logOut {
    [self removeAuthData];
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
}

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine callback:(HXSShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"59store夜猫店";
    message.description = @"5分钟送货上床的便利店,充饥、解渴、解馋一网打尽！试试看吧~";
    [message setThumbImage:[UIImage imageNamed:@"share_icon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = isTimeLine ? @"http://www.59store.com/share?hxfrom=timeline":@"http://www.59store.com/share?hxfrom=weixin";
    if([HXSUserAccount currentAccount].userID != nil) {
        url = [url stringByAppendingFormat:@"&uid=%@", [HXSUserAccount currentAccount].userID];
    }
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
}

- (void)shareToWeixinWithTitle:(NSString *)title text:(NSString *)text image:(UIImage *)image url:(NSString *)url timeLine:(BOOL)isTimeLine callback:(HXSShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title?title:@"";
    message.description = text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    // Do nothing
}

- (void)onResp:(BaseResp *)resp
{
    NSString *strMsg;
    HXSShareResult result;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
                
            case WXSuccess:
            {
                strMsg = @"分享成功！";
                result = kHXSShareResultOk;
            }
                break;
            case WXErrCodeCommon:
            {
                strMsg = @"分享失败！";
                result = kHXSShareResultFailed;
            }
                break;
            case WXErrCodeUserCancel:
            {
                strMsg = @"分享取消！";
                result = kHXSShareResultCancel;
            }
                
                break;
            default:
                strMsg = [NSString stringWithFormat:@"分享失败！"];
                result = kHXSShareResultFailed;
                break;
        }
        
        if (self.shareCallBack) {
            self.shareCallBack(result, strMsg);
            
            self.shareCallBack = nil;
        }
        
        return;
    }
    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        NSString * code = ((SendAuthResp *) resp).code;
        if(code) {
            [self getAuthInfo:code];
        }else {
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
                [self.delegate thirdAccountLoginFailed:kHXSWeixinAccount];
            }
        }
        
        return;
    }
    
    //启动微信支付的response
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                strMsg = @"支付结果：成功！";
                break;
            case -1:
                strMsg = @"支付结果：失败！";
                break;
            case -2:
                strMsg = @"用户已经退出支付！";
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
        
        if (self.wechatPayDelegate
            && [self.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
            [self.wechatPayDelegate wechatPayCallBack:resp.errCode
                                              message:strMsg
                                               result:nil];
            
            self.wechatPayDelegate = nil;
        }
        
        return;
    }
}

- (void)getAuthInfo:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWeixinAppId, kWeixinAppSecret, code];
    
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           NSDictionary * wechatInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                           if ([wechatInfo objectForKey:@"access_token"] && [wechatInfo objectForKey:@"expires_in"] && [wechatInfo objectForKey:@"openid"] && [wechatInfo objectForKey:@"refresh_token"])
                                                           {
                                                               weakSelf.accessToken = [wechatInfo objectForKey:@"access_token"];
                                                               weakSelf.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[wechatInfo objectForKey:@"expires_in"] integerValue]];
                                                               weakSelf.userID = [wechatInfo objectForKey:@"openid"];
                                                               weakSelf.refresh_token = [wechatInfo objectForKey:@"refresh_token"];
                                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                                   [weakSelf storeAuthData];
                                                                   if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(thirdAccountDidLogin:)]) {
                                                                       [weakSelf.delegate thirdAccountDidLogin:kHXSWeixinAccount];
                                                                   }
                                                               });
                                                               
                                                           }else {
                                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                                   if(weakSelf.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
                                                                       [weakSelf.delegate thirdAccountLoginFailed:kHXSWeixinAccount];
                                                                   }
                                                               });
                                                               
                                                           }
                                                       }];
    
    [task resume];
    
}


#pragma mark - Box Order Share Methods

- (void)shareAppToWeixinFriends:(BOOL)isTimeLine
               withActivityInfo:(HXSOrderActivitInfo *)activityInfo
                          image:(UIImage *)image
                       callback:(HXSShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = activityInfo.title;
    message.description = activityInfo.text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = activityInfo.url;
    if([HXSUserAccount currentAccount].userID != nil) {
        url = [url stringByAppendingFormat:@"&uid=%@", [HXSUserAccount currentAccount].userID];
    }
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)shareAppToWeixin:(BOOL)isTimeLine withActivityInfo:(HXSOrderActivitInfo *)activityInfo image:(UIImage *)image callback:(HXSShareCallbackBlock)callback {
    self.shareCallBack = callback;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = activityInfo.title;
    message.description = activityInfo.text;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString * url = activityInfo.url;
    if([HXSUserAccount currentAccount].userID != nil) {
        url = [url stringByAppendingFormat:@"&uid=%@", [HXSUserAccount currentAccount].userID];
    }
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isTimeLine ? WXSceneTimeline : WXSceneSession;
    
    [WXApi sendReq:req];
}


#pragma mark - Wechat Pay

// pay
- (void)wechatPay:(HXSOrderInfo *)orderInfo delegate:(id)delegate
{
    self.orderInfo = orderInfo;
    self.wechatPayDelegate = delegate;
    
    NSString *nameStr = [NSString stringWithFormat:@"59store%@订单", self.orderInfo.typeName]; //商品标题
    // 商品价格
    NSNumber *priceNum;
    if (kHXSOrderInfoInstallmentYES == [orderInfo.installmentIntNum integerValue]) {
        priceNum = orderInfo.downPaymentFloatNum; // 单位（元）   分期
    } else {
        priceNum = orderInfo.order_amount; // 单位（元）   不分期
    }
    
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    NSString *attach = nil;
    switch (self.orderInfo.type) {
        case kHXSOrderTypeDorm:
        {
            // Do nothing
        }
            break;
            
        case kHXSOrderTypeBox:
        {
            if (environmentType == HXSEnvironmentStage) {
                attach = @"http://mobileapi.59store.net/box/order/pay";
            } else if(environmentType == HXSEnvironmentQA) {
                attach = @"http://mobileapi.59shangcheng.com/box/order/pay";
            } else {
                attach = @"http://mobileapi.59store.com/box/order/pay";
            }
        }
            break;
        case kHXSOrderTypeEleme:
        {
            if (environmentType == HXSEnvironmentStage) {
                attach = @"http://mobileapi.59store.net/elemeapi/eleme/paycallback";
            } else if(environmentType == HXSEnvironmentQA) {
                attach = @"http://mobileapi.59shangcheng.com/elemeapi/eleme/paycallback";
            } else {
                attach = @"http://mobileapi.59store.com/elemeapi/eleme/paycallback";
            }
        }
            break;
            
        case kHXSOrderTypeDrink:
        {
            if (environmentType == HXSEnvironmentStage) {
                attach = @"http://mobileapi.59store.net/drink/drinkpayment/notify";
            } else if(environmentType == HXSEnvironmentQA) {
                attach = @"http://mobileapi.59shangcheng.com/drink/drinkpayment/notify";
            } else {
                attach = @"http://mobileapi.59store.com/drink/drinkpayment/notify";
            }
        }
            break;
            
        default:
            attach = orderInfo.attach;
            break;
    }
    
    NSDictionary *paramsDic = @{
                                @"app_type":@1,   // store 1  dorm 2
                                @"order_id":self.orderInfo.order_sn,
                                @"food_name":nameStr,
                                @"money":priceNum,
                                @"attach":attach,
                                };
    
    __weak typeof(self) weakSelf = self;
    [HXStoreWebService postRequest:HXS_WXPAY_PREPAY_ID
                       parameters:paramsDic
                         progress:nil
                          success:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (kHXSNoError != status) {
                                  if (weakSelf.wechatPayDelegate
                                      && [weakSelf.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
                                      [weakSelf.wechatPayDelegate wechatPayCallBack:HXSWechatPayStatusParamError
                                                                            message:nil
                                                                             result:nil];
                                      
                                      weakSelf.wechatPayDelegate = nil;
                                  }
                                  
                                  return ;
                              }
                              
                              [weakSelf sendReqOfWechat:data];
                              
                          } failure:^(HXSErrorCode status, NSString *msg, NSDictionary *data) {
                              if (weakSelf.wechatPayDelegate
                                  && [weakSelf.wechatPayDelegate respondsToSelector:@selector(wechatPayCallBack:message:result:)]) {
                                  [weakSelf.wechatPayDelegate wechatPayCallBack:HXSWechatPayStatusParamError
                                                                    message:nil
                                                                     result:nil];
                                  
                                  weakSelf.wechatPayDelegate = nil;
                              }
                          }];
}



- (void)sendReqOfWechat:(NSDictionary *)dict
{
    NSMutableString *stamp  = [dict objectForKey:@"time_stamp"];
    
    //调起微信支付
    PayReq* req   = [[PayReq alloc] init];
    
    req.openID    = [dict objectForKey:@"app_id"];
    req.partnerId = [dict objectForKey:@"partner_id"];
    req.prepayId  = [dict objectForKey:@"prepay_id"];
    req.nonceStr  = [dict objectForKey:@"nonce_str"];
    req.timeStamp = stamp.intValue;
    req.package   = [dict objectForKey:@"package"];
    req.sign      = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

@end