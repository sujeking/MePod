//
//  HXSMacrosDefault.h
//  store
//
//  Created by ArthurWang on 15/8/14.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#ifndef store_HXSMacrosDefault_h
#define store_HXSMacrosDefault_h

#pragma mark - User Default

// setting location
//#define USER_DEFAULT_LOCATION_HAS_BEEN_DENIED       @"locationHasBeenDenied"
#define USER_DEFAULT_NOTIFACTION_HAS_BEEN_DENIED    @"notificationHasBeenDenied"

// message
#define USER_DEFAULT_UNREAD_MESSGE_NUMBER           @"unreadMessageNumber"

// order type
#define USER_DEFAULT_LATEST_ORDER_TYPE              @"latestOrderType"

// dorm list type
#define USER_DEFAULT_DORM_LIST_TYPE                 @"dormListType"   // 0 horizontal 1 vertical

#define UPDATE_DEVICE_FINISHED @"device_update_finished"
#define kHXSUserID             @"kHXSUserID"
#define kHXSToken              @"kHXSToken"

#define kSharedLocationManagerForUserDefault  @"kSharedLocationManagerForUserDefault"

#define kHXSBoxAddSKUSearchHistoryUserDefault @"kHXSBoxAddSKUSearchHistoryUserDefault"
// 地址 APP3.2 新添加
#define USER_DEFAULT_LOCATION_MANAGER         @"LocationManager"


#pragma mark - Notification Keys

// 信用购支付成功
#define NOTIFICATION_CREDIT_PAY_SUCCESS @"notificatonCreditPaySuccess"

#define kLoginCompleted                 @"kLoginCompleted"
#define kLogoutCompleted                @"kLogoutCompleted"
#define kUserInfoUpdated                @"kUserInfoUpdated"

#define kPositioningCityChanged         @"kPositioningCityChanged"
#define kCityChanged                    @"kCityChanged"
#define kPositionCityFailed             @"kPositionCityFailed"

#define kTokenRefreshed                 @"kTokenRefreshed"
#define kMainItemsUpdated               @"kMainItemsUpdated"
#define kUpdateCartComplete             @"kUpdateCartComplete"
#define kUpdateCartCountComplete        @"kUpdateCartCountComplete"
#define kUpdateDormCartComplete         @"kUpdateDormCartComplete"
#define kAddToCartNotification          @"kAddToCartNotification"
#define kReceivedNewMessageNoitifcation @"kReceivedNewMessageNoitifcation"
#define kElemeUpateCartNotification     @"kElemeUpateCartNotification"

#define kBoxOrderHasPayed               @"boxOrderHasPayed"
#define kUnreadMessagehasUpdated        @"unreadMesageHasUpdated"
#define kCategoryTableviewDismiss       @"dismissTableView"

#define kStoreCartDidUpdated            @"kStoreCartDidUpdated"

#pragma mark - Eleme Keys

#define KEY_ELEME_CATEGORY_ID     @"category_id"
#define KEY_ELEME_FOOD_ID         @"food_id"
#define KEY_ELEME_SELECTED_NUMBER @"selected_number"
#define KEY_ELEME_FOOD_PRICE      @"food_price"
#define KEY_ELEME_FOOD_NAME       @"food_name"



// 免密支付  最低 价格

#define G_EXEMPTION_MIN_AMOUNT   10.0f

// Waiting time
#define MESSAGE_CODE_WAITING_TIME  30

// 云打印界面新人指引
#define CLOUDDRIVE_NEWBIEGUIDE @"clouddrive_newbieguide"
#define CLOUDDRIVE_NEWBIEGUIDE_DELETE @"clouddrive_newbieguide_delete"

// 云打印订单详情界面 是否使用福利纸提示
#define PrintIfUseWelfarePage @"printIfUseWelfarePage"

// 社区 话题列表更新
#define CommunityTopicUpdate  @"communityTopicUpdate"

// 骑士
#define KnightRobTaskSuccess    @"knightRobTaskSuccess"   // 抢单成功
#define KnightCancleTaskSuccess @"knightCancleTaskSuccess"// 取消成功
#define KnightFinishTaskSuccess @"knightFinishTaskSuccess"// 送达
#define KnightHaveNewTask       @"knightHaveNewTask"      // 有新的任务推送
#define KnightOrderStatusUpdate @"knightOrderStatusUpdate"// 订单状态被改变

#endif
