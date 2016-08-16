//
//  HXSCommunitReplyContentTableViewCell.m
//  store
//
//  Created by J006 on 16/4/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitReplyContentTableViewCell.h"
#import "HXSUITapImageView.h"
#import "NSDate+Extension.h"
#import "UIImageView+HXSImageViewRoundCorner.h"
#import "TTTAttributedLabel.h"
#import "Color+Image.h"

//链接颜色
#define kLinkAttributes     @{(__bridge NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[UIColor colorWithHexString:@"0x3e688a"].CGColor}
#define kLinkAttributesActive       @{(NSString *)kCTUnderlineStyleAttributeName : [NSNumber numberWithBool:NO],(NSString *)kCTForegroundColorAttributeName : (__bridge id)[[UIColor colorWithHexString:@"0x3e688a"] CGColor]}

@interface HXSCommunitReplyContentTableViewCell()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) HXSCommunityCommentEntity *entity;
@property (weak, nonatomic) IBOutlet HXSUITapImageView  *avatarImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton           *nameButton;//名称
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;//时间
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;//内容

@end

@implementation HXSCommunitReplyContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark init

- (void)initCommunitReplyContentTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity
{
    _entity = commentEntity;
    [_contentLabel setText:@""];
    
    __weak typeof(self) weakSelf = self;
    if(_entity.commentUser.userAvatarStr
       && ![_entity.commentUser.userAvatarStr isEqualToString:@""])
    {
        [_avatarImageView sd_setImageWithUrl:_entity.commentUser.userAvatarStr
                            placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]
                                    tapBlock:^(id tapAction)
         {
             [weakSelf jumpToSelectUserWithCommentUser:_entity.commentUser];
         } andActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
                                    complete:^(UIImage *image)
         {
            [_avatarImageView cornerRadiusForImageViewWithImage:image]; 
         }];
    }
    else
    {
        [_avatarImageView setImage:[UIImage imageNamed:@"img_headsculpture_small"]];
        [_avatarImageView addTapBlock:^(id obj)
        {
            [weakSelf jumpToSelectUserWithCommentUser:_entity.commentUser];
        }];
    }
    [_avatarImageView cornerRadiusForImageViewWithImage:_avatarImageView.image];
    
    if(_entity.commentUser.userNameStr)
    {
        [_nameButton setTitle:_entity.commentUser.userNameStr forState:UIControlStateNormal];
    }
    
    if (_entity.createTimeNum)
    {
        NSString *timeStr = [NSDate updateTimeForRow:[_entity.createTimeNum integerValue]];
        [_timeLabel setText:timeStr];
    }
    
    if(_entity.postContentStr)
    {
        switch (_entity.commentType)
        {
            case kHXSCommunityCommentTypeNoCommenter:
            {
                [_contentLabel setText:_entity.commentContentStr];
                break;
            }
            case kHXSCommunityCommentTypeHasCommenter:
            {
                [self configTheContentLabelForCommented];
                break;
            }
        }
    }
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components
{
    if ([[components objectForKey:@"actionStr"] isEqualToString:@"gotoUserVC"])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmJumpToCenter:)])
        {
            [self.delegate confirmJumpToCenter:_entity.commentedUser];
        }
    }
}

#pragma mark JumpAction

/**
 *  通知跳转到指定用户个人中心
 */
- (void)jumpToSelectUserWithCommentUser:(HXSCommunityCommentUser *)commentUser
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmJumpToCenter:)])
    {
        [self.delegate confirmJumpToCenter:commentUser];
    }
}
- (IBAction)nameButtonAction:(id)sender
{
    [self jumpToSelectUserWithCommentUser:_entity.commentUser];
}

#pragma mark private method

/**
 *  设置"回复"的回复的内容
 */
- (void)configTheContentLabelForCommented
{
    HXSCommunityCommentUser *communityCommentedUser = _entity.commentedUser;  //被评论的人
    NSString *commentedContentStr = _entity.commentedContentStr;//被回复的内容
    NSString *commentedUserNameStr = [NSString stringWithFormat:@"//回复%@:",communityCommentedUser.userNameStr];
    NSString *mainContentStr = [NSString stringWithFormat:@"%@%@%@",_entity.commentContentStr,commentedUserNameStr,commentedContentStr];
    _contentLabel.linkAttributes = kLinkAttributes;
    _contentLabel.activeLinkAttributes = kLinkAttributesActive;
    _contentLabel.delegate = self;
    [_contentLabel setText:mainContentStr];
    [_contentLabel addLinkToTransitInformation:@{@"actionStr" : @"gotoUserVC"} withRange:[mainContentStr rangeOfString:communityCommentedUser.userNameStr]];
    [_contentLabel sizeToFit];
}

@end
