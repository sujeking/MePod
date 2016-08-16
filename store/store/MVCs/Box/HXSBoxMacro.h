//
//  HXSBoxMacro.h
//  store
//
//  Created by 格格 on 16/7/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#ifndef HXSBoxMacro_h
#define HXSBoxMacro_h


#endif /* HXSBoxMacro_h */


// 零食盒相关
static NSString * const kUsageEventBoxEntrance                         = @"box_entrance"; //盒子入口
static NSString * const kUsageEventBoxNeed                             = @"box_need"; //申请盒子
static NSString * const kUsageEventBoxAddressSelectCity                = @"address_select_city"; //选择城市
static NSString * const kUsageEventBoxAddressSelectSchool              = @"address_select_school"; //选择学校
static NSString * const kUsageEventBoxAddressSelectBuildingGroup       = @"address_select_building_group"; //选择楼区
static NSString * const kUsageEventBoxAddressSelectBuildingNumber      = @"address_select_building_number"; //选择楼号
static NSString * const kUsageEventBoxAddressSelectShop                = @"address_select_shop"; //选择店铺
static NSString * const kUsageEventBoxApplySubmit                      = @"box_apply_submit"; //盒子提交申请
static NSString * const kUsageEventBoxApplySexSelect                   = @"box_apply_sex_select"; //选择性别
static NSString * const kUsageEventBoxSchoolYear                       = @"box_school_year"; //入学年份
static NSString * const kUsageEventBoxApplyContactDorm                 = @"box_apply_contact_dorm"; //申请页面联系店主
static NSString * const kUsageEventBoxDelieveyContanctDorm             = @"box_belivery_contanct_drom"; //配送页面联系
static NSString * const kUsageEventBoxCheckPriorPeriodInventory        = @"box_check_prior_period_inventory"; //查看上去消费清单
static NSString * const kUsageEventBoxMasterNumber                     = @"box_master_number"; //盒主数量
static NSString * const kUsageEventBoxSharedNumber                     = @"box_shared_number"; //分享者数量
static NSString * const kUsageEventBoxCarAdd                           = @"box_car_add"; //盒子购物车加
static NSString * const kUsageEventBoxCarReduce                        = @"box_car_reduce"; //盒子购物车减
static NSString * const kUsageEventBoxShowGoodsDetails                 = @"box_show_goods_details"; //盒子打开商品详情
static NSString * const kUsageEventBoxBottomCar                        = @"box_bottom_car"; //盒子底部购物车热区
static NSString * const kUsageEventBoxCheckButton                      = @"box_check_button"; //盒子结算按钮
static NSString * const kUsageEventBoxRightMoreButton                  = @"box_right_button"; //盒子右上角更多按钮
static NSString * const kUsageEventBoxClearCar                         = @"box_clear_car"; //清空购物车
static NSString * const kUsageEventBoxConfirmClearCar                  = @"box_confirm_clear_car"; //确认清空购物车
static NSString * const kUsageEventBoxImmediatelyPay                   = @"box_immediately_pay"; //立即支付
static NSString * const kUsageEventBoxPayOpenWallet                    = @"box_pay_open_wallet"; //支付页开通59钱包
static NSString * const kUsageEventBoxPayWalletAscendingLine           = @"box_pay_wallet_ascending_line"; //支付页面钱包提升额度
static NSString * const kUsageEventBoxPayToPay                         = @"box_pay_to_pay"; //确认支付
static NSString * const kUsageEventBoxCheckoutSuccessContinueShopping  = @"box_checkout_success_continue_shopping"; //结算成功点击继续购物
static NSString * const kUsageEventBoxCheckoutSuccessMyOrder           = @"box_checkout_success_my_order"; //结算成功点击我的订单
static NSString * const kUsageEventBoxCheckoutFieldMyOrder             = @"box_checkout_field_my_order"; //计算失败点击我的订单
static NSString * const kUsageEventBoxMoreOptionClick                  = @"box_more_option_click"; //盒子打开更多后选择的操作
static NSString * const kUsageEventBoxMasterClickItem                  = @"box_master_click_item"; //盒主点击列表条目
static NSString * const kUsageEventBoxSharedClickItem                  = @"box_shared_click_item"; //分享者点击列表条目
static NSString * const kUsageEventBoxConsumptionRecordItemClick       = @"box_consumption_record_item_click"; //盒子消费记录条目点击
static NSString * const kUsageEventBoxRemoveShared                     = @"box_remove_shared"; //移除共享人
static NSString * const kUsageEventBoxRemoveSharedConfirm              = @"box_remove_shared_confirm"; //移除共享人弹框确定按钮
static NSString * const kUsageEventBoxTransferUseListItemClick         = @"box_transfer_use_list_item_click"; //转让共享人列表条目点击
static NSString * const kUsageEventBoxConfirmTransfer                  = @"box_confirm_transfer"; //确认转让弹出框的确认按钮
static NSString * const kUsageEventBoxTransferReceiveDialogButtonClick = @"box_transfer_receive_dialog_button_click"; //被转让人弹出确认接收框，确定和拒绝按钮点击
static NSString * const kUsageEventBoxShareBoxClick                    = @"box_share_box_click"; //分享零食盒
static NSString * const kUsageEventBoxShareBoxConfirmClick             = @"box_share_box_confirm_click"; //确认分享弹框内确定按钮
static NSString * const kUsageEventBoxSharedReceiveDialogButtonClick   = @"box_shared_receive_dialog_button_click"; //被分享人弹出确认接收框,确认和拒绝按钮点击
static NSString * const kUsageEventBoxSharedExitConfirmClick           = @"box_shared_exit_confirm_click"; //被分享人确定退出盒子弹框，确认按钮点击
static NSString * const kUsageEventBoxMasterGetConsumptionInventory    = @"box_master_get_consumption_inventory"; //盒主获取消费清单
static NSString * const kUsageEventBoxSharedGetConsumptionInventory    = @"box_shared_get_consumption_inventory"; //共享人获取消费清单
static NSString * const kUsageEventBoxCountingSharedRightMoreClick     = @"box_counting_shared_right_more_click"; //零食盒清单状态右上角更多按钮点击
static NSString * const kUsageEventBoxConsumptionInventoryAmountIsZero = @"box_consumption_inventory_amount_is_zero"; //零食盒清单支付金额是否为零
static NSString * const kUsageEventBoxAlreadyPaySnack                  = @"box_already_pay_snack"; //零食盒清单已经支付零食
static NSString * const kUsageEventBoxUntalkSnack                      = @"box_untalk_snack"; //零食盒清单已支付未领取零食
static NSString * const kUsageEventBoxOnlinePayment                    = @"box_online_payment"; //消费清单在线支付按钮
static NSString * const kUsageEventBoxOrderListItemClick               = @"box_order_list_item_click"; //零食盒订单条目点击
static NSString * const kUsageEventBoxOrderContactDorm                 = @"box_order_contact_dorm"; //零食盒订单详情联系店主按钮
static NSString * const kUsageEventBoxOrderCansel                      = @"box_order_cansel"; //零食盒订单取消按钮
static NSString * const kUsageEventBoxOrderImmediatelyPay              = @"box_order_immediately_pay"; //零食盒订单立即支付按钮
static NSString * const kConsumptionRecordItrmClick                    = @"box_consumption_record_item_click"; // 盒子消费记录条目点击
static NSString * const kUsageEventBoxPayType                          = @"box_pay_type";







