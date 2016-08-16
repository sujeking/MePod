//
//  HXSNoticeMsgCell.m
//  store
//
//  Created by  黎明 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSNoticeMsgCell.h"
#import "HXSCommunityMessage.h"
#import "NSDate+Extension.h"
@implementation HXSNoticeMsgCell

- (void)awakeFromNib {

    [self setupSubViews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

/**
 *  设置子控件
 */
- (void)setupSubViews
{
    self.selectionStyle                           = UITableViewCellSelectionStyleNone;
    
    
    self.userProfileImageView.layer.cornerRadius  = CGRectGetHeight(self.userProfileImageView.bounds)/2;
    self.userProfileImageView.layer.masksToBounds = YES;
    
    self.communityShotContentLabel.hidden         = YES;
}

-(void)setCommunityMessage:(HXSCommunityMessage *)communityMessage{
    _communityMessage = communityMessage;
    [self.userProfileImageView sd_setImageWithURL:[NSURL URLWithString:communityMessage.guestUser.userAvatarStr] placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
    
    if(communityMessage.postCoverImgStr.length > 0){
        self.communityShotImageView.hidden = NO;
        self.communityShotContentLabel.hidden = YES;
        [self.communityShotImageView sd_setImageWithURL:[NSURL URLWithString:communityMessage.postCoverImgStr]];
    }
    else{
        self.communityShotImageView.hidden = YES;
        self.communityShotContentLabel.hidden = NO;
        self.communityShotContentLabel.text = communityMessage.postContentStr;
    }
    
    self.userProfileNameLabel.text = communityMessage.guestUser.userNameStr;
    
    if(communityMessage.typeIntNum.intValue == HXSCommunityCommentORLikeTypeLike) // 点赞
        self.replyMsgLabel.text = @"❤️";
    else
        self.replyMsgLabel.text = communityMessage.contentStr; // 评论
    
    
    self.replyTimeLabel.text = [NSDate updateTimeForRow:communityMessage.createTimeLongNum.integerValue];
}

@end
