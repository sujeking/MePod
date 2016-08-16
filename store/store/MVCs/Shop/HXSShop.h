//
//  HXSShop.h
//  store
//
//  Created by 格格 on 16/7/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#ifndef HXSShop_h
#define HXSShop_h

#endif /* HXSShop_h */

#import "HXSUsageManager.h"

// 埋点
static NSString * const kChangeLocation                         = @"change_location";

// 夜猫店
static NSString * const kUsageEventDormBalanceCartButton        = @"dorm_balance_cart_button";

// 打印店
static NSString * const kUsageEventPrintConfirmCheckOut         = @"print_confirm_check_out";
static NSString * const kUsageEventPrintConfirmCheckOutSuc      = @"print_confirm_check_out_suc";
static NSString * const kUsageEventPrintConfirmCheckOutFail     = @"print_confirm_check_out_fail";

// 商品选择页 埋点
static NSString * const kUsageEventNavShopnameClikc             = @"nav_shop_name_click";
static NSString * const kUsageEventShopInformationImageClick    = @"shop_information_image_click";      // 店铺介绍浮层店铺头像点击
static NSString * const kUsageEventFoodTypeChange               = @"food_type_change";                  // 更改分类
static NSString * const kUsageEventFoodDetailInfo               = @"food_detial_info";                  // 点击打开商品详情浮层
static NSString * const kUsageEventFoodDetialInfoChangeNum      = @"food_detial_info_change_num";       // 商品浮层中改变商品数量
static NSString * const kUsageEventShoppingCartClick            = @"shopping_cart_click";               // 购物车热区点击，弹出购物车浮层
static NSString * const kUsageEventCartClearCart                = @"cart_clear_cart";                   // 清空购物车
static NSString * const kUsageEventCartChangeQuantity           = @"shopping_cart_change_num";          // 购物车点击加号减号
static NSString * const kUsageEventCheckout                     = @"shopping_char_settlement";          // 购物车结算按钮点击
static NSString * const kUsageEventFoodListItemChangeNum        = @"food_list_item_change_num";         // 列表item加号减号点击
static NSString * const kUsageEventGoodsSelectGoBack            = @"goods_select_go_back";              // 点击返回按钮

// 商品选择 - 夜猫店
static NSString * const kUsageEventDormChangeListType           = @"dorm_change_list_type";             // 夜猫店，切换商品列表列表或者方格显示
static NSString * const kUsageEventFoodGridItemChangeNum        = @"food_grid_item_change_num";         // 夜猫店，方格item加号减号点击

// 商品选择 - 云超市
static NSString * const kUsageEventCloudSupermarketSearch       = @"cloud_supermarket_search";          // 云超市点击搜索按钮
static NSString * const kUsageEventCloudSupermarketSort         = @"cloud_supermarket_sort";            // 云超市排序

// 商品搜索页 - 云超市
static NSString * const kUsageEventCloudSupermarketSearchCancle = @"cloud_supermarket_search_cancle";   // 云超市商品搜索页，取消搜索

// 确认订单页
static NSString * const kUsageEventDromNumberInput              = @"dorm_number_input";                 // 寝室号输入
static NSString * const kUsageEventPhoneNumberInput             = @"phone_number_input";                // 手机号输入
static NSString * const kUsageEventLeaveMessage                 = @"leave_message";                     // 点击编辑留言
static NSString * const kUsageEventCheckoutPay                  = @"check_out_pay";                     // 点击立即支付
static NSString * const kUsageEventCheckOutGoBack               = @"check_out_go_back";                 // 确认订单页点击返回

// 确认订单页 - 夜猫店
static NSString * const kUsageEventChooseCoupon                 = @"choose_coupon";                     // 点击选择优惠券
static NSString * const kUsageEventChooseDeliveryTime           = @"choose_delivery_time";              // 点击选择送达时间
static NSString * const kUsageEventChooseCouponFromMylist       = @"choose_coupon_from_my_list";        // 点击“从我的优惠券选择”
static NSString * const kUsageEventCouponNumberInput            = @"coupon_number_input";               // 点击手动输入券号
static NSString * const kUsageEventDeliveryTimeSelected         = @"delivery_time_selected";            // 送达时间选择



