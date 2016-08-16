//
//  HXSDormItemTableViewCell.h
//  store
//
//  Created by chsasaw on 14/12/7.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSHorizontalLine.h"
#import "HXSDormItem.h"

@class HXSDormItemTableViewCell;
@class HXSClickEvent;

@protocol HXSDormItemTableViewCellDelegate <NSObject>

- (void)dormItemTableViewCellDidShowDetail:(HXSDormItemTableViewCell *)cell;
- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event;

- (void)updateCountOfRid:(NSNumber *)countNum inItem:(HXSDormItem *)item;

@end

@interface  HXSDormItemTableViewCell: UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView * imageImageVeiw;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * priceLabel;
@property (nonatomic, weak) IBOutlet UILabel * originPriceLabel;
@property (nonatomic, weak) IBOutlet UIView * promotionLabelsContainer;
@property (nonatomic, weak) IBOutlet UILabel * rightCornerLabel;
@property (weak, nonatomic) IBOutlet UILabel *restStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UILabel *soldCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

/**constent*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelHeightConstraint;

@property (nonatomic, weak) id<HXSDormItemTableViewCellDelegate> delegate;

- (void)setItem:(HXSDormItem *)item dormStatus:(HXSShopStatus)status;

@end