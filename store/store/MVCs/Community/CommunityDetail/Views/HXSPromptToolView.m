//
//  HXSPromptToolView.m
//  store
//
//  Created by  黎明 on 16/4/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPromptToolView.h"



static CGFloat const LabelPadding = 8.0f;
static CGFloat const LabelFontSize = 8.0f;


@implementation HXSPromptToolView

- (void)awakeFromNib
{
    [self setupSubViews];
}

/**
 *  设置子控件以及样式
 */
- (void)setupSubViews
{
    [self setUserInteractionEnabled:YES];
    
    self.backgroundColor           = [UIColor clearColor];
    self.likeView.backgroundColor  = [UIColor clearColor];
    self.replyView.backgroundColor = [UIColor clearColor];
    self.shareView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapLikegr,*tapReplygr,*tapSharegr;
    
    tapLikegr  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLikeViewAction:)];
    tapReplygr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReplyViewAction:)];
    tapSharegr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShareViewAction:)];

    [self.likeView  addGestureRecognizer:tapLikegr];
    [self.replyView addGestureRecognizer:tapReplygr];
    [self.shareView addGestureRecognizer:tapSharegr];
    
    self.likeIconImageView.layer.cornerRadius  = 20.0f;
    self.replyIconImageView.layer.cornerRadius = 20.0f;
    self.shareIconImageView.layer.cornerRadius = 20.0f;
    
    self.likeNumberLabel.layer.cornerRadius  = 8.0f;
    self.replyNumberLabel.layer.cornerRadius = 8.0f;
    self.shareNumberLabel.layer.cornerRadius = 8.0f;
    
    self.likeIconImageView.layer.masksToBounds  = YES;
    self.replyIconImageView.layer.masksToBounds = YES;
    self.shareIconImageView.layer.masksToBounds = YES;
    
    self.likeNumberLabel.layer.masksToBounds  = YES;
    self.replyNumberLabel.layer.masksToBounds = YES;
    self.shareNumberLabel.layer.masksToBounds = YES;
    
    self.likeIconImageView.backgroundColor  = [UIColor redColor];
    self.replyIconImageView.backgroundColor = [UIColor greenColor];;
    self.shareIconImageView.backgroundColor = [UIColor yellowColor];
    
    self.likeNumberLabel.hidden = YES;
    self.replyNumberLabel.hidden = YES;
    self.shareNumberLabel.hidden = YES;
}


/**
 *  点击“点赞”
 *
 *  @param sender
 */
- (void)tapLikeViewAction:(UITapGestureRecognizer *)sender
{
    if (self.likeTheCommunity) {
        self.likeTheCommunity();
    }
}

/**
 *  点击“回复”
 *
 *  @param sender
 */
- (void)tapReplyViewAction:(UITapGestureRecognizer *)sender
{
    if (self.commentTheCommunity) {
        self.commentTheCommunity();
    }
}

/**
 *  点击"分享"
 *
 *  @param sender
 */
- (void)tapShareViewAction:(UITapGestureRecognizer *)sender
{
    if (self.shareTheCommunity) {
        self.shareTheCommunity();
    }
}

- (void)setShareCount:(NSNumber *)shareCount
{
    
    if (shareCount.intValue != 0) {
        self.shareNumberLabel.hidden = NO;
        
        NSInteger count = shareCount.integerValue;
        
        if (count > 1000000) {
            self.shareNumberLabel.text = [NSString stringWithFormat:@"100万+"];
        }
        else if (count == 1000000)
        {
            self.shareNumberLabel.text = [NSString stringWithFormat:@"100万"];
        }
        else if (count >= 10000)
        {
            self.shareNumberLabel.text = [NSString stringWithFormat:@"%zd万",count/10000];
        }
        else
        {
            self.shareNumberLabel.text = [NSString stringWithFormat:@"%zd",count];
        }

        
    } else {
        self.shareNumberLabel.hidden = YES;
    }
    
    self.shareWidthConstraint.constant = [self.shareNumberLabel.text length] * LabelFontSize + LabelPadding;
    [self.shareNumberLabel updateConstraints];
}

- (void)setLikeCount:(NSNumber *)likeCount
{
    if (likeCount.intValue != 0) {
        self.likeNumberLabel.hidden = NO;
       
        NSInteger count = likeCount.integerValue;
        
        if (count > 1000000) {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"100万+"];
        }
        else if (count == 1000000)
        {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"100万"];
        }
        else if (count >= 10000)
        {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"%zd万",count/10000];
        }
        else
        {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"%zd",count];
        }
        
    } else {
        self.likeNumberLabel.hidden = YES;
    }
    

    self.likeWidthConstraint.constant = [self.likeNumberLabel.text length] * LabelFontSize + LabelPadding;
    [self.likeNumberLabel updateConstraints];

}

- (void)setCommentCount:(NSNumber *)commentCount
{
    if (commentCount.intValue != 0) {
        self.replyNumberLabel.hidden = NO;
        
        NSInteger count = commentCount.integerValue;
        
        if (count > 1000000) {
            self.replyNumberLabel.text = [NSString stringWithFormat:@"100万+"];
        }
        else if (count == 1000000)
        {
            self.replyNumberLabel.text = [NSString stringWithFormat:@"100万"];
        }
        else if (count >= 10000)
        {
            self.replyNumberLabel.text = [NSString stringWithFormat:@"%zd万",count/10000];
        }
        else
        {
            self.replyNumberLabel.text = [NSString stringWithFormat:@"%zd",count];
        }


    } else {
        self.replyNumberLabel.hidden = YES;
    }
    
    self.replyWidthConstraint.constant = [self.replyNumberLabel.text length] * LabelFontSize + LabelPadding;
    [self.replyNumberLabel updateConstraints];

}

- (void)setPostEntity:(HXSPost *)postEntity
{
    int isLike = [postEntity.isLikeIntNum intValue];
    
    if (isLike == 1) {
        
        [self.likeIconImageView setImage:[UIImage imageNamed:@"ic_dianzan_plus_selected"]];
        self.likeIconImageView.userInteractionEnabled = NO;

    } else {
        self.likeIconImageView.userInteractionEnabled = YES;
        [self.likeIconImageView setImage:[UIImage imageNamed:@"ic_dianzan_plus_normal"]];
    }
    
}


@end
