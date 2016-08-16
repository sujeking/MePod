//
//  HXSCommunitCommentTopicTableViewCell.m
//  store
//
//  Created by J006 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitCommentTopicTableViewCell.h"
#import "UIButton+HXSUIButoonHitExtensions.h"

@interface HXSCommunitCommentTopicTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;//话题图标按钮
@property (weak, nonatomic) IBOutlet UIButton *topicButton;//话题文字按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;//右边按钮:删除或者回复

@property (nonatomic ,strong) HXSCommunityCommentEntity                 *commentEntity;
@property (nonatomic ,assign) CommunitCommentTopicTableViewCellType     type;

@end

@implementation HXSCommunitCommentTopicTableViewCell

#pragma mark life cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark init 

- (void)initCommunitCommentTopicTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity
                                            andWithType:(CommunitCommentTopicTableViewCellType)type
{
    _commentEntity = commentEntity;
    _type          = type;
    
    switch (type)
    {
        case kCommunitCommentTopicTableViewCellTypeMyReply:
        {
            [_rightButton setImage:[UIImage imageNamed:@"ic_delete_small"] forState:UIControlStateNormal];
            break;
        }
        case kCommunitCommentTopicTableViewCellTypeReplyForMe:
        {
            [_rightButton setImage:[UIImage imageNamed:@"ic_huifu"] forState:UIControlStateNormal];
            break;
        }
    }
    [_rightButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];//增加触摸热点范围
    
    [_topicButton setTitle:commentEntity.topicTitleStr forState:UIControlStateNormal];
}

#pragma mark Button Action

/**
 *  跳转到话题
 *
 *  @param sender
 */
- (IBAction)jumpToTopicAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmJumpToTopic:)])
    {
        [self.delegate confirmJumpToTopic:_commentEntity];
    }
}

/**
 *  右边按钮操作,目前为删除和回复
 *
 *  @param sender 
 */
- (IBAction)rightButtonAction:(id)sender
{
    switch (_type)
    {
        case kCommunitCommentTopicTableViewCellTypeMyReply:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDelete:)])
            {
                [self.delegate confirmDelete:_commentEntity];
            }
            break;
        }
        case kCommunitCommentTopicTableViewCellTypeReplyForMe:
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(confirmJumpToTopic:)])
            {
                [self.delegate confirmReply:_commentEntity];
            }
            break;
        }
    }
}

@end
