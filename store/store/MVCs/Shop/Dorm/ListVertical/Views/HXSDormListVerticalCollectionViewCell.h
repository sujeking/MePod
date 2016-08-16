//
//  HXSDormListVerticalCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSDormItem.h"
#import "HXSClickEvent.h"

@class HXSDormListVerticalCollectionViewCell, HXSDormListVerticalCellEntity;

@protocol HXSDormListVerticalCollectionViewCellDelegate <NSObject>

@required
- (void)dormItemTableViewCellDidShowDetail:(HXSDormListVerticalCollectionViewCell *)cell;
- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event;

- (void)listConllectionViewCell:(HXSDormListVerticalCollectionViewCell *)cell udpateItem:(NSNumber *)cartItemIDNum quantity:(NSNumber *)quantityNum;
- (void)listConllectionViewCell:(HXSDormListVerticalCollectionViewCell *)cell addRid:(NSNumber *)ridNum quantity:(NSNumber *)quantityNum;

@end

@interface HXSDormListVerticalCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageImageVeiw;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *promotionLabelsContainer;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel * originPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UILabel *soldCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCornerLabel;

@property (weak, nonatomic) IBOutlet UILabel *restStatusLabel;


@property (nonatomic, weak) id<HXSDormListVerticalCollectionViewCellDelegate> delegate;

- (void)setItem:(HXSDormItem *)item item:(HXSDormListVerticalCellEntity *)cellEntity dormStatus:(HXSShopStatus)status;

@end
