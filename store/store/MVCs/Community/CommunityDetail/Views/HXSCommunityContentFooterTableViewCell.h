//
//  HXSCommunityContentFooterTableViewCell.h
//  store
//
//  Created by  黎明 on 16/4/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"
/**
 *  页脚  显示时间 和按钮【6分钟以前    是自己的贴则有删除按钮】
 */

@interface HXSCommunityContentFooterTableViewCell : UITableViewCell

//发布时间
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
//帖子浏览量
@property (weak, nonatomic) IBOutlet UILabel *postBrowseCountLabel;

//删除帖子
@property (nonatomic, copy) void (^deleteCommunity)();

@property (nonatomic, strong) HXSPost *postEntity;
@end
