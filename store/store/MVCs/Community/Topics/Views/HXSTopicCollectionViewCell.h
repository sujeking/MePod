//
//  HXSTopicCollectionViewCell.h
//  store
//
//  Created by 格格 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSTopic.h"

// 云印店 配送类型
typedef NS_ENUM(NSInteger,TopicCollectionViewCellEditType){
    TopicCollectionViewCellEditTypeAdd      = 1,// 添加关注
    TopicCollectionViewCellEditTypeDelete   = 2 // 取消关注
};

@protocol HXSTopicCollectionViewCellDelegate <NSObject>

-(void)editButtonClicked:(HXSTopic *)topic TditType:(TopicCollectionViewCellEditType)editType;

@end


@interface HXSTopicCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) HXSTopic *topic;
@property(nonatomic, assign) BOOL ifEditing; // 是否处在编辑状态
@property(nonatomic, assign) TopicCollectionViewCellEditType editType;
@property(nonatomic, weak) id<HXSTopicCollectionViewCellDelegate> delegate;


@end
