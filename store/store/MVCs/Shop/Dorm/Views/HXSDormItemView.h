//
//  HXSDormItemView.h
//  store
//
//  Created by chsasaw on 15/2/9.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSPageControl.h"
#import "HXSDormCountSelectView.h"
#import "HXSClickEvent.h"

@class HXSDormItem, HXSShopEntity;
@class HXSBoxOrderItemModel;

@protocol HXSFoodieItemPopViewDelegate <NSObject>

@optional
- (void)foodieItemUpdate:(NSNumber *)foodId quantity:(NSInteger)quantity;

- (void)boxItemUpdate:(NSString *)productIDStr quantity:(NSInteger)quantity;

@required
- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event;

@end

@interface HXSDormItemView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet HXSPageControl * pageControl;

@property (nonatomic, weak) IBOutlet HXSDormCountSelectView * countView;

@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel * descLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *descScrollView;
@property (weak, nonatomic) IBOutlet UIView *promotionLabelsContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeightConstraint;

@property (nonatomic, strong) UIImage *scrollViewPlaceHolderImage;

/**APP 3.0 以前只用于夜猫店*/
- (void)setItem:(HXSDormItem *)item shop:(HXSShopEntity *)shopEntity;

@property (nonatomic, assign) id<HXSFoodieItemPopViewDelegate>delegate;

/**APP 4.3 零食盒子*/
- (void)setBoxOrderItem:(HXSBoxOrderItemModel *)boxOrderItemModel;

@end