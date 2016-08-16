//
//  HXSDigitalMobileSelectionTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileSelectionTableViewCell.h"

@interface HXSDigitalMobileSelectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation HXSDigitalMobileSelectionTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupCellWithTitile:(NSString *)titleStr content:(NSString *)contentStr type:(SelectionContentType)type
{
    self.titleLabel.text       = titleStr;
    self.contentTextField.text = contentStr;
    
    if (nil == contentStr) {
        switch (type) {
            case kSelectionContentTypeAddress:
            {
                self.contentTextField.placeholder = @"请选择地址";
            }
                break;
                
            case kSelectionContentTypeParam:
            {
                self.contentTextField.placeholder = @"请选择商品属性";
            }
                break;
                
            default:
                break;
        }
    }
}


@end
