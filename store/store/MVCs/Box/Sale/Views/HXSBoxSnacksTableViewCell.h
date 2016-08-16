//
//  HXSBoxSnacksTableViewCell.h
//  store
//
//  Created by  黎明 on 16/6/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBoxOrderModel.h"
#import "HXSBoxCarManager.h"

@class HXSBoxOrderItemModel;

@interface HXSBoxSnacksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;//商品图片
@property (weak, nonatomic) IBOutlet UILabel     *goodsNameLabel;//商品名称及信息
@property (weak, nonatomic) IBOutlet UILabel     *priceLabel;//单价
@property (weak, nonatomic) IBOutlet UIButton    *plusButton;//添加按钮
@property (weak, nonatomic) IBOutlet UIButton    *subtractButton;//减少按钮
@property (weak, nonatomic) IBOutlet UILabel     *goodsAmountLabel;//购买数量
@property (weak, nonatomic) IBOutlet UILabel     *goodsStockLabel;//库存数量
@property (nonatomic, strong) HXSBoxCarManager   *boxCarManager;

@property (strong, nonatomic) HXSBoxOrderItemModel *boxItemModel;   //商品信息
@property (copy, nonatomic) void (^updateSnackBoxCarBlock)();//更新零食盒购物车回调

- (CGRect)getGoodsImageViewRect;

- (void)initSubViews;

@end
