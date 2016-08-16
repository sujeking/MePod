//
//  HXSDigitalMobileCommentTableViewCell.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileCommentTableViewCell.h"

#import "HXSDigitalMobileDetailEntity.h"

@interface HXSDigitalMobileCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;   // "2016-1-1"
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation HXSDigitalMobileCommentTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}


#pragma mark - Public Methods

- (void)setupCellWithEntity:(HXSDigitalMobileDetailCommentEntity *)entity
{
    // 头像
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:entity.userPortraitUrlStr] placeholderImage:[UIImage imageNamed:@"ic_defaulticon_loading"]];
    
    // 用户名
    self.userNameLabel.text = entity.userNameStr;
    
    // 时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[entity.commentTimeIntNum integerValue]];
    NSString *dateStr = [HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd"];
    self.commentTimeLabel.text = dateStr;
    
    // 地点
    self.siteNameLabel.text = entity.siteNameStr;
    
    // 内容
    self.contentLabel.text = entity.contentStr;
}

@end
