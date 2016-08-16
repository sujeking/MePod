//
//  HXSAlipayManager.m
//  store
//
//  Created by chsasaw on 15/4/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSAlipayManager.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSString+Addition.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXSOrderInfo.h"
#import "HXMacrosEnum.h"

static HXSAlipayManager * alipay_instance = nil;

@interface HXSAlipayManager()

@end

@implementation HXSAlipayManager

+ (HXSAlipayManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alipay_instance == nil) alipay_instance = [[HXSAlipayManager alloc] init];
    });
    return alipay_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if (url && [url.host isEqualToString:@"safepay"]) {
        
        NSString * urlString = [NSString decodeString:url.query];
        id json = [NSJSONSerialization JSONObjectWithData:[urlString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
        if(json && [json isKindOfClass:[NSDictionary class]]) {
            if(DIC_HAS_DIC(json, @"memo")) {
                NSDictionary * memoDic = [json objectForKey:@"memo"];
                if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                    NSString * message = [memoDic objectForKey:@"memo"];
                    NSString * status = [memoDic objectForKey:@"ResultStatus"];
                    NSDictionary * result = nil;
                    if(DIC_HAS_DIC(memoDic, @"result")) {
                        result = [memoDic objectForKey:@"result"];
                    }
                    
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:result];
                    }
                }
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (void)pay:(HXSOrderInfo *)orderInfo delegate:(id<HXSAlipayDelegate>)delegate {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    NSString *partner = nil;
    NSString *seller = nil;
    NSString *privateKey = nil;
    HXSEnvironmentType environmentType = [[ApplicationSettings instance] currentEnvironmentType];
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    if (HXSEnvironmentStage == environmentType
        || HXSEnvironmentQA == environmentType
        || HXSEnvironmentTemai == environmentType) {
        partner = @"2088021264733879";
        seller = @"ningff@59store.com";
        privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMDFzGuCF/YB2ycy\nA6EzLHTW1qVn4d3APcjvGFU7FpnX0P83n3ybHxDjv12y3jp9m1aONjCw9LGuJ63d\n5hXt6C3eww7+iz3k9QWWjB2ssvq0a9pfh5824IUAf1zFNANznaLDZzyOMLPpZjMt\nuN1w06t7dR0JDl1wb3PnacTIXQB9AgMBAAECgYAMjdUeOz6sOrq29r7dxKNkiIk6\nBGXlNxvO9iMzicGTC0cFF+4/Aysmwm43/+oRDRUMsf49dYi5+YmD/St6yh+QoBCj\n+w7J6BvYHcWJdyjIl8CLfdzePzh/DEU3Rb47c/XScxhM6/MfSO8RvNOt2sopk4R0\nEqiEvagCFiPEGcYLgQJBAPggDqT8WLPTP0Lb9BFB/GML3Epmn09rjm1l2vM9WHE7\ncT0GlmCfEdPk58fSYlTm8Y39T35iQjs1Km4TzeeQR4kCQQDG5ASvw9xhfeR15fOV\nEYSkzPa9iOFtpn3YqX1S8/UDvyPLT50LvKApRxKKw4fqvTL9LmkQ/q0xGqHgoeLf\nO0BVAkAw1Q5MxiUm7vJKVEOKifQEAjeOpPfBh6d2PE+FA5O+ZTZ6DivWRDgb/bbo\nCq2zi+gKS8ozU185i9MX6unhIvIRAkAtRd4jPExADO4iQDPQLOqqsNVBk5Ts5sci\nuIIEje+p6Kp3Lyoqb8dtXfZEi/m2X1bp9tSHv9EgqlVK0s7XzZ75AkEAjZuRy3V0\ncKS42q6nJRohPhyd1L+YyMUFFntxqKNg2AGQ7re/+jJVx9swgN95lljB4a26CArQ\nlaqAkJpC0jXTdw==";
    } else {
        partner = @"2088901490646751";
        seller = @"zkp@59food.com";
        privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAPdS8wdz1Gf+7T7j8b4Tw62QqThmfl5GA4D3XsOfg8zWgyagvvTng1f2QwouwBmxV4Yd5oAYK4/B3ZP+KfX6GT7vBHVBAtIWZdfFXFvj/kofaG2BVD+4cNNFaPApEFt8R91pV6TVWrO4rnbE0lz10Q/L5j1VLAKNXK/Nr8TqU/MVAgMBAAECgYA5drlmwt/YJeADm7ygOEFfw1u98fpsdwH7Zf5Ln3VlE3Y3dGPJzTy0JFChPgl+LrkyPSJAIt2EMjwEVap0L17LzpavPY0cvjBR3vmf76rBEQ2HCPNBVH5dF18oEdDSVu9eq8cQ5XCU1k0jAMFM4bJoG7mLUG3PVzvLboVLNhDqZQJBAP8i/6f/5N6JfS35Ic+5PgYIxpYNx1oLm1NRWv/B4JwHQs8KZzy7AA/GwGfRmfgdVda3s7KV7//HP0mNGWLAW28CQQD4KS7qQlIWKwAi9FoEfPxu8B4+ipsBlISysGG3Y34f9XW21iXuz+omdZpBSpLS8ZT39i6ua4H73qmWoi23sOe7AkEAi/U4B4HBnC4R5FlJKfk1Q/wmbAQs+oFpeIAlii1huFXnWUocrdzrQLxHqev6KXh2MS5evjWwDUDQv9lONrTMswJBAOAMRpgncncjMYddd1wv/7SlQ5kRiKrfjQLLLh3lTLzL3xBIvYyj2HIKoU8rZe3fQLCyaij9VSiyOgiOuZnrtPsCQBooAQ6R8roe9L0vl0i7pBkm8QoQdNhd/dtmLphCWHeT2WWLkoA7Mdvzo8CSC943jq9sDJlL1Fjcfkks8a+tiHg=";
    }
    
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.delegate = delegate;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderInfo.order_sn; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"59store%@订单", orderInfo.typeName]; //商品标题
    // 商品价格
    if (kHXSOrderInfoInstallmentYES == [orderInfo.installmentIntNum integerValue]) {
        order.amount = [NSString stringWithFormat:@"%.2f",orderInfo.downPaymentFloatNum.floatValue]; // 分期
    } else {
        order.amount = [NSString stringWithFormat:@"%.2f",orderInfo.order_amount.floatValue]; // 不分期
    }
    switch (orderInfo.type) {
        case kHXSOrderTypeDorm:
        {
            // Do nothing
        }
            break;
            
        case kHXSOrderTypeBox:
        {
            if (environmentType == HXSEnvironmentStage) {
                order.productDescription = @"http://mobileapi.59store.net/box/order/pay";
            } else if(environmentType == HXSEnvironmentQA) {
                order.productDescription = @"http://mobileapi.59shangcheng.com/box/order/pay";
            } else {
                order.productDescription = @"http://mobileapi.59store.com/box/order/pay";
            }
        }
            break;
        case kHXSOrderTypeEleme:
        {
            if (environmentType == HXSEnvironmentStage) {
                order.productDescription = @"http://mobileapi.59store.net/elemeapi/eleme/paycallback";
            } else if(environmentType == HXSEnvironmentQA) {
                order.productDescription = @"http://mobileapi.59shangcheng.com/elemeapi/eleme/paycallback";
            } else {
                order.productDescription = @"http://mobileapi.59store.com/elemeapi/eleme/paycallback";
            }
        }
            break;
            
        case kHXSOrderTypeDrink:
        {
            if (environmentType == HXSEnvironmentStage) {
                order.productDescription = @"http://mobileapi.59store.net/drink/drinkpayment/notify";
            } else if(environmentType == HXSEnvironmentQA) {
                order.productDescription = @"http://mobileapi.59shangcheng.com/drink/drinkpayment/notify";
            } else {
                order.productDescription = @"http://mobileapi.59store.com/drink/drinkpayment/notify";
            }
        }
            break;
            
        default:
        {
            order.productDescription = orderInfo.attach; //商品附加信息
        }
            break;
    }
    
    if (environmentType == HXSEnvironmentStage) {
        order.notifyURL =  @"http://pay.59store.net/pay/alipay/notify";
    } else if(environmentType == HXSEnvironmentQA) {
        order.notifyURL = @"http://61.130.1.150:28081/pay/alipay/notify";
    } else if(environmentType == HXSEnvironmentTemai){
        order.notifyURL = @"http://61.130.1.150:58091/pay/alipay/notify";
    }
    else {
        order.notifyURL =  @"http://pay.59store.com/pay/alipay/notify";
    }
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"http://www.59store.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"hxstore";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if(resultDic) {
                if(DIC_HAS_DIC(resultDic, @"memo")) {
                    NSDictionary * memoDic = [resultDic objectForKey:@"memo"];
                    if(DIC_HAS_STRING(memoDic, @"memo") && DIC_HAS_STRING(memoDic, @"ResultStatus")) {
                        NSString * message = [memoDic objectForKey:@"memo"];
                        NSString * status = [memoDic objectForKey:@"ResultStatus"];
                        NSDictionary * result = nil;
                        if(DIC_HAS_DIC(memoDic, @"result")) {
                            result = [memoDic objectForKey:@"result"];
                        }
                        
                        if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                            [self.delegate payCallBack:status message:message result:result];
                        }
                    }
                }else if(DIC_HAS_STRING(resultDic, @"memo") && [resultDic objectForKey:@"resultStatus"]) {
                    NSString * message = [resultDic objectForKey:@"memo"];
                    NSString * status = [NSString stringWithFormat:@"%@", [resultDic objectForKey:@"resultStatus"]];
                    NSString * result = [resultDic objectForKey:@"result"];
                    if(self.delegate && [self.delegate respondsToSelector:@selector(payCallBack:message:result:)]) {
                        [self.delegate payCallBack:status message:message result:@{@"result":result}];
                    }
                }
            }
        }];
    }
}

@end
