//
//  HXSCommunitReplyTopicTableViewCell.m
//  store
//
//  Created by J006 on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunitReplyTopicTableViewCell.h"

@interface HXSCommunitReplyTopicTableViewCell()

@property (nonatomic, strong) HXSCommunityCommentEntity *commentEntity;
@property (weak, nonatomic) IBOutlet UILabel            *contentLabel;

@end

@implementation HXSCommunitReplyTopicTableViewCell

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

- (void)initCommunitReplyTopicTableViewCellWithEntity:(HXSCommunityCommentEntity *)commentEntity
{
    _commentEntity = commentEntity;
    [_contentLabel setText:@""];
    if(!_commentEntity.postOwner)
        return;
    
    NSMutableString *contentStr = [[NSMutableString alloc]initWithString:@""];
    [contentStr appendString:[_commentEntity.postOwner userNameStr]];
    [contentStr appendString:@"的帖子: "];
    [contentStr appendString:_commentEntity.postContentStr];
    [_contentLabel setText:contentStr];
}

@end
