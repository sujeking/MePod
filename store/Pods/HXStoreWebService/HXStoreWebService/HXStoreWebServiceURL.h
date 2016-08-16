//
//  HXStoreWebServiceURL.h
//  Pods
//
//  Created by ArthurWang on 16/6/12.
//
//

#ifndef HXStoreWebServiceURL_h
#define HXStoreWebServiceURL_h

// path

#define kBundlePath @"bundle"

#define HXS_SERVER_URL                  [[ApplicationSettings instance] currentServiceURL]
#define HXS_HTTPS_SERVER_URL            [[ApplicationSettings instance] currentHttpsServiceURL]

//token
#define HXS_TOKEN_UPDATE                @"token/create"

//device
#define HXS_DEVICE_UPDATE               @"device/update"

//info & ad
#define HXS_ABOUT_INFO                @"about/info"
#define HXS_LAUNCHAD_INFO             @"launchad/info"
#define HXS_RECOMMEND_APPS            @"recommend/apps"
#define HXS_RECOMMENDED_GAMES         @"appstore/list"

// 发现
#define HXS_FIND_LAYOUT                 @"find/layout"

//location
#define HXS_CITY_LIST                   @"location/city/list"
#define HXS_CITY_SITE_LIST              @"location/city/site/list"
#define HXS_DORMENTRY_LIST              @"location/dormentry/list"
#define HXS_SITE_SELECT                 @"location/site/select"
#define HXS_SITE_INFO                   @"location/site/info"
#define HXS_SITE_POSITION               @"location/site/position"
#define HXS_SITE_SEARCH                 @"location/site/search"

//item
#define HXS_ITEM_INFO                   @"item/info"
#define HXS_ITEM_SPECIFICATION          @"item/specification"
#define HXS_ITEM_COMMENTS               @"item/comments"
#define HXS_ITEM_DESCRIPTION            @"item/description"
#define HXS_ITEM_RELATED                @"item/related"

//category
#define HXS_CATEGORY_LIST               @"category/list"
#define HXS_CATEGORY_ITEMS              @"category/items"

//夜猫店分类
#define HXS_SHOP_CATEGORY               @"shop/categories"
#define HXS_SHOP_ITEMS                  @"shop/items"


//search
#define HXS_SEARCH_ITEM                 @"search/items"

//user
#define HXS_USER_LOGIN                  @"user/login"
#define HXS_USER_LOGOUT                 @"user/logout"
#define HXS_USER_REGISTER               @"user/register"
#define HXS_USER_ORDERS                 @"user/orders"
#define HXS_USER_ADDRESSES              @"user/addresses"
#define HXS_USER_PASSWORD_UPDATE        @"user/password/update"
#define HXS_USER_NICK_NAME_UPDATE       @"user/nick_name/update"
#define HXS_USER_HEAD_PORTRAIT_UPDATE   @"user/head_portrait/update"
#define HXS_USER_WHOLE_INFO             @"user/whole_info"

// Account
#define HXS_ACCOUNT_VERIFY_TELEPHONE      @"creditcard/account/phone/verify"
#define HXS_ACCOUNT_VERIFY_PAY_PWD        @"creditcard/account/pay_password/verify"
#define HXS_ACCOUNT_PASSWORD_GET_BACK     @"creditcard/account/pay_password/reset"
#define HXS_ACCOUNT_BIND_PHONE_VERIFY     @"user/phone/verify"
#define HXS_ACCOUNT_MODIFY_BIND_TELEPHONE @"user/phone/update"
#define HXS_ACCOUNT_USER_PHONE_REGISTER   @"user/phone_register"

// 积分
#define HXS_USER_CREDIT                 @"user/credit"
#define HXS_USER_SIGN_IN                @"user/sign_in"

//order
#define HXS_ORDER_NEW                   @"order/new"
#define HXS_ORDER_INFO                  @"order/info"
#define HXS_ORDER_CANCEL                @"order/cancel"
#define HXS_ORDER_CHANGEPAYTYPE         @"order/changepaytype"

//优惠券
#define HXS_COUPON_LIST                 @"user/coupon/list"
#define HXS_COUPON_VALIDATE             @"user/coupon/validate"

//Dorm
#define HXS_NIGHT_CAT_ITEMS             @"nightcat/items"
#define HXS_NIGHT_CAT_CART_BRIEF        @"nightcat/cart/brief"
#define HXS_NIGHT_CAT_CART_INFO         @"nightcat/cart/info"
#define HXS_NIGHT_CAT_CART_ADD          @"nightcat/cart/add"
#define HXS_NIGHT_CAT_CART_UPDATE       @"nightcat/cart/update"
#define HXS_NIGHT_CAT_CART_CLEAR        @"nightcat/cart/clear"
#define HXS_NIGHT_CAT_CART_USE_COUPON   @"nightcat/cart/use_coupon"
#define HXS_NIGHT_CAT_ORDER_CREATE      @"nightcat/order/create"

// BOX
#define HXS_BOX_BOX_LIST                @"box/box/list" // 根据楼栋id及宿舍获取寝室的盒子信息列表
#define HXS_BOX_BOX_INFO                @"box/box/info" // 获取商品库存列表
#define HXS_BOX_BOX_APPLY               @"box/box/apply"// 申请表单提交

#define HXS_BOX_CART_INFO               @"box/cart/info"
#define HXS_BOX_CART_UPDATE             @"box/cart/update"
#define HXS_BOX_CART_CLEAR              @"box/cart/clear"
#define HXS_BOX_CART_USE_COUPON         @"box/cart/use_coupon"

#define HXS_BOX_MESSAGE_NEW             @"box/message/new"

#define HXS_BOX_ORDER_ADD               @"box/order/add"
#define HXS_BOX_ORDER_CANCEl            @"box/order/cancel"
#define HXS_BOX_ORDER_PAY               @"box/order/pay"
#define HXS_BOX_ORDER_LIST              @"box/order/list"
#define HXS_BOX_ORDER_INFO              @"box/order/info"

#define HXS_BOX_EXCLUDE_ITEMS_NEW       @"box/box/exclude_items_new"
#define HXS_BOX_ITEM_ADD                @"box/box/item/add"
#define HXS_BOX_ITEM_REMOVE             @"box/box/item/remove"
#define HXS_BOX_ITEM_REPLENISH          @"box/box/item/replenish"
#define HXS_BOX_EXCLUDE_ITEMS_SEARCH    @"box/box/exclude_items_search"
#define HXS_BOX_DORM_REPOS              @"box/box/dorm_repos"
#define HXS_BOX_DORM_REPOS_SEARCH       @"box/box/dorm_repos_search"

// message
#define HXS_USER_MESSAGE_LIST            @"user/message/list"
#define HXS_USER_MESSAGE_READ            @"user/message/read"
#define HXS_USER_MESSAGE_DELETE          @"user/message/delete"
#define HXS_USER_MESSAGE_UNREAD_NUM      @"user/message/unread_num"
#define HXS_USER_MESSAGE_READ_ALL        @"user/message/read_all"

// 59Pay
#define HXS_CREDITCARD_TRADE             @"creditcard/trade"
#define HXS_UPDATE_BANK_CARD             @"creditcard/bank_card/update"
#define HXS_BANK_CARD_INFO               @"creditcard/bank_card/info"
#define HXS_ACCOUNT_PAY_PASSWORD_UPDATE  @"creditcard/account/pay_password/update"
#define HXS_AVAILABLE_BANK_LIST          @"creditcard/bank_list"
#define HXS_BANK_CARD_VERIFY_CODE        @"creditcard/bank_card/verify_code/send"
#define HXS_EXEMPTION_STATUS_UPDATE      @"creditcard/account/exemption_status/update"

// 59Borrow/creditAccount
#define HXS_BORROW_ACCOUNT_INFO                     @"creditcard/loan/account_credit_info"
#define HXS_CREDIT_CARD_INSTALLMENT                 @"creditcard/encashment/installment_select"
#define HXS_CREDITCARD_ENCASHMENT_INSTALLMENT_APPLY @"creditcard/encashment/installment_apply"
#define HXS_BORROW_SUBMIT                           @"creditcard/loan/submit_apply"
#define HXS_BORROW_PURPOSE_TYPE                     @"creditcard/purpose_type"

// credit
#define HXS_CREDIT_LAYOUT                @"creditcard/layout"

// paybill
#define HXS_PAYBILLS_LIST               @"creditcard/consume_bills"
#define HXS_PAYBILLS_DETAIL             @"creditcard/consume_bill_detail"
#define HXS_PAYBILLS_INSTALLMENT_SELECT @"creditcard/bills_installment_select"
#define HXS_PAYBILLS_INSTALLMENT        @"creditcard/bills_installment"

// creadit info
#define HXS_CREDIT_CARD_INFO                      @"creditcard/info"
#define HXS_CREDIT_CARD_APPLY_OPEN                @"creditcard/apply_open"
#define HXS_CREDIT_CARD_OPEN_RESULT               @"creditcard/open_result"
#define HXS_CREDIT_CARD_AUTH_STATUS               @"creditcard/auth_status"
#define HXS_CREDIT_CARD_CONTACTS_AUTH             @"creditcard/contacts_auth"
#define HXS_CREDIT_CARD_EMERGENCY_CONTACTS_UPDATE @"creditcard/emergency_contacts_update"
#define HXS_CREDIT_CARD_ASCENSION_LINE            @"creditcard/ascension_line"
// credit card order
#define HXS_CHARGE_CENTER_ORDER_LIST              @"chargecenter/order/list"
#define HXS_CHARGE_CENTER_ORDER_INFO              @"chargecenter/order/info"
#define HXS_CHARGE_CENTER_ORDER_CANCEL            @"chargecenter/order/cancel"
#define HXS_TIP_TRACK_GETTRACK                    @"tip/track/gettrack"
#define HXS_TIP_ORDER_CONFIRM                     @"tip/order/confirm"
#define HXS_TIP_SAVE_COMMENT                      @"tip/comment/savecomment"

// 59 Bill
#define HXS_ACCOUNT_BILL_INFO            @"bill/sum"
#define HXS_BILL_PAY_LIST                @"bill/credit_pay"
#define HXS_BILL_PAY_HISTORY             @"bill/credit_pay/his"
#define HXS_BILL_BORROW_CASH_RECORD      @"creditcard/installment_records"
#define HXS_BILL_REPAYMENT_RECORD        @"creditcard/current_installment_bill"
#define HXS_BILL_REPAYMENT_SCHEDULE      @"creditcard/installment_records_detail"
#define HXS_BILL_PAY_HISTORY_DETAIL      @"bill/credit_pay/his/detail"

// push
#define HXS_DEVICE_RECEIVE_PUSH_STATUS   @"device/receive_push/status"
#define HXS_DEVICE_RECEIVE_PUSH_UPDATE   @"device/receive_push/update"


// EleMe
#define HXS_ELEME_ADDRESS                @"elemeapi/eleme/address"
#define HXS_ELEME_ADDRESS_UPDATE         @"elemeapi/eleme/address/update"
#define HXS_ELEME_ORDER_LIST             @"elemeapi/eleme/order/list"
#define HXS_ELEME_ORDER_CANCEL           @"elemeapi/eleme/order/cancel"
#define HXS_ELEME_RESTAURANT_LIST        @"elemeapi/eleme/restaurant/list"
#define HXS_ELEME_RESTAURANT_MENU        @"elemeapi/eleme/restaurant/menu"
#define HXS_ELEME_CART_CREATE            @"elemeapi/eleme/cart/create"
#define HXS_ELEME_ORDER_CREATE           @"elemeapi/eleme/order/create"
#define HXS_ELEME_ORDER_INFO             @"elemeapi/eleme/order/info"

// verify
#define HXS_VERIFICATION_CODE_REQUEST   @"verification_code/request"
#define HXS_VERIFICATION_CODE_VERIFY    @"verification_code/verify"

// print
#define HXS_PRINT_ORDER_LIST            @"print/order/list"     // 云印店订单列表
#define HXS_PRINT_ORDER_INFO            @"print/order/info"     // 云印店订单详情
#define HXS_PRINT_ORDER_CANCEL          @"print/order/cancel"   // 云印店取消订单
#define HXS_PRINT_DELIVERIES            @"print/shop/deliveries" // 云印店获取配送信息
#define HXS_PRINT_CART_CREATE           @"print/cart/create"     // 计算订单价格，创建购物车
#define HXS_PRINT_FORMATS               @"print/shop/formats"    // 文档打印样式、缩印样式设置
#define HXS_PRINTPIC_FORMATS            @"print/shop/picformats" // 照片打印样式、缩印样式设置
#define HXS_PRINT_CREATEORDER           @"print/order/create"    // 云印店 下单(文档)
#define HXS_ORDERPIC_PRINT_CREATEORDER  @"print/orderpic/create" // 云印店 下单(图片)
#define HXS_PRINT_UPLOAD                @"print/fileupload"      // 云印店 上传文档
#define HXS_PRINT_COUPONPIC_LIST        @"print/couponpic/list" // 云印店 获取优惠券

// pay
#define HXS_PAY_METHODS                 @"pay/methods"

// shop
#define HXS_SHOP_LIST                   @"shop/list"
#define HXS_SHOP_INFO                   @"shop/info"
#define HXS_SHOP_EXPECT_TIME_LIST       @"shop/expect_time/list"
#define HXS_SHOP_BANNER_LIST            @"shop/banner/list"

// storeapp
#define HXS_STORE_INLET               @"store/inlet" // 获取店铺首页的入口

// 分期购
#define HXS_TIP_SLIDE                      @"tip/slide"                   // 分期购轮播
#define HXS_TIP_CATEGORY_LIST              @"tip/category/list"           // 分期购分类
#define HXS_TIP_ITEM_LIST                  @"tip/item/list"               // 分期购分类商品列表
#define HXS_TIP_ITEM_DETAIL                @"tip/item/detail"             // 分期购商品详情
#define HXS_TIP_COMMENT_GETCOMMENT         @"tip/comment/getcomment"      // 分期购商品评价列表
#define HXS_TIP_ORDER_CREATE               @"tip/order/createorder"       // 分期购下单
#define HXS_TIP_ITEM_HOTITEMS              @"tip/item/hotitems"           // 热门商品获取
#define HXS_TIP_ITEM_PARAM                 @"tip/item/param"              // 商品规格参数和图文详情获取
#define HXS_TIP_ITEM_ALL_SKU               @"tip/item/all_sku"            // 子商品选购
#define HXS_TIP_ITEM_STOCK                 @"tip/item/stock"              // 商品库存
#define HXS_TIP_ORDER_GET_INSTALLMENT_LIST @"tip/order/getInstallmentList"// 获取分期列表
#define HXS_TIP_ORDER_GET_DOWNPAYMENT_LIST @"tip/order/getDownpaymentList"// 获取首付比例列表
#define HXS_TIP_ADDRESS_GET_PROVINCE       @"tip/address/getprovince"     // 分期购一级地址信息
#define HXS_TIP_ADDRESS_GET_CITY           @"tip/address/getcity"         // 分期购二级地址信息
#define HXS_TIP_ADDRESS_GET_COUNTRY        @"tip/address/getcountry"      // 分期购三级地址信息
#define HXS_TIP_ADDRESS_GET_TOWN           @"tip/address/gettown"         // 分期购四级地址信息
#define HXS_TIP_ADDRESS_GET_ZONE_SITE_LIST @"tip/address/getzonesitelist" // 获取城市所有大学信息
#define HXS_TIP_ADDRESS_GET_ADDRESS        @"tip/getaddress"              // 获取收货地址
#define HXS_TIP_ADDRESS_POST_ADDRESS       @"tip/saveaddress"             // 更新收货地址


// 云超市
#define HXS_CSHOP_ITEM_CATEGORIES @"cshop/item/categories"// 获取商品分类
#define HXS_CSHOP_ITEM_LIST       @"cshop/item/list"      // 获取分类的商品
#define HXS_CSHOP_ITEM_SEARCH     @"cshop/item/search"    // 搜索商品
#define HXS_CSHOP_ORDER_CONFIRM   @"cshop/order/confirm"  // 确认购物车信息
#define HXS_CSHOP_ORDER_NEW       @"cshop/order/new"      // 新增订单
#define HXS_CSHOP_ORDER_INFO      @"cshop/order/info"     // 订单信息
#define HXS_CSHOP_ORDER_LIST      @"cshop/order/list"     // 订单列表
#define HXS_CSHOP_ORDER_CANCEL    @"cshop/order/cancel"   // 取消订单


// 社区
#define HXS_COMMUNITY_TOPIC_LIST   @"community/topic/list"  // 获取话题列表
#define HXS_COMMUNITY_TOPIC_FOLLOW @"community/topic/follow"// 关注话题
#define HXS_COMMUNITY_USER_POST_LIST            @"community/user/post_list"           // 获取用户发帖列表
#define HXS_COMMUNITY_USER_COMMENT_LIST         @"community/user/comment_list"        // 获取用户给出的评论列表
#define HXS_COMMUNITY_USER_COMMENT_RECEIVE_LIST @"community/user/comment_receive_list"// 获取用户收到的评论列表
#define HXS_COMMUNITY_USER_MESSAGE              @"community/user/message"             // 获取用户收到的消息列表
#define HXS_COMMUNITY_USER_MESSAGE_READ         @"community/user/message_read"        // 用户读取消息
#define HXS_COMMUNITY_POST_HOT       @"community/post/hot"      // 热门帖子列表
#define HXS_COMMUNITY_POST_RECOMMEND @"community/post/recommend"// 推荐帖子列表
#define HXS_COMMUNITY_POST_ALL       @"community/post/all"      // 全部帖子列表
#define HXS_COMMUNITY_POST_FOLLOW    @"community/post/follow"   // 用户关注话题 帖子列表
#define HXS_COMMUNITY_POST_USER      @"community/post/user"     // 用户帖子列表，看某个人的帖子列表
#define HXS_COMMUNITY_POST_ADD       @"community/post/add"      // 发布帖子
#define HXS_COMMUNITY_POST_DETAIL    @"community/post/detail"   // 帖子详情
#define HXS_COMMUNITY_POST_DELTE     @"community/post/delete"   // 删除帖子
#define HXS_COMMUNITY_LIKE_ADD       @"community/like/add"      // 点赞
#define HXS_COMMUNITY_LIKE_LIST      @"community/like/lis"      // 喜欢列表
#define HXS_COMMUNITY_SHARE_ADD      @"community/share/add"     // 分享成功后调用
#define HXS_COMMUNITY_COMMENT_ADD    @"community/comment/add"   // 评论帖子
#define HXS_COMMUNITY_COMMENT_LIST   @"community/comment/list"  // 评论列表
#define HXS_COMMUNITY_COMMENT_DELETE @"community/comment/delete"// 评论删除
#define HXS_COMMUNITY_COMMON_UPLOAD  @"community/common/upload" // 上传图片
#define HXS_COMMUNITY_POST_DELETE    @"community/post/delete"   // 删除帖子


//ASYNC
#define SYNC_DEVICE_ID                   @"device_id"
#define SYNC_USER_ID                     @"uid"
#define SYNC_USER_TOKEN                  @"token"
#define SYNC_SITE_ID                     @"site_id"
#define SYNC_DEVICE_TYPE                 @"device_type"
#define SYNC_DEVICE_TOEKN                @"device_token"
#define SYNC_SYSTEM_VERSION              @"system_version"
#define SYNC_APP_VERSION                 @"app_version"

//sync response
#define SYNC_RESPONSE_MSG               @"msg"
#define SYNC_RESPONSE_STATUS            @"status"
#define SYNC_RESPONSE_DATA              @"data"

//Community
#define HXS_COMMUNITY_UPLOADPHOTO        @"community/common/upload_img_ios"     // 社区上传图片
#define HXS_COMMUNITY_ADDPOST            @"community/post/add"                  // 发帖
#define HXS_COMMUNITY_FETCHALLTOPICS     @"community/topic/list_all"            // 所有话题
#define HXS_COMMUNITY_COMMENTSFORME      @"community/user/comment_receive_list" // 获取用户收到的评论列表
#define HXS_COMMUNITY_MYCOMMENTS         @"community/user/comment_list"         // 获取用户给出的评论列表
#define HXS_COMMUNITY_FETCHMYPOSTS       @"community/user/post_list"            // 获取用户发的帖子
#define HXS_COMMUNITY_DELCOMMENT         @"community/comment/delete"            // 删除评论
#define HXS_COMMUNITY_LIKE_ADD           @"community/like/add"                  // 点赞
#define HXS_COMMUNITY_COMMENT_ADD        @"community/comment/add"               // 评论
#define HXS_COMMUNITY_COMMENT_LIST       @"community/comment/list"              // 评论列表
#define HXS_COMMUNITY_REPORT_REASON_LIST @"community/report/reason_list"        // 举报原因列表
#define HXS_COMMUNITY_SUBMIT_REPORT      @"community/report/submit"             // 举报帖子或评论内容

// Topic
#define HXS_COMMUNITY_TOPIC_LIST            @"community/topic/list"                 // 获取话题列表
#define HXS_COMMUNITY_TOPIC_FOLLOW          @"community/topic/follow"               // 关注话题
#define HXS_COMMUNITY_POST_HONT             @"community/post/hot"                   // 热门帖子列表
#define HXS_COMMUNITY_POST_RECOMMEND        @"community/post/recommend"             // 推荐帖子列表
#define HXS_COMMUNITY_POST_ALL              @"community/post/all"                   // 全部帖子列表
#define HXS_COMMUNITY_POST_FOLLOW           @"community/post/follow"                // 关注话题的帖子列表
#define HXS_COMMUNITY_RECOMMENDED_TOPIC     @"community/topic/recommended_topic"    // 推荐的话题
#define HXS_COMMUNITY_TOPIC_FOLLOW_ONE      @"community/topic/follow_one"           // 关注或者取消话题
#define HXS_COMMUNITY_TOPIC_INVALID         @"community/topic/topic_invalid"        // 获取话题关注状态
#define HXS_COMMUNITY_POST_DETIAL           @"community/post/detail"                // 获取帖子详情
#define HXS_COMMUNITY_MESSAGE_NEW           @"community/message/new"                // 获取帖子详情


// 骑士相关
#define HXS_KNIGHT_REWARDS_SCHEDULE             @"knight/rewards/schedule"                  // 骑士佣金的明细表
#define HXS_KNIGHT_SHOW                         @"knight/show"                              // 显示个人信息
#define HXS_KNIGHT_DELIVERY_OEDER_LIST          @"knight/delivery/order/list"               // 查询任务列表
#define HXS_KNIGHT_DELIVERY_OEDER_LIST_FINISH   @"knight/delivery/order/list_finish"        // 查询任务列表(完成)
#define HXS_KNIGHT_DELIVERY_OEDER_DETIAL        @"knight/delivery/order/detail"             // 查询订单详情
#define HXS_KNIGHT_WITHDRAW                     @"knight/withdraw"                          // 提现
#define HXS_KNIGHT_DELIVERY_ORDER_GAIN          @"knight/delivery/order/gain"               // 抢单
#define HXS_KNIGHT_DELIVERY_ORDER_CANCLE        @"knight/delivery/order/cancel"             // 取消订单
#define HXS_KNIGHT_DELIVERY_ORDER_COMPLETE      @"knight/delivery/order/complete"           // 完成订单
#define HXS_KNIGHT_DELIVERY_ORDER_CODE          @"knight/delivery/order/code"               // 获取二维码信息
#define HXS_KNIGHT_BANK_LIST                    @"knight/bank/list"                         // 获取银行列表

// 零食盒子相关
#define HXS_BOX_INFO             @"box/info"                // 零食盒子的信息
#define HXS_BOX_SHARE            @"box/shared"               // 分享零食盒子
#define HXS_BOX_SHARED_INFO      @"box/shared/info"         // 共享人信息
#define HXS_BOX_ORDER_LIST       @"box/order/list"          // 零食盒子订单列表
#define HXS_BOX_ORDER_INFO       @"box/order/info"          // 零食盒子订单详情
#define HXS_BOX_TRANSFER         @"box/transfer"            // 转让零食盒子
#define HXS_BOX_ITEM_LIST        @"box/item/list"           // 零食盒子商品列表
#define HXS_BOX_CONSUM_LIST      @"box/consum/list"         // 获取消费清单
#define HXS_BOX_CONSUM_UNTAKE_LIST @"box/consum/untake/list" // 已支付未领取零食列表
#define HXS_BOX_BILL_CASHPAY     @"box/bill/cashpay"

#define HXS_BOX_ORDER_CREATE     @"/box/order/create"   //零食盒下单

#define HSX_BOX_APPLY            @"/box/apply"          //申请零食盒子
#define HSX_BOX_APPLY_INFO       @"/box/apply/info"     //盒子申请信息




#endif /* HXStoreWebServiceURL_h */
