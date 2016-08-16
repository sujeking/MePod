//
//  HXSPrintMainCollectionViewCell.m
//  store
//
//  Created by J006 on 16/5/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintMainCollectionViewCell.h"

@interface HXSPrintMainCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel     *contentLabel;
@property (weak, nonatomic) IBOutlet UIView      *backGroundView;

@end

@implementation HXSPrintMainCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self drawLineForTheBackGroundView];
}

#pragma mark init

- (void)initPrintMainCollectionViewCellWithEntity:(HXSMainPrintTypeEntity *)entity
{
    [_iconImageView setImage:nil];
    [_contentLabel setText:@""];
    
    if(entity.imageName) {
        [_iconImageView setImage:[UIImage imageNamed:entity.imageName]];
    }
    
    if(entity.typeName) {
        [_contentLabel  setText:entity.typeName];
    }
    
    switch (entity.printType)
    {
        case kHXSMainPrintTypeDocument:
        case kHXSMainPrintTypePhoto:
        {
            [_backGroundView setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case kHXSMainPrintTypeScan:
        case kHXSMainPrintTypeCopy:
        {
            [_backGroundView setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
}

- (void)drawLineForTheBackGroundView
{
    _backGroundView.layer.cornerRadius = 15;
    _backGroundView.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
    _backGroundView.layer.borderWidth = 1;
    [_backGroundView setClipsToBounds:YES];
}

@end
