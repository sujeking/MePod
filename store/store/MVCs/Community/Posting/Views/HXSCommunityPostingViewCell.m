//
//  HXSCommunityPostingViewCell.m
//  store
//
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityPostingViewCell.h"

@interface HXSCommunityPostingViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView                    *iconImageView;//icon图标
@property (weak, nonatomic) IBOutlet UILabel                        *titleLabel;//请选择话题,学校
@property (weak, nonatomic) IBOutlet UIView *splitLine;
@property (nonatomic, readwrite) HXSCommunityPostTopicOrSchoolType  type;
@end

@implementation HXSCommunityPostingViewCell

#pragma mark life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark init

- (void)initHXSCommunityPostingViewCellWithType:(HXSCommunityPostTopicOrSchoolType)type
                                   andWithTitle:(NSString *)title;
{
    _type = type;
    UIImage *iconImage;
    switch (type)
    {
        case kHXSCommunityPostTopicOrSchoolTypeTopic:
        {
            iconImage = [UIImage imageNamed:@"ic_topic"];
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSeparatorStyleNone;
            self.splitLine.hidden = YES;
            [_titleLabel setText:@"请选择话题"];
            [_titleLabel setTextColor:[UIColor colorWithWhite:0.400 alpha:1.000]];

            break;
        }
        case kHXSCommunityPostTopicOrSchoolTypeSchool:
        {
            iconImage = [UIImage imageNamed:@"ic_school"];
            if(!title || [title isEqualToString:@""])
            {
                [_titleLabel setText:@"请选择学校"];
                [_titleLabel setTextColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]];
            }
            else
            {
                [_titleLabel setText:title];
                [_titleLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            }
            break;
        }
    }
    [_iconImageView setImage:iconImage];
}

@end
