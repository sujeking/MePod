//
//  HXSShopActivityTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSShopActivityTableViewCell.h"
// Model
#import "HXSShopEntity.h"
// Others
#import <objc/runtime.h>

@interface HXSShopActivityTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView6;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel6;
@property (weak, nonatomic) IBOutlet UIImageView *imageView7;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel7;

@end

@implementation HXSShopActivityTableViewCell

- (void)awakeFromNib
{
    // Do nothing
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSShopEntity *)entity
{
    for (int i = 0; i < [entity.promotionsArr count]; i++) {

        HXSPromotionsEntity *activityEntity = entity.promotionsArr[i];
        NSString *imageViewStr = [NSString stringWithFormat:@"_imageView%d", (i + 1)];
        Ivar ivar = class_getInstanceVariable([self class], [imageViewStr UTF8String]);
        id imageViewObj = object_getIvar(self, ivar);
        UIImageView *imageView = (UIImageView *)imageViewObj;
        [imageView sd_setImageWithURL:[NSURL URLWithString:activityEntity.promotionImageStr]];
        
        NSString *labelStr = [NSString stringWithFormat:@"_contentLabel%d", (i + 1)];
        Ivar labelIvar = class_getInstanceVariable([self class], [labelStr UTF8String]);
        id lableObj = object_getIvar(self, labelIvar);
        UILabel *label = (UILabel *)lableObj;
        label.text = activityEntity.promotionNameStr;

        NSString *colorStr = [activityEntity.promotionColorStr substringFromIndex:1];
        unsigned int hexValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:colorStr];
        [scanner setScanLocation:0];
        [scanner scanHexInt:&hexValue];
    }
}

@end
