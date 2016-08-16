//
//  HXSMyOderTableViewCell.m
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyOderTableViewCell.h"

#import "HXSBoxOrderEntity.h"
#import "HXSCreditOrderEntity.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSStoreCartItemEntity.h"
#import "HXSBoxModel.h"

@implementation HXSMyOderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

#pragma mark - Public Methods

- (void)setOrderItem:(HXSOrderItem *)orderItem
{
    self.itemId = orderItem.rid;
    
    [self.titleLabel setText:orderItem.name];
    [self.priceLaebl setText:[NSString stringWithFormat:@"¥%.2f", orderItem.price.floatValue]];
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:orderItem.image_medium] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    [self.totalAmountLabel setText:[NSString stringWithFormat:@"¥%.2f", orderItem.amount.floatValue]];
    [self.quantityLabel setText:[NSString stringWithFormat:@"x%d", orderItem.quantity.intValue]];
    
    if (0 < [orderItem.specificationsStr length]) {
        [self.titleLabel setNumberOfLines:1];
        
        [self.titleDetialLabel setHidden:NO];
        self.titleDetialLabel.text = orderItem.specificationsStr;
    } else {
        [self.titleLabel setNumberOfLines:2];
        
        [self.titleDetialLabel setHidden:YES];
        self.titleDetialLabel.text = nil;
    }
}

- (void)setItemEntity:(HXSBoxOrderItemEntity *)itemEntity
{
    [self.titleLabel setText:itemEntity.name];
    [self.priceLaebl setText:[NSString stringWithFormat:@"¥%.2f", itemEntity.price.floatValue]];
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:itemEntity.img] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    [self.totalAmountLabel setText:[NSString stringWithFormat:@"¥%.2f", itemEntity.amount.floatValue]];
    [self.quantityLabel setText:[NSString stringWithFormat:@"x%d", itemEntity.quantity.intValue]];
}

- (void)setStoreItemEntity:(HXSStoreCartItemEntity *)storeItemEntity { // 云超市
    _storeItemEntity = storeItemEntity;
    self.titleLabel.text = storeItemEntity.nameStr;
    self.priceLaebl.text = [NSString stringWithFormat:@"¥%.2f", [storeItemEntity.priceNum floatValue]];
    NSString *imageUrl = [storeItemEntity.imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", [storeItemEntity.amountNum floatValue]];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%ld", [storeItemEntity.quantityNum longValue]];
}
-(void)setPrintItem:(HXSMyPrintOrderItem *)printItem{
    _printItem = printItem;
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self matchingImageView];
    self.titleLabel.text = printItem.fileNameStr ? printItem.fileNameStr:@"";
    
    self.titleDetialLabel.hidden = NO;
    self.titleDetialLabel.text = printItem.specificationsStr ? printItem.specificationsStr:@"";
    
    self.priceLaebl.text = [NSString stringWithFormat:@"￥%.2f",printItem.priceDoubleNum.doubleValue];
    [self.priceLaebl setTextColor:[UIColor colorWithRGBHex:0x999999]];
    
    self.quantityLabel.text = [NSString stringWithFormat:@"x%d",printItem.quantityIntNum.intValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",printItem.amountDoubleNum.doubleValue];
}

-(void)matchingImageView
{
    if([_printItem.fileNameStr.lowercaseString hasSuffix:@".doc"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".docx"]){
        [self.imageImageVeiw setImage:[UIImage imageNamed:@"img_print_word"]];
    }else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".pdf"]){
        [self.imageImageVeiw setImage:[UIImage imageNamed:@"img_print_pdf"]];
    }else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".pdf"]){
        [self.imageImageVeiw setImage:[UIImage imageNamed:@"img_print_pdf"]];
    }else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".ppt"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".pptx"]){
        [self.imageImageVeiw setImage:[UIImage imageNamed:@"img_print_ppt"]];
    }else if([_printItem.fileNameStr.lowercaseString hasSuffix:@".jpg"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".jpeg"]||[_printItem.fileNameStr.lowercaseString hasSuffix:@".png"]){
        [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:_printItem.originPathStr] placeholderImage:[UIImage imageNamed:@"img_print_picture"]];
    }else{
        [self.imageImageVeiw setImage:[UIImage imageNamed:@"img_print_default"]];
    }
}


- (void)setBoxOrderItemModel:(HXSBoxOrderItemModel *)boxOrderItemModel{
    
    _boxOrderItemModel = boxOrderItemModel;
    [self.titleLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
    self.titleLabel.text = boxOrderItemModel.nameStr;
    self.priceLaebl.text = [NSString stringWithFormat:@"¥%.2f", [boxOrderItemModel.priceDoubleNum floatValue]];
    NSString *imageUrl = [boxOrderItemModel.imageThumbStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.imageImageVeiw sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"img_kp_list"]];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"¥%.2f", [boxOrderItemModel.amountDoubleNum floatValue]];
    self.quantityLabel.text = [NSString stringWithFormat:@"x%ld", [boxOrderItemModel.quantityNum longValue]];
}

@end
