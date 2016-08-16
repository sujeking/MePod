//
//  HXSPrintSelfDeliveryInfoCell.m
//  store
//
//  Created by 格格 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintSelfDeliveryInfoCell.h"

@interface HXSPrintSelfDeliveryInfoCell()

/** 发货方式 */
@property(nonatomic,weak) IBOutlet UILabel *sendTypeNameLabel;
/** 配送方式说明 */
@property(nonatomic,weak) IBOutlet UILabel *descriptionLabel;
@property(nonatomic,weak) IBOutlet UIButton *selectButton;

@end

@implementation HXSPrintSelfDeliveryInfoCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setupDeliveryEntity:(HXSDeliveryEntity *)deliveryEntity indexPath:(NSIndexPath *)indexPath
{
    
    _indexPath = indexPath;
    _deliveryEntity = deliveryEntity;
    
    self.sendTypeNameLabel.text = deliveryEntity.sendTypeIntNum.intValue == HXSPrintDeliveryTypeSelf?@"上门自取":@"";
    
    self.descriptionLabel.text = nil!=deliveryEntity.descriptionStr ? deliveryEntity.descriptionStr : @"";
}

- (void)setIfSelected:(BOOL)ifSelected
{
    if(ifSelected) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
}

- (IBAction)selectButtonClicked:(id)sender
{
    [self.cellDelegate selectButtonClicked:self.indexPath];
}

@end
