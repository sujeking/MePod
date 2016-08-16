//
//  HXSCommunityTagViewController.h
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  帖子列表代理
 */

@interface HXSCommunityTagTableDelegate : NSObject<UITableViewDataSource,
                                                    UITableViewDelegate,
                                                    UIScrollViewDelegate>

/** 帖子分类 */
@property (nonatomic, assign) HXSPostListType type;
/** 话题id */
@property (nonatomic, strong) NSString *topicId;
/** 学校id */
@property (nonatomic, strong) NSString *siteId;
/**分享整个话题回调 */
@property (nonatomic, strong) NSString *shareLink;
/** 用户id */
@property (nonatomic, strong) NSNumber *userId;
/** 是否为校园帖子 */
@property (nonatomic, assign) BOOL isSchoolPost;
/** 是否显示删除帖子按钮 */
@property (nonatomic, assign) BOOL needShowDeleteButton;

/**
 *  服务器获取帖子列表
 *
 *  @param type    帖子分类
 *  @param topicId 话题id【没有的话代表首页给的默认列表】
 *  @param siteId  学校id【没有的话代表首页给的默认列表】
 */
-(void)loadDataFromServerWith:(HXSPostListType)type
                      topicId:(NSString *)topicId
                       siteId:(NSString *)siteId
                       userId:(NSNumber *)userId;

// 初始化，tableview
- (void)initWithTableView:(UITableView *)tableView superViewController:(UIViewController *)superViewController;

// 加载数据的方法
- (void)initData;
- (void)loadMore;
- (BOOL)hasMore;
- (void)reload;

@end
