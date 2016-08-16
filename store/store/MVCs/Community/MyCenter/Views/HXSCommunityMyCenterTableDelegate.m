//
//  HXSCommunityMyCenterTableDelegate.m
//  store
//
//  Created by J006 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityTopicListViewController.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityOthersCenterViewController.h"

// Views
#import "HXSNoDataView.h"
#import "HXSCommunitCommentTopicTableViewCell.h"
#import "HXSCommunitReplyTopicTableViewCell.h"
#import "HXSCommunitReplyContentTableViewCell.h"

// Model
#import "HXSCommunityMyCenterTableDelegate.h"
#import "HXSCommunityCommentEntity.h"
#import "HXSCommunityMyReplyModel.h"
#import "HXSCommunityTopicsModel.h"

typedef NS_ENUM(NSInteger, CommunityMyReplyRows)
{
    kCommunityMyReplyRowsContent    = 0,//回复内容包括头像
    kCommunityMyReplyRowsReply      = 1,//主帖内容
    kCommunityMyReplyRowsTopic      = 2,//话题
};

static const NSInteger DEFAULT_PAGESIZENUM = 20;//每页20条

static const NSInteger SINGLE_ROW_NUMS = 3;//rows nums

static const NSInteger  SELECTCONTROL_HEIGHT        = 44;//"我的发帖,我的回复,回复我的"条目栏高度
static const CGFloat    HEADERVIEW_HEIGHT           = 240;//默认顶部高度
static const CGFloat    DEFAULT_IP6_HEIGHT          = 667;//ip6屏幕高度

#define headerViewHeightResize HEADERVIEW_HEIGHT * SCREEN_HEIGHT / DEFAULT_IP6_HEIGHT

@interface HXSCommunityMyCenterTableDelegate()<HXSCommunitCommentTopicTableViewCellDelegate,
                                                HXSCommunitReplyContentTableViewCellDelegate,
                                                UITableViewDataSource,
                                                UITableViewDelegate>

@property (nonatomic, weak) UIViewController                                        *superViewContrller;
@property (nonatomic, weak) UITableView                                             *tableView;
@property (nonatomic, strong) NSMutableArray<HXSCommunityCommentEntity *>           *commentsArray;
@property (nonatomic, strong) NSString                                              *currentLastCommentIDStr;
@property (nonatomic, strong) HXSCommunityMyReplyModel                              *replyMode;
@property (nonatomic, assign) NSInteger                                             type;
@property (nonatomic, assign) BOOL                                                  isLoading;

@end

@implementation HXSCommunityMyCenterTableDelegate

#pragma mark init

- (void)initWithTableView:(UITableView *)tableView
      superViewController:(UIViewController *)superViewController
              andWithType:(HXSCommunitCommentType)type;
{
    _superViewContrller = superViewController;
    _type               = type;
    _isLoading          = NO;

    [self initTheTableView:tableView];
}

- (void)initTheTableView:(UITableView *)tableView
{
    _tableView = tableView;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunitReplyTopicTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSCommunitReplyTopicTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunitCommentTopicTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSCommunitCommentTopicTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCommunitReplyContentTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSCommunitReplyContentTableViewCell class])];
}

#pragma mark Action methods

- (void)reload
{
    [self.commentsArray removeAllObjects];
    switch (_type)
    {
        case kHXSCommunitCommentTypeMyReply:
        {
            [self fetchMyRepliesNetworkingIsNew:YES isHeaderRefresher:NO];
            break;
        }
        case kHXSCommunitCommentTypeReplyToMe:
        {
            [self fetchRepliesForMeNetworkingIsNew:YES isHeaderRefresher:NO];
            break;
        }
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count > 0 ? [_commentsArray count] * SINGLE_ROW_NUMS : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_commentsArray || _commentsArray.count == 0)
    {
        HXSNoDataView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSNoDataView class])
                                                              forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell initTheHXSNoDataViewWithType:(_type+1)];
        
        return cell;
    }
    
    NSInteger row = indexPath.row;
    HXSCommunityCommentEntity *entity = [_commentsArray objectAtIndex:row / SINGLE_ROW_NUMS];
    CommunityMyReplyRows rowIndexPerSingle = row % SINGLE_ROW_NUMS;
    
    return [self createTableViewCellWithEntity:entity
                      andWithRowIndexPerSingle:rowIndexPerSingle
                              andWithTabelView:tableView
                              andWithIndexPath:indexPath];
}

#pragma mark UITableViewDelegate

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(!_commentsArray || _commentsArray.count == 0)
    {
        return SCREEN_HEIGHT - headerViewHeightResize - SELECTCONTROL_HEIGHT;
    }
    
    NSInteger row = indexPath.row;
    NSInteger rowIndexPerSingle = row % SINGLE_ROW_NUMS;
    HXSCommunityCommentEntity *entity = [_commentsArray objectAtIndex:row / SINGLE_ROW_NUMS];
    
    if(rowIndexPerSingle == kCommunityMyReplyRowsTopic)
    {
        return 46;
    }
    else if (rowIndexPerSingle == kCommunityMyReplyRowsReply)
    {
        return 46;
    }
    else
    {
        return [self checkTheEntityContentAndReturnTheCellHeight:entity];
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(!_commentsArray || _commentsArray.count == 0)
    {
        return;
    }
    
    NSInteger row = indexPath.row;
    NSInteger rowIndexPerSingle = row % SINGLE_ROW_NUMS;
    HXSCommunityCommentEntity *entity = [_commentsArray objectAtIndex:row / SINGLE_ROW_NUMS];
    
    if(rowIndexPerSingle == kCommunityMyReplyRowsReply)
    {
        [self jumpToCommunityDetailViewControllerWithPostIDStr:entity.postIDStr
                                               isReplyRightNow:NO];
    }
}

#pragma mark HXSCommunitCommentTopicTableViewCellDelegate

- (void)confirmJumpToTopic:(HXSCommunityCommentEntity *)entity
{
    [self jumpToTopicVCWithTopicID:entity.topicIDStr];
}

- (void)confirmDelete:(HXSCommunityCommentEntity *)entity
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"确定删除吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    __weak __typeof(self) weakSelf = self;
    alertView.rightBtnBlock = ^{
        [weakSelf deleteTheMyCommentNetworkingWithCommentEntity:entity];
    };
    
    [alertView show];
}

- (void)confirmReply:(HXSCommunityCommentEntity *)entity
{
    [self jumpToCommunityDetailViewControllerWithPostIDStr:entity.postIDStr isReplyRightNow:YES];
}

#pragma mark HXSCommunitReplyContentTableViewCellDelegate

- (void)confirmJumpToCenter:(HXSCommunityCommentUser *)user
{
    [self jumpToSelectUserWithUserEntity:user];
}

#pragma mark networking

/**
 *  获取我的回复网络请求
 *
 *  @param isNew             是否是重新刷新
 *  @param isHeaderRefresher 是否需要顶部刷新动画
 */
- (void)fetchMyRepliesNetworkingIsNew:(BOOL)isNew isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    NSNumber *pageSizeNum = [[NSNumber alloc]initWithInteger:DEFAULT_PAGESIZENUM];
    
    //设置最后的id参数
    NSString *tempCurrentLastID;
    if(_commentsArray
       && [_commentsArray count] > 0
       && !isNew)
    {
        tempCurrentLastID = [_commentsArray lastObject].commentIDStr;
        _currentLastCommentIDStr = tempCurrentLastID;
    }
    
    __weak typeof(self) weakSelf = self;
    if(isNew)
    {
        [MBProgressHUD showInView:_superViewContrller.view];
    }
    [self.replyMode fetchMyRepliesWithPageSize:pageSizeNum
                          andWithLastCommentID:tempCurrentLastID
                                      Complete:^(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray)
     {
         [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:NO];
         _isLoading = NO;
         if(code == kHXSNoError && entityArray)
         {
             if(isNew)
             {
                 weakSelf.commentsArray = [[NSMutableArray alloc]init];
                 [weakSelf.commentsArray addObjectsFromArray:entityArray];
             }
             else
             {
                 if(!weakSelf.commentsArray)
                     weakSelf.commentsArray = [[NSMutableArray alloc]init];
                 [weakSelf.commentsArray addObjectsFromArray:entityArray];
             }
         }
         [weakSelf.tableView reloadData];
         [[weakSelf.tableView infiniteScrollingView] stopAnimating];
         [weakSelf.tableView endRefreshing];
     }];
}

/**
 *  获取回复我的网络请求
 *
 *  @param isNew             是否是重新刷新
 *  @param isHeaderRefresher 是否需要顶部刷新动画
 */
- (void)fetchRepliesForMeNetworkingIsNew:(BOOL)isNew isHeaderRefresher:(BOOL)isHeaderRefresher
{
    if(_isLoading)
    {
        return;
    }
    _isLoading = YES;
    
    NSNumber *pageSizeNum = [[NSNumber alloc]initWithInteger:DEFAULT_PAGESIZENUM];
    
    //设置最后的id参数
    NSString *tempCurrentLastID;
    if(_commentsArray
       && [_commentsArray count] > 0
       && !isNew)
    {
        tempCurrentLastID = [_commentsArray lastObject].commentIDStr;
        _currentLastCommentIDStr = tempCurrentLastID;
    }
    
    __weak typeof(self) weakSelf = self;
    if(isNew)
    {
        [MBProgressHUD showInView:_superViewContrller.view];
    }
    [self.replyMode fetchRepliesForMeWithPageSize:pageSizeNum
                             andWithLastCommentID:tempCurrentLastID
                                         Complete:^(HXSErrorCode code, NSString *message, NSArray<HXSCommunityCommentEntity *> *entityArray)
     {
         [MBProgressHUD hideHUDForView:_superViewContrller.view animated:NO];
         _isLoading = NO;
         if(code == kHXSNoError && entityArray)
         {
             if(isNew)
             {
                 weakSelf.commentsArray = [[NSMutableArray alloc]init];
                 [weakSelf.commentsArray addObjectsFromArray:entityArray];
             }
             else
             {
                 if(!weakSelf.commentsArray)
                     weakSelf.commentsArray = [[NSMutableArray alloc]init];
                 [weakSelf.commentsArray addObjectsFromArray:entityArray];
             }
         }
         [weakSelf.tableView reloadData];
         [[weakSelf.tableView infiniteScrollingView]stopAnimating];
         [weakSelf.tableView endRefreshing];
     }];
}

/**
 *  删除评论网络操作
 *
 *  @param entity
 */
- (void)deleteTheMyCommentNetworkingWithCommentEntity:(HXSCommunityCommentEntity *)entity
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:_superViewContrller.view];
    [self.replyMode deleteTheCommentWithCommentId:entity.commentIDStr
                                        andPostId:entity.postIDStr
                                         Complete:^(HXSErrorCode code, NSString *message, NSString *statusStr)
     {
         [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:NO];
         if(code == kHXSNoError && statusStr)
         {
             [weakSelf deleteTheSelectCellWithEntity:entity];
         }
         else
         {
             if (weakSelf.superViewContrller.view)
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:1.5];
         }
     }];
}

#pragma mark JumpAction

/**
 *  跳转到话题详情
 */
- (void)jumpToTopicVCWithTopicID:(NSString *)topicID
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:_superViewContrller.view];
    [HXSCommunityTopicsModel getTopicInfoWithTopicId:topicID
                                            complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic)
     {
         [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:NO];
         if(code == kHXSNoError && topic)
         {
             HXSCommunityTopicListViewController *topicListVC = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topic.idStr title:nil delegate:nil];
             
             [weakSelf.superViewContrller.navigationController pushViewController:topicListVC animated:YES];
         }
         else
         {
             if (weakSelf.superViewContrller.view)
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:1.5];
         }
     }];
}

/**
 *  跳转到选择的用户个人信息界面
 *
 *  @param userEntity
 */
- (void)jumpToSelectUserWithUserEntity:(HXSCommunityCommentUser *)userEntity
{
    NSString *currentUserID = [[[HXSUserAccount currentAccount]userID] stringValue];
    NSString *selectUserID  = [userEntity.uidNum stringValue];
    
    if(![currentUserID isEqualToString:selectUserID])//
    {
        HXSCommunityOthersCenterViewController *othersCenterVC = [HXSCommunityOthersCenterViewController controllerFromXib];
        [othersCenterVC initCommunityOthersCenterViewControllerWithUser:userEntity];
        [self.superViewContrller.navigationController pushViewController:othersCenterVC animated:YES];
    }
}

/**
 *  进入帖子详情页面
 *
 *  @param model
 */
-(void)jumpToCommunityDetailViewControllerWithPostIDStr:(NSString *)postIDStr
                                        isReplyRightNow:(BOOL)isReply
{
    HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:postIDStr replyLoad:isReply pop:nil];
    
    [_superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
}

#pragma mark private method

/**
 *  计算内容高度从而算计出整个cell的高度
 *
 *  @param entity
 *
 *  @return
 */
- (CGFloat)checkTheEntityContentAndReturnTheCellHeight:(HXSCommunityCommentEntity *)entity
{
    NSString *contentStr;
    switch (entity.commentType)
    {
        case kHXSCommunityCommentTypeNoCommenter:
        {
            contentStr = entity.commentContentStr;
            break;
        }
        case kHXSCommunityCommentTypeHasCommenter:
        {
            HXSCommunityCommentUser *communityCommentedUser = entity.commentedUser;  //被评论的人
            NSString *commentedContentStr = entity.commentedContentStr;//被回复的内容
            NSString *commentedUserNameStr = [NSString stringWithFormat:@"//回复%@:",communityCommentedUser.userNameStr];
            contentStr = [NSString stringWithFormat:@"%@%@%@",entity.commentContentStr,commentedUserNameStr,commentedContentStr];
            break;
        }
    }
    
    CGFloat leftPadding         = 60;//左边边距
    CGFloat rightPadding        = 15;//右边边距
    CGFloat contentLabelWidth   = SCREEN_WIDTH - leftPadding - rightPadding;
    CGFloat textHeight          = [contentStr boundingRectWithSize:CGSizeMake(contentLabelWidth,MAXFLOAT)
                                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                           context:nil].size.height;
    if(textHeight > 20 * 4)//最多4行
    {
        textHeight = 20 * 4;
    }
    CGFloat totalHeight = textHeight + 55;//65为内容label上下边距之和
    
    return totalHeight;
}

/**
 *  返回合适的TableViewCell
 *
 *  @param entity
 *  @param rowIndexPerSingle
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
- (UITableViewCell *)createTableViewCellWithEntity:(HXSCommunityCommentEntity *)entity
                          andWithRowIndexPerSingle:(CommunityMyReplyRows)rowIndexPerSingle
                                  andWithTabelView:(UITableView *)tableView
                                  andWithIndexPath:(NSIndexPath *)indexPath
{
    switch (rowIndexPerSingle)
    {
        case kCommunityMyReplyRowsContent:
        {
            HXSCommunitReplyContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunitReplyContentTableViewCell class])
                                                                                         forIndexPath:indexPath];
            [cell initCommunitReplyContentTableViewCellWithEntity:entity];
            cell.delegate = self;
            return cell;
        }
        case kCommunityMyReplyRowsReply:
        {
            HXSCommunitReplyTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunitReplyTopicTableViewCell class])
                                                                                       forIndexPath:indexPath];
            
            [cell initCommunitReplyTopicTableViewCellWithEntity:entity];
            
            return cell;
        }
        case kCommunityMyReplyRowsTopic:
        {

            HXSCommunitCommentTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCommunitCommentTopicTableViewCell class])
                                                                                         forIndexPath:indexPath];
            [cell initCommunitCommentTopicTableViewCellWithEntity:entity andWithType:_type];
            cell.delegate = self;
            
            return cell;
        }
    }
}

/**
 *  删除指定cell
 *
 *  @param entity
 */
- (void)deleteTheSelectCellWithEntity:(HXSCommunityCommentEntity *)entity
{
    NSInteger index = [_commentsArray indexOfObject:entity] * SINGLE_ROW_NUMS;
    [_commentsArray removeObject:entity];
    if(_commentsArray.count == 0)
    {
        [self.tableView reloadData];
    }
    else
    {
        NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < 3; i++) //3行为一个整体
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+i inSection:0];
            [indexPathArray addObject:indexPath];
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

#pragma mark getter setter

- (HXSCommunityMyReplyModel *)replyMode
{
    if(!_replyMode)
    {
        _replyMode = [[HXSCommunityMyReplyModel alloc]init];
    }
    return _replyMode;
}

@end
