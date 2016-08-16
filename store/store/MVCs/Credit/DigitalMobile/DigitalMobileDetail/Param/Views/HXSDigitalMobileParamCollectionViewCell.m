//
//  HXSDigitalMobileParamCollectionViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileParamCollectionViewCell.h"

#import "HXSDigitalMobileParamEntity.h"

@interface HXSDigitalMobileParamCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation HXSDigitalMobileParamCollectionViewCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.contentLabel.layer.masksToBounds = YES;
    self.contentLabel.layer.cornerRadius  = 3.0f;
    self.contentLabel.layer.borderWidth   = 1.0f;
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSDigitalMobileParamPropertyValueEntity *)entity
                     status:(HXSDigitalMobileButtonStatus)status
{
    self.contentLabel.text = entity.valueNameStr;
    
    [self updateStatus:status];
}

- (void)updateStatus:(HXSDigitalMobileButtonStatus)status
{
    self.status = status;
    
    switch (status) {
        case kHXSDigitalMobileButtonStatusNormal:
        {
            self.contentLabel.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
            [self.contentLabel setBackgroundColor:[UIColor whiteColor]];
            self.contentLabel.textColor = [UIColor colorWithRGBHex:0x666666];
        }
            break;
            
        case kHXSDigitalMobileButtonStatusSelected:
        {
            self.contentLabel.layer.borderColor = [UIColor colorWithRGBHex:0x07A9FA].CGColor;
            [self.contentLabel setBackgroundColor:[UIColor colorWithRGBHex:0xF6FDFF]];
            self.contentLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        }
            break;
            
        case kHXSDigitalMobileButtonStatusUnable:
        {
            self.contentLabel.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
            [self.contentLabel setBackgroundColor:[UIColor whiteColor]];
            self.contentLabel.textColor = [UIColor colorWithRGBHex:0xE1E2E3];
        }
            break;
            
        default:
            break;
    }
}

@end
