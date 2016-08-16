//
//  HXSQQSdkManager.m
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSQQSdkManager.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h> 

//qq
#define kTencentAppId  @"1104074892"
#define kTencentAppKey @"i1YQQZp0AoBT4CZV"

static HXSQQSdkManager * qq_instance = nil;

@interface HXSQQSdkManager () <TencentSessionDelegate,
                               QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth * tencentOAuth;
@property (nonatomic, strong) NSArray * permissions;

@end

@implementation HXSQQSdkManager

+ (HXSQQSdkManager *) sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (qq_instance == nil) qq_instance = [[HXSQQSdkManager alloc] init];
    });
    return qq_instance;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentAppId
                                                    andDelegate:self];
        self.permissions = [NSArray arrayWithObjects:
                                            kOPEN_PERMISSION_GET_USER_INFO,
                                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                            kOPEN_PERMISSION_ADD_ALBUM,
                                            kOPEN_PERMISSION_ADD_IDOL,
                                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                                            kOPEN_PERMISSION_ADD_PIC_T,
                                            kOPEN_PERMISSION_ADD_SHARE,
                                            kOPEN_PERMISSION_ADD_TOPIC,
                                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                                            kOPEN_PERMISSION_DEL_IDOL,
//                                            kOPEN_PERMISSION_DEL_T,
                                            kOPEN_PERMISSION_GET_FANSLIST,
                                            kOPEN_PERMISSION_GET_IDOLLIST,
                                            kOPEN_PERMISSION_GET_INFO,
                                            kOPEN_PERMISSION_GET_OTHER_INFO,
                                            kOPEN_PERMISSION_GET_REPOST_LIST,
//                                            kOPEN_PERMISSION_LIST_ALBUM,
//                                            kOPEN_PERMISSION_UPLOAD_PIC,
//                                            kOPEN_PERMISSION_GET_VIP_INFO,
//                                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
//                                            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
//                                            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                                            nil];
    }
    
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [TencentOAuth HandleOpenURL:url] || [QQApiInterface handleOpenURL:url delegate:self];
}

- (BOOL)isQQInstalled {
    return [TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin];
}

- (BOOL)isLoggedIn {
    return [self.tencentOAuth isSessionValid];
}

- (void)logIn {
    [self.tencentOAuth authorize:self.permissions inSafari:NO];
}

- (void)logOut {
    [self.tencentOAuth logout:self];
}


#pragma mark - Share To QQ

- (void)shareToQQWithTitle:(NSString *)title text:(NSString *)text image:(NSString *)imageUrl url:(NSString *)url callback:(HXSShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    SendMessageToQQReq *req = [self createSendMessage:title
                                          description:text
                                             imageUrl:imageUrl
                                                  url:url];
    
    [QQApiInterface sendReq:req];
}

- (void)shareToZoneWithTitle:(NSString *)title text:(NSString *)text image:(NSString *)imageUrl url:(NSString *)url callback:(HXSShareCallbackBlock)callback
{
    self.shareCallBack = callback;
    SendMessageToQQReq *req = [self createSendMessage:title
                                          description:text
                                             imageUrl:imageUrl
                                                  url:url];
    
    [QQApiInterface SendReqToQZone:req];
}

- (SendMessageToQQReq *)createSendMessage:(NSString *)title description:(NSString *)description imageUrl:(NSString *)imageUrl url:(NSString *)url
{
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                        title:title
                                                  description:description
                                              previewImageURL:[NSURL URLWithString:imageUrl]];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    return req;
}

#pragma mark - QQApiInterfaceDelegate

/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    // Do nothing
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToQQResp class]]) {
        NSString *message = nil;
        HXSShareResult status = kHXSShareResultFailed;
        if(resp.result.integerValue == 0) {
            message = @"分享成功";
            status = kHXSShareResultOk;
        }else if(resp.result.integerValue == -4) {
            message = @"用户取消";
            status = kHXSShareResultCancel;
        }else {
            message = @"分享失败";
            status = kHXSShareResultFailed;
        }
        
        if(self.shareCallBack) {
            self.shareCallBack(status, message);
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    // Do nothing
}

#pragma mark - TencentLoginDelegate
/**
 * Called when the user successfully logged in.
 */
- (void)tencentDidLogin {
    // 登录成功
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
        self.accessToken = _tencentOAuth.accessToken;
        self.userID = _tencentOAuth.openId;
        self.expirationDate = _tencentOAuth.expirationDate;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogin:)]) {
            [self.delegate thirdAccountDidLogin:kHXSQQAccount];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
            [self.delegate thirdAccountLoginFailed:kHXSQQAccount];
        }
    }
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginCancelled:)]) {
            [self.delegate thirdAccountLoginCancelled:kHXSQQAccount];
        }
    }
    else {
        if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
            [self.delegate thirdAccountLoginFailed:kHXSQQAccount];
        }
    }
    
}

/**
 * Called when the notNewWork.
 */
- (void)tencentDidNotNetWork
{
    //    _labelTitle.text=@"无网络连接，请设置网络";
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountLoginFailed:)]) {
        [self.delegate thirdAccountLoginFailed:kHXSQQAccount];
    }
}


#pragma mark - TencentSessionDelegate

/**
 * Called when the logout.
 */
- (void)tencentDidLogout
{
    //    _labelTitle.text=@"退出登录成功，请重新登录";
    if(self.delegate && [self.delegate respondsToSelector:@selector(thirdAccountDidLogout:)]) {
        [self.delegate thirdAccountDidLogout:kHXSQQAccount];
    }
    
}

@end