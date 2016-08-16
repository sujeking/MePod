//
//  HXSCommunityHeadCellTableViewCell.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityHeadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@implementation HXSCommunityHeadCell

- (void)awakeFromNib {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    
    self.userIconImageView.layer.cornerRadius = self.userIconImageView.bounds.size.width/2;
    self.userIconImageView.layer.masksToBounds = YES;
    
    self.userIconImageView.userInteractionEnabled = YES;
    self.userNickNameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapUserGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPostUserCenterAction)];
    UITapGestureRecognizer *tapUserNicknameGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPostUserCenterAction)];
    
    UITapGestureRecognizer *tapSchoolNameGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadSchoolCommunity)];

    UITapGestureRecognizer *tapUserNameGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadPostUserCenterAction)];
    
    
    [self.userNickNameLabel addGestureRecognizer:tapUserNameGestureRecognizer];
    
    self.schoolNameLabel.userInteractionEnabled = YES;
    [self.schoolNameLabel addGestureRecognizer:tapSchoolNameGestureRecognizer];
    [self.userIconImageView addGestureRecognizer:tapUserGestureRecognizer];
    [self.userNickNameLabel addGestureRecognizer:tapUserNicknameGestureRecognizer];
}

/**
 *  跳转贴主中心
 */
- (void)loadPostUserCenterAction {
    
    if (self.loadPostUserCenter) {
        
        self.loadPostUserCenter();
    }
}

- (void)loadSchoolCommunity {
    
    if (self.postEntity.siteNameStr.length > 0)
    {
        if (self.loadSchoolCommunityBlock) {
            
            self.loadSchoolCommunityBlock();
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)setPostEntity:(HXSPost *)postEntity {
 
    _postEntity = postEntity;
    
    NSString *userNickNameStr         = postEntity.postUser.userNameStr;

    HXSCommunityCommentUser *postUser = postEntity.postUser;
    NSString *userAvatarStr           = postUser.userAvatarStr;
    self.userNickNameLabel.text       = userNickNameStr;
    
    
    if (postEntity.siteNameStr.length > 0)
    {
        self.schoolNameLabel.text = postEntity.siteNameStr;
    }
    else
    {
        if (postEntity.circleNameStr > 0)
        {
            self.schoolNameLabel.text = postEntity.circleNameStr;
        }
    }
    
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userAvatarStr]
                              placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
    
    //是否为官方
    if ([postEntity.isOficialIntNum boolValue]) {
        
        self.officialImageView.hidden = NO;
        self.officialImageView.image = [UIImage imageNamed:@"ic_guanfang"];
    } else {
        
        self.officialImageView.hidden = YES;
    }
}



@end



