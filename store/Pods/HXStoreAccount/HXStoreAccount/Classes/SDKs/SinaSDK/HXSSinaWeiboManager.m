//
//  HXSSinaWeiboManager.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSinaWeiboManager.h"

#import "HXSCustomAlertView.h"
#import "HXMacrosUtils.h"

//sina
#define kSinaWeiboAppKey             @"2612136234"
#define kSinaWeiboAppSecret          @"1113e1735bad4b46f8fb2410b6c4c196"
#define kSinaWeiboAppRedirectURI     @"http://www.59store.com/callback"

static HXSSinaWeiboManager * sina_instance = nil;

@implementation HXSSinaWeiboManager

+ (HXSSinaWeiboManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sina_instance == nil) sina_instance = [[HXSSinaWeiboManager alloc] init];
    });
    return sina_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        [WeiboSDK enableDebugMode:NO];
        [WeiboSDK registerApp:kSinaWeiboAppKey];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            self.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            self.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            self.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
    }
    
    return self;
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.accessToken, @"AccessTokenKey",
                              self.expirationDate, @"ExpirationDateKey",
                              self.userID, @"UserIDKey", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)isLoggedIn {
    return self.accessToken&&self.userID;
}

- (void)logIn {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaWeiboAppRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)logOut {
    [WeiboSDK logOutWithToken:self.accessToken delegate:nil withTag:@"user1"];
    [self removeAuthData];
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
}

- (void)shareToWeiboWithText:(NSString *)text image:(UIImage *)image callback:(HXSShareCallbackBlock)callBack{
    self.shareCallBack = callBack;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kSinaWeiboAppRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(image, 1.0f);
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.accessToken];
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}

#pragma mark - sinadelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
//        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
//        [self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = nil;
        NSString *message = nil;
        WeiboSDKResponseStatusCode code = [(WBSendMessageToWeiboResponse *)response statusCode];
        HXSShareResult status = kHXSShareResultFailed;
        if(code == WeiboSDKResponseStatusCodeSuccess) {
            title = @"分享结果";
            message = @"分享成功";
            status = kHXSShareResultOk;
        }else if(code == WeiboSDKResponseStatusCodeUserCancel) {
            title = @"分享结果";
            message = @"用户取消";
            status = kHXSShareResultCancel;
        }else if(code == WeiboSDKResponseStatusCodeUnsupport) {
            title = @"认证结果";
            message = @"系统不支持";
            status = kHXSShareResultFailed;
        }else {
            title = @"认证结果";
            message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];;
        }
        
        if(self.shareCallBack) {
            self.shareCallBack(status, message);
        }else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:title
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        WeiboSDKResponseStatusCode code = [(WBAuthorizeResponse *)response statusCode];
        if(code == WeiboSDKResponseStatusCodeSuccess) {
            self.accessToken = [(WBAuthorizeResponse *)response accessToken];
            self.expirationDate = [(WBAuthorizeResponse *)response expirationDate];
            self.userID = [(WBAuthorizeResponse *)response userID];
            [self storeAuthData];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogin:)]) {
                [self.delegate thirdAccountDidLogin:kHXSSinaWeiboAccount];
            }
        }else if(code == WeiboSDKResponseStatusCodeUserCancel) {
            NSString *title = @"认证结果";
            NSString *message = @"用户取消";
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:title
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginCancelled:)]) {
                [self.delegate thirdAccountLoginCancelled:kHXSSinaWeiboAccount];
            }
        }else if(code == WeiboSDKResponseStatusCodeUnsupport) {
            NSString *title = @"认证结果";
            NSString *message = @"系统不支持";
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:title
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
                [self.delegate thirdAccountLoginFailed:kHXSSinaWeiboAccount];
            }
        }else {
            NSString *title = @"认证结果";
            NSString *message = @"认证失败";
            
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:title
                                                                              message:message
                                                                      leftButtonTitle:nil
                                                                    rightButtonTitles:@"确定"];
            [alertView show];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
                [self.delegate thirdAccountLoginFailed:kHXSSinaWeiboAccount];
            }
        }
//        NSString *title = @"认证结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField=[alertView textFieldAtIndex:0];
    
    NSString *jsonData = @"{\"text\": \"新浪新闻是新浪网官方出品的新闻客户端，用户可以第一时间获取新浪网提供的高品质的全球资讯新闻，随时随地享受专业的资讯服务，加入一起吧\",\"url\": \"http://app.sina.com.cn/appdetail.php?appID=84475\",\"invite_logo\":\"http://sinastorage.com/appimage/iconapk/1b/75/76a9bb371f7848d2a7270b1c6fcf751b.png\"}";
    
    [WeiboSDK inviteFriend:jsonData withUid:[textField text] withToken:self.accessToken delegate:self withTag:@"invite1"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    id json = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];;
    if(json && DIC_HAS_STRING(json, @"result")) {
        NSString * result = [json objectForKey:@"result"];
        if([result isEqualToString:@"true"]) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogout:)]) {
                [self.delegate thirdAccountDidLogout:kHXSSinaWeiboAccount];
            }
            return;
        }
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"警告"
                                                                      message:[NSString stringWithFormat:@"%@",result]
                                                              leftButtonTitle:nil
                                                            rightButtonTitles:@"确定"];
    [alertView show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"请求异常"
                                                                      message:[NSString stringWithFormat:@"%@",error]
                                                              leftButtonTitle:nil
                                                            rightButtonTitles:@"确定"];
    [alertView show];
}

@end