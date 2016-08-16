//
//  HXSBestPayApiManager.m
//  store
//
//  Created by ArthurWang on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBestPayApiManager.h"

#import <CommonCrypto/CommonDigest.h>
#import "BestpayNativeModel.h"
#import "BestpaySDK.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXMacrosEnum.h"

// 生产
#define releaseURL @"https://webpaywg.bestpay.com.cn/order.action"
// 准生产
#define debugURL @"http://wapchargewg.bestpay.com.cn/order.action"

// 翼支付
#define kBestPayKeyStr @"D9556CFE19CFF5F8A1FDDA8D291C96247989C72D7E04F3B9"  // 账号标识
#define kBestPayMerid  @"02310202070113045"                                 // 商户号
#define kBestPayPswd   @"195665"                                            // 密码

@interface HXSBestPayApiManager () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSURLConnection *connection;

// input params
@property (nonatomic, strong) HXSOrderInfo *orderInfo;
@property (nonatomic, strong) NSString                     *moneyStr;
@property (nonatomic, weak  ) UIViewController             *fromViewController;
@property (nonatomic, weak  ) id<HXSBestPayApiManagerDelegate> bestPayDelegate;

@end

@implementation HXSBestPayApiManager

#pragma mark - Public Methods

+ (instancetype)sharedManager
{
    static HXSBestPayApiManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) manager = [[HXSBestPayApiManager alloc] init];
    });
    return manager;
}

- (void)bestPayWithOrderInfo:(HXSOrderInfo *)orderInfo
                        from:(UIViewController *)fromViewController
                    delegate:(id<HXSBestPayApiManagerDelegate>)bestPayDelegate;
{
    self.orderInfo          = orderInfo;
    self.moneyStr           = [NSString stringWithFormat:@"%0.2f", [orderInfo.order_amount floatValue]];
    self.fromViewController = fromViewController;
    self.bestPayDelegate    = bestPayDelegate;
    
    [self submitOrder];
    
    return;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    __weak typeof(self) weakSelf = self;
    
    @try {
        [BestpaySDK processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"确保结果显示不会出错：%@",resultDic);
            
            NSNumber *resultCodeIntNum = [resultDic objectForKey:@"resultCode"];
            NSString *messageStr = [resultDic objectForKey:@"result"];
            
            if ((nil != weakSelf.bestPayDelegate)
                && [weakSelf.bestPayDelegate respondsToSelector:@selector(bestPayCallBack:message:result:)]) {
                [weakSelf.bestPayDelegate bestPayCallBack:[resultCodeIntNum integerValue]
                                                  message:messageStr
                                                   result:resultDic];
            }
        }];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return NO;
}

- (void)dealloc
{
    self.receiveData = nil;
    self.params = nil;
    self.connection = nil;
    
}


#pragma mark - Create Order

// 下单处理
- (void)submitOrder
{
    NSString *orderSeq = self.orderInfo.order_sn;
    NSString *orderReqTrnSeq = [NSString stringWithFormat:@"%@%@",self.orderInfo.order_sn, [self getOrderTrSeq]];
    NSString *orderTime = [self getOrderTime:[NSDate date]];
    
    self.receiveData = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:releaseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSString* signOrigStr = [NSString stringWithFormat:@"MERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&KEY=%@", kBestPayMerid, orderSeq, orderReqTrnSeq, orderTime, kBestPayKeyStr];
    DLog(@"下单签名源串 singOrigStr = %@", signOrigStr);
    NSString *signMac = [self MD5:signOrigStr];
    DLog(@"下单签名 singOrigStr = %@", signMac);
    NSString *str = [NSString stringWithFormat:@"MERCHANTID=%@&SUBMERCHANTID=%@&ORDERSEQ=%@&ORDERAMT=%@&ORDERREQTRANSEQ=%@&ORDERREQTIME=%@&ATTACH=%@&MAC=%@&TRANSCODE=%@",
                     kBestPayMerid,
                     @"",
                     orderSeq,
                     [NSString stringWithFormat:@"%.0f",[self.moneyStr floatValue]*100.0f],
                     orderReqTrnSeq,
                     orderTime,
                     [self getAttach],
                     signMac,
                     @"01"];
    
    _params = [[NSMutableDictionary alloc] init];
    
    [_params setObject:orderSeq             forKey:@"ORDERSEQ"];
    [_params setObject:orderReqTrnSeq       forKey:@"ORDERREQTRNSEQ"];
    [_params setObject:orderTime            forKey:@"ORDERREQTIME"];
    
    DLog(@"下单接口信息：%@",str);
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//订单处理
- (void)doOrder
{
    //获取订单信息
    NSString *orderStr = [self orderInfos];
    
    /////////////////////////////////
    DLog(@"跳转支付页面带入信息：%@", orderStr);
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSArray *urls = [dic objectForKey:@"CFBundleURLTypes"];
    
    BestpayNativeModel *order =[[BestpayNativeModel alloc]init];
    order.orderInfo = orderStr;
    order.launchType = launchTypePay1;
    order.scheme = [[[urls firstObject] objectForKey:@"CFBundleURLSchemes"] firstObject];
    
    __weak typeof(self) weakSelf = self;
    [BestpaySDK payWithOrder:order fromViewController:self.fromViewController callback:^(NSDictionary *resultDic) {
        DLog(@"result == %@", resultDic);
        
        // 1.支付成功：url＝scheme://resultCode=00&result=成功&ORDERSEQ=订单号&ORDERAMOUNT＝订单金额
        // 2.支付失败： url＝scheme://resultCode=01&result=失败
        // 3.支付取消：url＝scheme://resultCode=02&result=取消

        NSNumber *resultCodeIntNum = [resultDic objectForKey:@"resultCode"];
        NSString *messageStr = [resultDic objectForKey:@"result"];
        
        if ((nil != weakSelf.bestPayDelegate)
            && [weakSelf.bestPayDelegate respondsToSelector:@selector(bestPayCallBack:message:result:)]) {
            [weakSelf.bestPayDelegate bestPayCallBack:[resultCodeIntNum integerValue]
                                              message:messageStr
                                               result:resultDic];
        }
    }];
    
}

- (NSString *)orderInfos
{
    
    NSMutableString * orderDes = [NSMutableString string];
    
    // 签名参数
    //1. 接口名称
    NSString *service = @"mobile.securitypay.pay";
    [orderDes appendFormat:@"SERVICE=%@", service];
    //2. 商户号
    [orderDes appendFormat:@"&MERCHANTID=%@", kBestPayMerid];
    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
    [orderDes appendFormat:@"&MERCHANTPWD=%@", kBestPayPswd];
    //4. 子商户号
    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", [self getNotifyUrl]];
//    [orderDes appendFormat:@"&NOTIFYURL=%@", [self getNotifyUrl]];
    //6. 订单号
    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
    //7. 订单请求流水号，唯一
    [orderDes appendFormat:@"&ORDERREQTRANSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
    //8. 订单请求时间 格式：yyyyMMddHHmmss
    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
    //9. 订单有效截至日期
    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", [self getOrderTime:[[NSDate date] dateByAddingTimeInterval:60*60*24]]];
    //10. 币种, 默认RMB
    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
    //11. 订单金额/积分扣减
    [orderDes appendFormat:@"&ORDERAMOUNT=%@", self.moneyStr];
    //    [orderDes appendFormat:@"&ORDERAMT=%@", self.money.text];
    //12.商品简称
    [orderDes appendFormat:@"&SUBJECT=%@", [self productName]];
    //13. 业务标识 optional
    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
    //14. 产品描述 optional
    [orderDes appendFormat:@"&PRODUCTDESC=%@", [self productName]];
    //15. 客户标识 在商户系统的登录名 optional
    [orderDes appendFormat:@"&CUSTOMERID=%@", @"gehudedengluzhanghao"];
    //16.切换账号标识
    [orderDes appendFormat:@"&SWTICHACC=%@", @""];
    NSString *SignStr =[NSString stringWithFormat:@"%@&KEY=%@", orderDes, kBestPayKeyStr];
    //17. 签名信息 采用MD5加密
    NSString *signStr = [self MD5:SignStr];
    [orderDes appendFormat:@"&SIGN=%@", signStr];
    
    
    //18. 产品金额
    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", self.moneyStr];
    //19. 附加金额 单位元，小数点后2位
    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
    //20. 附加信息 optional
    [orderDes appendFormat:@"&ATTACH=%@", [self getAttach]];
    //21. 分账描述 optional
    //    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
    //22. 翼支付账户号
    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
    
    //23. 用户IP 主要作为风控参数 optional
    [orderDes appendFormat:@"&USERIP=%@", @"228.112.116.118"];
    //24. 业务类型标识
    [orderDes appendFormat:@"&BUSITYPE=%@", @"09"];
    
    //25.授权令牌
    [orderDes appendFormat:@"&EXTERNTOKEN=%@", @"NO"];
    //    //27.客户端号
    //    [orderDes appendFormat:@"&APPID=%@", @""];
    //    //28.客户端来源
    //    [orderDes appendFormat:@"&APPENV=%@", @"112233"];
    //27. 签名方式
    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
    
    //    // 7个基本参数
    //    //1. 接口名称
    //    NSString *service = @"mobile.security.pay";
    //    [orderDes appendFormat:@"SERVICE=%@", service];
    //    //2. 商户号
    //    [orderDes appendFormat:@"&MERCHANTID=%@", MERID];
    //    //3. 商户密码 由翼支付网关平台统一分配给各接入商户
    //    [orderDes appendFormat:@"&MERCHANTPWD=%@", PSWD];
    //    //4. 子商户号
    //    [orderDes appendFormat:@"&SUBMERCHANTID=%@", @""];
    //    //5. 支付结果通知地址 翼支付网关平台将支付结果通知到该地址，详见支付结果通知接口
    //    [orderDes appendFormat:@"&BACKMERCHANTURL=%@", @"http://127.0.0.1:8040/wapBgNotice.action"];
    //    //6. 签名方式
    //    [orderDes appendFormat:@"&SIGNTYPE=%@", @"MD5"];
    //    //7. 证信息 采用MD5加密
    //    NSString *encodeOrderStr = [NSString stringWithFormat:@"MERCHANTID=%@&ORDERSEQ=%@&ORDERREQTRNSEQ=%@&ORDERTIME=%@&KEY=%@", MERID, [_params objectForKey:@"ORDERSEQ"], [_params objectForKey:@"ORDERREQTRNSEQ"] , [_params objectForKey:@"ORDERREQTIME"] , KEYSTR];
    //    NSString *signStr = [MD5 MD5:encodeOrderStr];
    //    NSLog(@"加密原串%@-----加密串%@",encodeOrderStr,signStr);
    //    [orderDes appendFormat:@"&MAC=%@", signStr];
    //
    //    // 16个业务参数
    //    //1. 订单号
    //    [orderDes appendFormat:@"&ORDERSEQ=%@", [_params objectForKey:@"ORDERSEQ"]];
    //    //2. 订单请求流水号，唯一
    //    [orderDes appendFormat:@"&ORDERREQTRNSEQ=%@", [_params objectForKey:@"ORDERREQTRNSEQ"]];
    //    //3. 订单请求时间 格式：yyyyMMddHHmmss
    //    [orderDes appendFormat:@"&ORDERTIME=%@", [_params objectForKey:@"ORDERREQTIME"]];
    //    //4. 订单有效截至日期
    //    [orderDes appendFormat:@"&ORDERVALIDITYTIME=%@", @""];
    //    //5. 订单金额/积分扣减
    //    [orderDes appendFormat:@"&ORDERAMOUNT=%@", self.money.text];
    //    //6. 币种, 默认RMB
    //    [orderDes appendFormat:@"&CURTYPE=%@", @"RMB"];
    //    //7. 业务标识 optional
    //    [orderDes appendFormat:@"&PRODUCTID=%@", @"04"];
    //    //8. 产品描述 optional
    //    [orderDes appendFormat:@"&PRODUCTDESC=%@", @"联想手机"];
    //    //9. 产品金额
    //    [orderDes appendFormat:@"&PRODUCTAMOUNT=%@", self.money.text];
    //    //10. 附加金额 单位元，小数点后2位
    //    [orderDes appendFormat:@"&ATTACHAMOUNT=%@",@"0.00"];
    //    //11. 附加信息 optional
    //    [orderDes appendFormat:@"&ATTACH=%@", @"88888"];
    //    //12. 分账描述 optional
    //    [orderDes appendFormat:@"&DIVDETAILS=%@", @""];
    //    //13. 翼支付账户号
    //    [orderDes appendFormat:@"&ACCOUNTID=%@", @""];
    //    //14. 客户标识 在商户系统的登录名 optional
    //    [orderDes appendFormat:@"&CUSTOMERID=%@", @"gehudedengluzhanghao"];
    //    //15. 用户IP 主要作为风控参数 optional
    //    [orderDes appendFormat:@"&USERIP=%@", @"228.112.116.118"];
    //    //16. 业务类型标识
    //    [orderDes appendFormat:@"&BUSITYPE=%@", @"04"];
    return orderDes;
    
}

#pragma mark - NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    if([[receiveStr substringToIndex:2] isEqualToString:@"00"])
    {
        [self doOrder];
    }
    else
    {
        DLog(@"下单失败：%@", receiveStr);
        
        if ((nil != self.bestPayDelegate)
            && [self.bestPayDelegate respondsToSelector:@selector(bestPayCallBack:message:result:)]) {
            [self.bestPayDelegate bestPayCallBack:kHXSBestPayStatusFailed
                                              message:@"失败"
                                               result:nil];
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"请求失败%@",[error localizedDescription]);
    
    if ((nil != self.bestPayDelegate)
        && [self.bestPayDelegate respondsToSelector:@selector(bestPayCallBack:message:result:)]) {
        [self.bestPayDelegate bestPayCallBack:kHXSBestPayStatusFailed
                                      message:@"失败"
                                       result:nil];
    }
}

- (NSString *)MD5:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i] ];
    
    return [result uppercaseString];
}

#pragma mark - Time Methods

//获取当前时间戳
- (NSString *)getOrderTrSeq
{
    NSDate *senddate=[NSDate date];
    NSString *locationString = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    return locationString;
}

//获取当前时间毫秒级
- (NSString *)getOrderTimeMS
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMddHHmmssSS"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    return locationString;
}

//获取当前时间分钟级
- (NSString *)getOrderTime:(NSDate *)date
{
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *locationString = [dateformatter stringFromDate:date];
    
    return locationString;
}


#pragma mark - Private Methods

- (NSString *)productName
{
    NSString *nameStr = [NSString stringWithFormat:@"59store%@订单", self.orderInfo.typeName]; //商品标题
    
    return nameStr;
}

- (NSString *)getNotifyUrl {
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    if (environmentType == HXSEnvironmentStage) {
        return @"http://pay.59store.net/pay/tianyipay/notify";
    } else if(environmentType == HXSEnvironmentQA){
        return @"http://61.130.1.150:28081/pay/tianyipay/notify";
    } else{
        return @"http://pay.59store.com/pay/tianyipay/notify";
    }
}

- (NSString *)getAttach {
    if(self.orderInfo.attach.length > 0) {
        return self.orderInfo.attach;
    }
    
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];

    switch (self.orderInfo.type) {
        case kHXSOrderTypeDorm:
        {
            if (environmentType == HXSEnvironmentStage) {
                return @"http://yemao.59store.net/payment/notify"; //商品描述
            } else if(environmentType == HXSEnvironmentQA){
                return @"http://yemao.59shangcheng.com/payment/notify"; //商品描述
            } else{
                return @"http://yemao.59store.com/payment/notify"; //商品描述
            }
        }
            break;
            
        case kHXSOrderTypeBox:
        {
            if (environmentType == HXSEnvironmentStage) {
                return @"http://mobileapi.59store.net/box/order/pay";
            } else if(environmentType == HXSEnvironmentQA) {
                return @"http://mobileapi.59shangcheng.com/box/order/pay";
            } else {
                return @"http://mobileapi.59store.com/box/order/pay";
            }
        }
            break;
        case kHXSOrderTypeEleme:
        {
            if (environmentType == HXSEnvironmentStage) {
                return @"http://mobileapi.59store.net/elemeapi/eleme/paycallback";
            } else if(environmentType == HXSEnvironmentQA) {
                return @"http://mobileapi.59shangcheng.com/elemeapi/eleme/paycallback";
            } else {
                return @"http://mobileapi.59store.com/elemeapi/eleme/paycallback";
            }
        }
            break;
            
        case kHXSOrderTypeDrink:
        {
            if (environmentType == HXSEnvironmentStage) {
                return @"http://mobileapi.59store.net/drink/drinkpayment/notify";
            } else if(environmentType == HXSEnvironmentQA) {
                return @"http://mobileapi.59shangcheng.com/drink/drinkpayment/notify";
            } else {
                return @"http://mobileapi.59store.com/drink/drinkpayment/notify";
            }
        }
            break;
            
        default:
            break;
    }
    
    return self.orderInfo.attach;
}

@end
