//
//  HXSTaskDetialInfoCell.m
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskDetialInfoCell.h"

@interface HXSTaskDetialInfoCell()

@property (nonatomic, weak) IBOutlet UILabel *buyerAddressLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyerAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *buyerPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *buyerNameLabel;

@property (nonatomic, weak) IBOutlet UILabel *shopAddressLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *shopAddressLabelHeight;
@property (nonatomic, weak) IBOutlet UILabel *shopPhoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *shopBossLabel;

@property (nonatomic, weak) IBOutlet UILabel *remarkLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *remarkLabelHeight;


@end

@implementation HXSTaskDetialInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTaskOrderDetial:(HXSTaskOrderDetial *)taskOrderDetial{
    _taskOrderDetial = taskOrderDetial;
    
    _buyerAddressLabel.text = taskOrderDetial.buyerAddressStr;
    _buyerAddressLabelHeight.constant = [taskOrderDetial buyerAddressAddHeight:72] + 14;
    
    _buyerPhoneLabel.text = taskOrderDetial.buyerPhoneStr;
    _buyerNameLabel.text = taskOrderDetial.buyerNamestr;
    
    _shopAddressLabel.text = taskOrderDetial.shopAddressStr;
    _shopAddressLabelHeight.constant = [taskOrderDetial shopAddressAddHeight:72] + 14;
    
    _shopPhoneLabel.text = taskOrderDetial.shopPhoneStr;
    _shopBossLabel.text = taskOrderDetial.shopBossStr;
    
    _remarkLabel.text = taskOrderDetial.remarkStr.length > 0 ?taskOrderDetial.remarkStr : @"无";
    _remarkLabelHeight.constant = [taskOrderDetial remarkAddHeight:72] + 14;
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopPhoneClicked)];
    [self.shopPhoneLabel addGestureRecognizer:singleTap];
    self.shopPhoneLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* buyerPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyerPhoneClicked)];
    [self.buyerPhoneLabel addGestureRecognizer:buyerPhoneTap];
    self.buyerPhoneLabel.userInteractionEnabled = YES;
}

- (void)buyerPhoneClicked{
    [self.delete buyerPhoneClicked:self.taskOrderDetial];
}

- (void)shopPhoneClicked{
    [self.delete shopPhoneClicked:self.taskOrderDetial];
}

@end
