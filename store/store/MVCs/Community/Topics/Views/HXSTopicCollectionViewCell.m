//
//  HXSTopicCollectionViewCell.m
//  store
//
//  Created by 格格 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTopicCollectionViewCell.h"

@interface HXSTopicCollectionViewCell()

@property(nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property(nonatomic, weak) IBOutlet UIButton *editButton;

@end

@implementation HXSTopicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 8;
    self.contentView.clipsToBounds = YES;
}


-(void)setTopic:(HXSTopic *)topic{
    _topic = topic;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:topic.bigImageStr]];
}

-(void)setIfEditing:(BOOL)ifEditing{
    _ifEditing = ifEditing;
    if(_ifEditing)
        _editButton.hidden = NO;
    else
        _editButton.hidden = YES;
}

-(void)setEditType:(TopicCollectionViewCellEditType)editType{
    _editType = editType;
    if( TopicCollectionViewCellEditTypeAdd == editType)
        [ _editButton setBackgroundImage:[UIImage imageNamed:@"ic_follow_add"] forState:UIControlStateNormal];
    else
        [ _editButton setBackgroundImage:[UIImage imageNamed:@"ic_follow_cancel"] forState:UIControlStateNormal];
}

-(IBAction)editButtonClicked:(id)sender{
    [self.delegate editButtonClicked:self.topic TditType:self.editType];
}

@end
