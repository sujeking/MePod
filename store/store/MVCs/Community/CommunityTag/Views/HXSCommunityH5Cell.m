//
//  HXSH5TableViewCell.m
//  store
//
//  Created by  黎明 on 16/7/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityH5Cell.h"
#import <SDImageCache.h>
@interface HXSCommunityH5Cell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end


@implementation HXSCommunityH5Cell

#pragma mark - Life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initCellStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected && self.loadCommunityH5detail)
    {
        self.loadCommunityH5detail();
    }
}

#pragma mark - Initial

- (void)initCellStyle
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

#pragma mark - Public Methods
- (void)setCellContentWithImageUrlStr:(NSString *)imageUrl titleText:(NSString *)text
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    self.contentLabel.text = text;
}

@end
