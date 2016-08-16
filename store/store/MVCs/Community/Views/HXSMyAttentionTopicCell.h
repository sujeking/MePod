//
//  HXSMyAttentionTopicCell.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSTopic.h"
/**
 *  我关注的话题Cell
 */
@interface HXSMyAttentionTopicCell : UITableViewCell
/**
 *  选择更多话题
 */
@property (nonatomic, copy) void (^loadMoreBlock)();
/**
 *  进入某一话题
 */
@property (nonatomic, copy) void (^loadTopicList)(NSInteger index);
/**
 *  话题标题UIScrollView
 */
@property (nonatomic, weak) IBOutlet UIScrollView *itamsScrollView;
/**
 *  关注话题的个数
 */
@property (nonatomic, strong) NSArray *followedTopicEntitys;
@end
