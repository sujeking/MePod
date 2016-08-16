//
//  HXSCommunityHeadCellTableViewCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPost.h"
#import "HXSPost+PostH5.h"
/**
 *  帖子头部cell  【头像，用户名，学校】
 */
@interface HXSCommunityHeadCell : UITableViewCell
/**
 *  官方icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *officialImageView;
/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
/**
 *  学校名称
 */
@property (weak, nonatomic) IBOutlet UILabel *schoolNameLabel;
/**
 *  加载发帖人中心
 */
@property (nonatomic, copy) void (^loadPostUserCenter)();
/**
 *  加载校园帖子列表
 */
@property (nonatomic, copy) void (^loadSchoolCommunityBlock)();
@property (nonatomic, strong)HXSPost *postEntity;
@end
