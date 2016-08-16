//
//  HXSMacros.h
//  store
//
//  Created by chsasaw on 14/10/25.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#ifndef store_HXSMacros_h
#define store_HXSMacros_h

// 登录账号
typedef enum
{
    kHXSSinaWeiboAccount,
    kHXSWeixinAccount,
    kHXSQQAccount,
    kHXSRenrenAccount,
    kHXSUnknownAccount = 99,
}HXSAccountType;

// 订单状态
typedef NS_ENUM(NSInteger, HXSOrderStauts){
    kHXSOrderStautsCommitted     = 0,// 已提交
    kHXSOrderStautsConfirmed     = 1,// 已确认
    kHXSOrderStautsSent          = 2,// 已送出(用户端显示已完成)
    kHXSOrderStautsWaiting       = 3,// 等待状态(便利店的，废弃)
    kHXSOrderStautsDone          = 4,// 已完成
    kHXSOrderStautsCaneled       = 5,// 失败(已取消)
    kHXSOrderStautsOnlineWaiting = 11,// 在线支付等待支付状态
};

// 云超市订单状态
typedef NS_ENUM(NSInteger, HXSStoreOrderStatus) {
    HXSStoreOrderStatusCreated     = 0, // 已下单(订单创建成功)
    HXSStoreOrderStatusReceived    = 1, // 已接单
    HXSStoreOrderStatusDeliveried  = 2, // 已送达
    HXSStoreOrderStatusCompleted   = 4, // 已完成
    HXSStoreOrderStatusCancel      = 5, // 已取消
    HXSStoreOrderStatusDistributing = 7, // 配送中
};

// 订单来源
typedef enum : NSUInteger {
    kHXSOrderSourceWeb     = 0, // 网站
    kHXSOrderSourceWechat  = 1, // 手机网页(微信)
    kHXSOrderSourceShop    = 2, // shop端快速下单(废弃)
    kHXSOrderSourceiOS     = 3, // iOS
    kHXSOrderSourceAndroid = 4, // android
    kHXSOrderSourceEleme   = 5, // 饿了么平台
    kHXSOrderSourceShopPay = 6, // 到店付
} HXSOrderSource;


// 支付类型
typedef enum : NSUInteger {
    kHXSOrderPayTypeCash       = 0,// 现金
    kHXSOrderPayTypeZhifu      = 1,// 支付宝
    kHXSOrderPayTypeWechat     = 2,// 微信公众号支付
    kHXSOrderPayTypeBaiHuaHua  = 3,// 白花花支付
    kHXSOrderPayTypeAlipayScan = 4,// 支付宝扫码付
    kHXSOrderPayTypeWechatScan = 5,// 微信刷卡支付
    kHXSOrderPayTypeWechatApp  = 6,// 微信App支付
    kHXSOrderPayTypeCreditCard = 8,// 信用钱包支付
    kHXSOrderPayTypeBestPay    = 13,// 翼支付
} HXSOrderPayType;

// 信用钱包交易类型
typedef NS_ENUM(NSInteger, HXStradeType){
    kHXStradeTypeNormal      = 1,
    kHXStradeTypeEncashment  = 2,
    kHXStradeTypeInstallment = 3,
};

// 支付状态
typedef NS_ENUM(NSInteger, HXSOrderPayStatus){
    kHXSOrderPayStatusWaiting = 0,
    kHXSOrderPayStatusDone    = 10,
};

// 零食盒 订单状态
typedef enum : NSUInteger {
    kHSXBoxOrderStatusUnpay = 0,
    kHXSBoxOrderStatusPayed,
    kHXSBoxOrderStatusCanceled,
} HXSBoxOrderStatus;

// 订单类型
typedef enum : NSUInteger {
    kHXSOrderTypeNormal        = 0, // 便利店(废弃)
    kHXSOrderTypeGroupPurchase = 1, // 团购订单(废弃)
    kHXsOrderTypeBook          = 2, // 预定订单(废弃)
    kHXSOrderTypeChinaMoble    = 3, // 中国移动项目(废弃)
    kHXSOrderTypeDorm          = 4, // 夜猫店
    kHXSOrderTypeBox           = 5, // 零食盒
    kHXSOrderTypeEleme         = 6, // 饿了么
    kHXSOrderTypeDrink         = 7, // 饮品店
    kHXSOrderTypePrint         = 8, // 打印店
    kHXSOrderTypeCharge        = 9, // 充值订单
    kHXSOrderTypeInstallment   = 10, // 分期购订单
    kHXSOrderTypeEncashment    = 11, // 取现订单
    kHXSOrderTypeStore         = 12, // 云超市
    kHXSOrderTypeNewBox        = 19, // 零食盒4.3
    kHXSOrderTypeOneDream      = 20, // 一元夺宝
} HXSOrderType;

// 分期购 评价状态
typedef NS_ENUM(NSInteger, HXSOrderCommentStatus){
    kHXSOrderCommentStatusDonot = 0,
    kHXSOrderCommentStatusDone  = 1,
};

// 优惠券 状态
typedef enum : NSUInteger {
    kHSXCouponStatusNotYet = 0,
    kHSXCouponStatusNormal,
    kHXSCouponStatusUsed,
    kHXSCouponStatusExpired
} HXSCouponStatus;

// 优惠券 使用范围
typedef enum : NSUInteger {
    kHXSCouponScopeNone = 0,
    kHXSCouponScopeStore = 1,
    kHXSCouponScopeDorm = 2,
    kHXSCouponScopeBox = 3,
    kHXSCouponScopeDrink = 4,
    kHXSCouponScopePrint = 5,
} HXSCouponScope;

// 消息中心 消息类型
typedef enum : NSUInteger {
    kHXSMessageTypeNone        = 0,
    kHXSMessageTypeSystem      = 140,
    kHXSMessageTypeTrade       = 141,
    kHXSMessageTypeInstallment = 142,
    kHXSMessageTypeCoupon      = 143,
    kHXSMessageTypePoints      = 144,
} HXSMessageType;

// Tab Bar View Controllers
typedef enum : NSUInteger {
    kHXSTabBarFoodie    = 0,
    kHXSTabBarWallet    = 1,
    kHXSTabBarCommunity = 2,
    kHXSTabBarPersonal  = 3,
} HXSTabBarViewControllers;

typedef enum {
    kHXSDormItemStatusClosed        = 0, //店长休息
    kHXSDormItemStatusEmpty         = 1,    //未开通
    kHXSDormItemStatusLackStock     = 2,//没有库存
    kHXSDormItemStatusNormal        = 99
}HXSDormItemStatus;

// dorm list type
typedef enum : NSUInteger {
    kHXSDormListTypeHorizontal = 0,
    kHXSDormListTypeVertical   = 1,
} HXSDormListType;

// 楼层，楼栋请求
typedef enum : NSUInteger {
    kHXSLocationDormTypeDorm  = 0,
    kHXSLocationDormTypeDrink = 1,
    kHXSLocationDormTypeEleme = 2,
} HXSLocationDormType;

// 身份证验证,业务类型
typedef enum NSUInteger {
    kHXSIdentifyBusinessTypeCrditPay  = 1,  //  白花花
    kHXSIdentifyBusinessTypeBorrow    = 2,  //  白借借
} HXSIdentifyBusinessType;

// 零食盒商品状态
typedef enum : NSUInteger {
    HXSBoxSKUStatusNormal       = 0,
    HXSBoxSKUStatusReplenishing = 1,
    HXSBoxSKUStatusSoldOut      = 2,
} HXSBoxSKUStatus;

// 零食盒子申请状态
typedef enum : NSUInteger {
    HXSApplyBoxStatusUnApplyed = 0,   //    未申请
    HXSApplyBoxStatusApplying = 1,    //    申请中
} HXSApplyBoxStatus;

// 性别类型
typedef enum : NSUInteger {
    HXSGenderTypeNone = 0,
    HXSGenderMale,
    HXSGenderFemale,
}HXSGenderType;


// 店铺类型
typedef enum : NSUInteger {
    kHXSShopTypeDorm  = 0,
    kHXSShopTypeDrink = 1,
    kHXSShopTypePrint = 2,
    kHXSShopTypeStore = 3,
    kHXSShopTypeFruit = 4,
    
    kHXSShopTypeAll   = 99,
} HXSShopType;

typedef enum {
    kHXSShopStatusClosed = 0,//休息
    kHXSShopStatusOpen   = 1,//营业
    kHXSShopStatusBook   = 2,//预定中
} HXSShopStatus;

// 订单类型
typedef NS_ENUM(NSInteger, HXSPayBillState)
{
    HXSPayBillStateNormal = 0,      // 正常状态：还款中
    HXSPayBillStateFinished,        // 已还清
    HXSPayBillStateTimeOut,         // 已逾期
};

// 信用购 账户状态
typedef enum : NSUInteger {
    kHXSCreditAccountStatusNotOpen        = 0,
    kHXSCreditAccountStatusOpened         = 1,
    kHXSCreditAccountStatusNormalFreeze   = 2,
    kHXSCreditAccountStatusAbnormalFreeze = 3,
    kHXSCreditAccountStatusChecking       = 4,
    kHXSCreditAccountStatusCheckFailed    = 5,
} HXSCreditAccountStatus;

// 信用购 额度状态
typedef enum : NSUInteger {
    kHXSCreditLineStatusInit         = 0,// 初始额度
    kHXSCreditLineStatusChecking     = 1,// 提升额度审核中
    kHXSCreditLineStatusDone         = 2,// 已提升额度
    kHXSCreditLineStatusFailed       = 3,// 额度提升失败
    kHXSCreditLineStatusDataNotClear = 4,// 提升额度资料不清晰
} HXSCreditLineStatus;

// 信用购订单类型
typedef NS_ENUM(NSInteger, HXSCreditCardOrderType){
    kHXSCreditCardOrderTypeInstallment = 10,
    kHXSCreditCardOrderTypeTopUp       = 11,
    kHXSCreditCardOrderTypeAll         = 99,
};

//我的账单:
//消费类账单状态:
typedef NS_ENUM(NSUInteger,HXSMyBillConsumeStatus) {
    kHXSMyBillConsumeStatusNotPay    = 0,  // 未还款
    kHXSMyBillConsumeStatusPayed     = 1,  // 已还款
    kHXSMyBillConsumeStatusDelay     = 2,  // 已逾期
};

//消费类账单类型:
typedef NS_ENUM(NSUInteger,HXSMyBillConsumeType){
    HXSMyBillConsumeTypeCurrent      = 0,  // 本期账单
    HXSMyBillConsumeTypeNext         = 1,  // 下期账单
    HXSMyBillConsumeTypeHistoy       = 2,  // 历史账单
};

//消费类账单是否分期:
typedef NS_ENUM(NSUInteger,HXSMyBillConsumeInstallmentStatus) {
    HXSMyBillConsumeInstallmentStatusNotDone      = 0,  // 未分期
    HXSMyBillConsumeInstallmentStatusDone         = 1,  // 已分期
} ;

//消费类账单详细信息中的类型:
typedef NS_ENUM(NSInteger, HXSMyBillConsumeBillDetailsType){
    HXSMyBillConsumeBillDetailsTypeSnacks         = 0,  // 零食
    HXSMyBillConsumeBillDetailsTypeMovies         = 1,  // 电影
    HXSMyBillConsumeBillDetailsTypeRecharge       = 2,  // 充值
    HXSMyBillConsumeBillDetailsTypeHotels         = 3,  // 酒店
    HXSMyBillConsumeBillDetailsTypeKTV            = 4,  // KTV
    HXSMyBillConsumeBillDetailsTypeFoods          = 5,  // 美食
};

// 云印店 订单状态
typedef NS_ENUM(NSInteger,HXSPrintOrderStatus){
    HXSPrintOrderStatusNotPay           = 0, // 未支付
    HXSPrintOrderStatusConfirmed        = 1, // 未打印
    HXSPrintOrderStatusDistribution     = 2, // 配送中
    HXSPrintOrderStatusCompleted        = 4, // 已完成
    HXSPrintOrderStatusCanceled         = 5, // 已取消
    HXSPrintOrderStatusPrinted          = 6  // 已打印
} ;

// 云印店 配送类型
typedef NS_ENUM(NSInteger,HXSPrintDeliveryType){
    HXSPrintDeliveryTypeShopOwner = 1, // 店长配送
    HXSPrintDeliveryTypeSelf      = 2  // 上门自取
};

//云印店 下载的文件类型
typedef NS_ENUM(NSUInteger,HXSDocumentType) {
    HXSDocumentTypePdf          = 1,  // pdf
    HXSDocumentTypeDoc          = 2,  // doc
    HXSDocumentTypeTxt          = 3,  // txt
    HXSDocumentTypeImageJPEG    = 4,  // image/jpeg
    HXSDocumentTypeImagePNG     = 5,  // image/png
    HXSDocumentTypeImageGIF     = 6,  // image/gif
    HXSDocumentTypeImageTIFF    = 7,  // image/tiff
    HXSDocumentTypeImageWEBP    = 8,  // image/webp
    HXSDocumentTypePPT          = 9,  // PPT
};

//云印店 打印文件设置:打印类型
typedef NS_ENUM(NSUInteger,HXSDocumentSetPrintType) {
    kHXSDocumentSetPrintTypeWhiteBlackSingle    = 1,  // 黑白单面
    kHXSDocumentSetPrintTypeWhiteBlackTwo       = 2,  // 黑白双面
    kHXSDocumentSetPrintTypeColorSingle         = 3,  // 彩色单面
    kHXSDocumentSetPrintTypeColorTwo            = 4,  // 彩色双面
};

//云印店 打印文件设置:缩印类型
typedef NS_ENUM(NSUInteger,HXSDocumentSetReduceType) {
    kHXSDocumentSetReduceTypeNormal         = 0,  // 不缩印
    kHXSDocumentSetReduceTypeTwoInOne       = 1,  // 二合一
    kHXSDocumentSetReduceTypeFourInOne      = 2,  // 四合一
    kHXSDocumentSetReduceTypeSixInOne       = 3,  // 六合一
    kHXSDocumentSetReduceTypeNineInOne      = 4,  // 九合一
};

//云印店 打印文件设置:缩印类型
typedef NS_ENUM(NSUInteger,HXSPrintDocumentType) {
    HXSPrintDocumentTypePicture             = 0,  // 照片
    HXSPrintDocumentTypeOther               = 1,  // 文档
};

// 社区 帖子列表类型
typedef NS_ENUM(NSUInteger,HXSPostListType) {
    HXSPostListTypeHot             = 0,  // 热门
    HXSPostListTypeRecommend       = 1,  // 推荐
    HXSPostListTypeAll             = 2,  // 全部
    HXSPostListTypeFollow          = 3,  // 关注
    HXSPostListTypeOther          = 4,   // 他人
};

// 社区 帖子列表类型
typedef NS_ENUM(NSUInteger,HXSTopicFollowType) {
    HXSTopicFollowTypeUnFollowed     = 0,  // 未关注
    HXSTopicFollowTypeFollowed       = 1,  // 已关注
};

// 社区 帖子评论类型
typedef NS_ENUM(NSUInteger,HXSCommunityCommentORLikeType) {
    HXSCommunityCommentORLikeTypeLike     = 1,  // 点赞
    HXSCommunityCommentORLikeTypeComment  = 2,  // 评论
};

// 骑士 订单状态
typedef NS_ENUM(NSUInteger,HXSKnightStatus) {
    HXSKnightStatusWaitingTask     = 0,  // 待抢单
    HXSKnightStatusWaitingHandle   = 1,  // 待处理
    HXSKnightStatusHandled         = 2,  // 已处理
};

typedef NS_ENUM(NSUInteger,HXSKnightDeliveryStatus) {
    HXSKnightDeliveryStatusWaitingGet      = 1,  // 待取货
    HXSKnightDeliveryStatusDelivering      = 2,  // 配送中
    HXSKnightDeliveryStatusFinish          = 3,  // 已送达
    HXSKnightDeliveryStatusCancle          = 4,  // 已取消
    HXSKnightDeliveryStatusSettled         = 5,  // 已完成
};

typedef NS_ENUM(NSUInteger,HXPersonSignStatus) {
    kHXPersonSignStatusNotSign      = 0,  //  未签到
    kHXPersonSignStatusFinish       = 1,  //  已签到
};

typedef NS_ENUM(NSUInteger,HXPersonIfKnightStatus) {
   kHXPersonIfKnightStatusNo      = 0,  //  不是骑士
   kHXPersonIfKnightStatusYes     = 1,  //  是骑士
   kHXPersonIfKnightStatusLocked  = 2,  //  被锁定
   kHXPersonIfKnightStatusQuit    = 3,  //  退出
   kHXPersonIfKnightStatusUnKnown = -1,  //  未知
};


typedef NS_ENUM(NSUInteger,HXSNoticePushType) {
    HXSNoticePushTypeCommuniyCommend      = 1000,  //  社区评论推送
    kHXNoticePushKnightHaveTask           = 2000,  //  骑士有订单可抢推送
    kHXNoticePushKnightOrderCancle        = 2001,  //  骑士订单被用户取消
    kHXNoticePushKnightOrderSendingCancle = 2002,  //  骑士配送中的订单因为超时被取消
};

typedef NS_ENUM(NSInteger, HXSStoreInlet){
    kHXSStoreInletBanner              = 0,      // 店铺首页轮播
    kHXSStoreInletEntry               = 1,      // 首页的店铺入口列表
    kHXSStoreInletDiscoverTop         = 2,      // 发现页(上)
    kHXSStoreInletDiscoverMiddle      = 3,      // 发现页(中)
    kHXSStoreInletDisCoverBottom      = 4,      // 发现页(下)
    kHXSStoreInletCreditBottom        = 5,      // 发不完(下)
    kHXSStoreInletBalanceResultBottom = 6,      // 订单页(下)
    kHXSStoreInletCreditMiddle        = 7,      // 发不完(中)
    kHXSCommunityInletTop             = 8,      // 社区
    kHXSPrintInletTop                 = 9,      // 打印
    kHXSStoreInletActivity            = 10,     // 首页活动推广
};

// 分享 结果
typedef NS_ENUM(NSUInteger, HXSShareResult) {
    kHXSShareResultOk = 0,
    kHXSShareResultCancel = 1,
    kHXSShareResultFailed = 2
};




#endif