//
//  HXSCommunittyItemLikeTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunittyItemLikeTableViewCell.h"
#import "HXSPost.h"
@implementation HXSCommunittyItemLikeTableViewCell

- (void)awakeFromNib
{

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupSubViews];
}

-(void)setupSubViews
{
    
    for (UIImageView *iv in self.contentView.subviews) {
        if (iv.tag == -1) {
            iv.image = [UIImage imageNamed:@"ic_dianzan_selected"];
        }
        
        iv.layer.cornerRadius = CGRectGetHeight(iv.bounds) / 2;
        
        iv.layer.masksToBounds = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLikeListArr:(NSArray *)likeListArr
{
    if ([likeListArr count] == 0) {
        return;
    }
    
    NSInteger likeCount = 0;
    
    if([likeListArr count] >= 28)
    {
        likeCount = 28;
    }
    else
    {
        likeCount = [likeListArr count];
    }
    
    for (int i = 0;i < likeCount; i++) {

        HXSLike *likeEntity = likeListArr[i];
        
        HXSCommunityCommentUser *likeUser = likeEntity.likeUser;
        
        UIImageView *imageView = [self.contentView viewWithTag:i + 1];

        [imageView sd_setImageWithURL:[NSURL URLWithString:likeUser.userAvatarStr]
                         placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];

    }
}

+ (CGFloat)getHeightForLikeCount:(NSInteger)count
{
    CGFloat    height = 150;
    
    if (count >= 28) {
    } else if (count == 0) {
    
        height = height / 4.0;
        
    } else {

        height = ((count + 6) / 7) / 4.0 * height;

    }
    
    return height ;
}


@end
