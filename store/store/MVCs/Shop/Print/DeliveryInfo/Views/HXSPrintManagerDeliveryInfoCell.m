//
//  HXSPrintManagerDeliveryInfoCell.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintManagerDeliveryInfoCell.h"

@interface HXSPrintManagerDeliveryInfoCell()

/** 发货方式 */
@property(nonatomic,weak) IBOutlet UILabel *sendTypeNameLabel;
/** 配送费 */
@property(nonatomic,weak) IBOutlet UILabel *deliveryAmountLabel;
/** 配送方式说明 */
@property(nonatomic,weak) IBOutlet UILabel *descriptionLable;
@property(nonatomic,weak) IBOutlet UIButton *selectButton; 

@end

@implementation HXSPrintManagerDeliveryInfoCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setupDeliveryEntity:(HXSDeliveryEntity *)deliveryEntity indexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _deliveryEntity = deliveryEntity;
    
    self.sendTypeNameLabel.text = deliveryEntity.sendTypeIntNum.intValue == HXSPrintDeliveryTypeShopOwner?@"店长配送":@"";
    
    self.descriptionLable.text = deliveryEntity.descriptionStr ? deliveryEntity.descriptionStr : @"";
    
    self.deliveryAmountLabel.text = deliveryEntity.deliveryAmountDoubleNum.doubleValue > 0.00?[NSString stringWithFormat:@"￥%.2f",deliveryEntity.deliveryAmountDoubleNum.doubleValue]:@"";
}

-(void)setIfSelected:(BOOL)ifSelected
{
    if(ifSelected) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

-(IBAction)selectButtonClicked:(id)sender
{
    [self.cellDelegate selectButtonClicked:self.indexPath];
}

@end
