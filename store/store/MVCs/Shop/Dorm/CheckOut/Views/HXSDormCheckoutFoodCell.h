//
//  HXSDormCheckoutFoodCell.h
//  store
//
//  Created by hudezhi on 15/9/21.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSDormCartItem.h"
#import "HXSCartsItem.h"
@interface HXSDormCheckoutFoodCell : UITableViewCell

@property (nonatomic, strong) HXSDormCartItem *item;

/**
 *  设置赠品
 *
 *  @param item
 */
- (void)setPromotionItems:(HXSCartsItem *)item;
@end
