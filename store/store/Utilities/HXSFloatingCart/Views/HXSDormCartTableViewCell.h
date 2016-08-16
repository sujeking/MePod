//
//  HXSDormCartTableViewCell.h
//  store
//
//  Created by chsasaw on 15/3/7.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSFloatingCartEntity.h"
#import "HXSDormCountSelectView.h"

@class HXSDormCartTableViewCell;

@protocol HXSDormCartTableViewCellDelegate <NSObject>

@required

- (void)dormCartCell:(HXSDormCartTableViewCell *)cell
          udpateItem:(NSNumber *)itemIDNum
            quantity:(NSNumber *)quantityNum;

- (void)dormCartCell:(HXSDormCartTableViewCell *)cell
       udpateProduct:(NSString *)productIDStr
            quantity:(NSNumber *)quantityNum;

@end


@interface HXSDormCartTableViewCell : UITableViewCell<HXSDormCountSelectViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel                        *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel                        *errorInfo;
@property (nonatomic, weak) IBOutlet HXSDormCountSelectView         *countView;
@property (nonatomic, weak) IBOutlet UILabel                        *amountLabel;

@property (nonatomic, copy) NSNumber                                *itemId;
@property (nonatomic, copy) NSString                                *productIDStr;
@property (nonatomic, assign) id<HXSDormCartTableViewCellDelegate>  cartCellDelegate;

- (void)setCartItem:(HXSFloatingCartEntity *)item;

@end
