//
//  HXSHXSCommunityFootrCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityFootrCell.h"
#import "NSDate+Extension.h"
#import "HXSUserAccount.h"
#import "UIButton+HXSUIButoonHitExtensions.h"

@implementation HXSCommunityFootrCell

- (void)awakeFromNib {

    
    [self.likeButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.shareButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.commentButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    self.deleteButtonWithContain.constant = 0;
    self.deleteButtonWithTrailing.constant = 0;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  点赞操作
 *
 *  @param sender
 */
- (IBAction)likeTheCommunityAction:(id)sender
{
    if (self.likeActionBlock) {
        self.likeActionBlock();
    }
}

/**
 *  回复操作
 *
 *  @param sender
 */
- (IBAction)replyTheCommunityAction:(id)sender
{
    if (self.replyActionBlock) {
        self.replyActionBlock();
    }
}

/**
 *  分享操作
 *
 *  @param sender
 */
- (IBAction)shareTheCommunityAction:(id)sender
{
    if (self.shareActionBlock) {
        self.shareActionBlock();
    }
    
}
- (IBAction)deleteTheCommunityAction:(id)sender
{
    if (self.deleteActionBlock) {
        self.deleteActionBlock();
    }
}

- (void)setIsNeedDeleteButton:(BOOL)isNeedDeleteButton
{
    if (!isNeedDeleteButton) {
        self.deleteButtonWithContain.constant = 0;
        self.deleteButtonWithTrailing.constant = 0;
    }
}


- (void)setPostEntity:(HXSPost *)postEntity 
{
    NSNumber *userId = [[HXSUserAccount currentAccount] userID];
    
    if ([userId isEqual:postEntity.postUser.uidNum]) {
        self.deleteButtonWithContain.constant = 16;
        self.deleteButtonWithTrailing.constant = 16;
    } else {
        self.deleteButtonWithContain.constant = 0;
        self.deleteButtonWithTrailing.constant = 0;
    }
    
    NSInteger timelong = [postEntity.createTimeLongNum integerValue];
    
    self.timeLabel.text = [self updateTimeForRow:timelong];
    
    NSInteger isLike = [postEntity.isLikeIntNum intValue];
    
    NSInteger likeCount    = [postEntity.likeCountLongNum integerValue];
    NSInteger commentCount = [postEntity.commentCountLongNum integerValue];
    NSInteger shareCount   = [postEntity.shareCountLongNum integerValue];
    
    if (likeCount == 0) {

        [self.likeButton setTitle:@"点赞" forState:UIControlStateNormal];

    } else {
        if(likeCount > 1000000)
        {
            [self.likeButton setTitle:[NSString stringWithFormat:@"100万+"] forState:UIControlStateNormal];
        }
        else if(likeCount == 1000000)
        {
            [self.likeButton setTitle:[NSString stringWithFormat:@"100万"] forState:UIControlStateNormal];
        }
        else if(likeCount >= 10000)
        {
            [self.likeButton setTitle:[NSString stringWithFormat:@"%zd万",likeCount/10000] forState:UIControlStateNormal];
        }
        else
        {
            [self.likeButton setTitle:[NSString stringWithFormat:@"%zd",likeCount] forState:UIControlStateNormal];
        }
        
    }

    //
    if (commentCount == 0)
    {
        [self.commentButton setTitle:@"回复" forState:UIControlStateNormal];
        
    }
    else
    {
        if(commentCount > 1000000)
        {
            [self.commentButton setTitle:[NSString stringWithFormat:@"100万+"] forState:UIControlStateNormal];
        }
        else if(commentCount == 1000000)
        {
            [self.commentButton setTitle:[NSString stringWithFormat:@"100万"] forState:UIControlStateNormal];
        }
        else if(commentCount >= 10000)
        {
            [self.commentButton setTitle:[NSString stringWithFormat:@"%zd万",commentCount/10000] forState:UIControlStateNormal];
        }
        else
        {
            [self.commentButton setTitle:[NSString stringWithFormat:@"%zd",commentCount] forState:UIControlStateNormal];
        }
    }

    
    if (shareCount == 0)
    {
        
        [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
        
    }
    else
    {
        if(shareCount > 1000000)
        {
            [self.shareButton setTitle:[NSString stringWithFormat:@"100万+"] forState:UIControlStateNormal];
        }
        else if(shareCount == 1000000)
        {
            [self.shareButton setTitle:[NSString stringWithFormat:@"100万"] forState:UIControlStateNormal];
        }
        else if(shareCount >= 10000)
        {
            [self.shareButton setTitle:[NSString stringWithFormat:@"%zd万",shareCount/10000] forState:UIControlStateNormal];
        }
        else
        {
            [self.shareButton setTitle:[NSString stringWithFormat:@"%zd",shareCount] forState:UIControlStateNormal];
        }

    }

    
    if (isLike == 1) {

        self.likeButton.userInteractionEnabled = NO;
        [self.likeButton setImage:[UIImage imageNamed:@"ic_dianzan_selected"] forState:UIControlStateNormal];

    } else {
        
        self.likeButton.userInteractionEnabled = YES;
        [self.likeButton setImage:[UIImage imageNamed:@"ic_dianzan_normal"] forState:UIControlStateNormal];
    }
    
    [self addButtonHotClick];
}

#pragma mark private method

/**
 *  增加各个按钮的热点
 */
- (void)addButtonHotClick
{
    [_likeButton    setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
    [_commentButton setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
    [_shareButton   setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
    [_deleteButton  setHitTestEdgeInsets:UIEdgeInsetsMake(-5, -5, -5, -5)];
}



//日期转换显示
- (NSString *)updateTimeForRow:(NSInteger)timeInterval
{
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes < 60) {
        if(minutes == 0){
            
            return @"刚刚";
        } else {
            
            return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        }
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    
    //秒转天数
    NSInteger days = time/3600/24;
    if(days >= 6)
        return @"6天前";
    else
        return [NSString stringWithFormat:@"%ld天前",(long)days];
}



@end
