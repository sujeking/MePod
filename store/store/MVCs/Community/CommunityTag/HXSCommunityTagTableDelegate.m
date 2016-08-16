//
//  HXSCommunityTagViewController.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityTagTableDelegate.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityTopicListViewController.h"
#import "HXSCommunityOthersCenterViewController.h"
#import "HXSSchoolPostListViewController.h"
#import "HXSCommunityPhotosBrowserViewController.h"
#import "HXSLoginViewController.h"
#import "HXSCommunityReportViewController.h"

// Views
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityFootrCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSShareView.h"
#import "HXSCommunityH5Cell.h"
#import "HXSNoDataView.h"

// Model
#import "HXSCommunityModel.h"
#import "HXSPost.h"
#import "HXSPost+PostH5.h"
#import "HXSCommunityTagModel.h"
#import "HXSCommunityTopicsModel.h"

#define CommunityHeadCell               @"HXSCommunityHeadCell"
#define CommunityContentTextCell        @"HXSCommunityContentTextCell"
#define CommunityFootrCell              @"HXSCommunityFootrCell"
#define CommunityImageCell              @"HXSCommunityImageCell"
#define CommunityH5Cell                 @"HXSCommunityH5Cell"


#define ShareDefultImageURL             @"http://community-59store.img-cn-hangzhou.aliyuncs.com/e5ff26c9250d4274be5c79a3bc370252.png"

typedef NS_ENUM(NSInteger, CommunityBody)
{
    CommunityBody_Head          = 0,
    CommunityBody_Content_Text  = 1,
    CommunityBody_Content_Img   = 2,
    CommunityBody_Foot          = 3,
};

static const NSInteger SINGLE_ROW_NUMS = 4;//rows nums

@interface HXSCommunityTagTableDelegate ()<UITableViewDataSource,
                                           UITableViewDelegate,
                                           HXSCommunityContentTextCellDelegate,
                                           UIScrollViewDelegate,
                                           HXSCommunityPhotosBrowserViewControllerDelegate>

@property (nonatomic, weak) UIViewController * superViewContrller;
@property (nonatomic, weak) UITableView  *tableView;

@property (nonatomic, assign) CGFloat        lastOffSet;
@property (nonatomic, strong) HXSShareView   *shareView;
@property (nonatomic, assign) NSInteger      indexPage;// 第几页  从1开始
@property (nonatomic, strong) NSMutableArray *postsArray;// 帖子数量
@property (nonatomic, assign) BOOL           hasMore;
@property (nonatomic, assign) BOOL           isLoading;

@end

@implementation HXSCommunityTagTableDelegate

#pragma mark -
- (void)loadDataFromServerWith:(HXSPostListType)type topicId:(NSString *)topicId siteId:(NSString *)siteId userId:(NSNumber *)userId
{
    _type    = type;
    _topicId = topicId;
    _siteId  = siteId;
    _userId = userId;
    _hasMore = YES;
    _isLoading = NO;
}

- (void)initData
{
    if(self.indexPage == 0) {
        self.indexPage = 1;
        [self getTopicListFromServer];
    }
}

- (void)loadMore
{
    if(self.hasMore) {
        [self getTopicListFromServer];
    }
    else
    {
        [self.tableView.infiniteScrollingView stopAnimating];
        [MBProgressHUD hideHUDForView:self.superViewContrller.view animated:YES];
    }
}

- (BOOL) hasMore
{
    return _hasMore;
}

- (void)reload
{
    self.indexPage = 1;
    
    [self getTopicListFromServer];
}


/**
 *  从服务器获取列表
 */
- (void)getTopicListFromServer
{
    if(_isLoading) {
       return;
    }
    
    _isLoading = YES;
    
    __weak typeof(self) weakSelf = self;
    [HXSCommunityModel getCommunityPostListWithType:self.type
                                            topicId:self.topicId
                                             siteId:self.siteId
                                             userId:self.userId
                                               page:@(self.indexPage)
                                           complete:^(HXSErrorCode code, NSString *message, NSArray *posts, NSString *shareLinkStr) {
                                               
                                               [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:YES];
                                               
                                               [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                               
                                               [weakSelf.tableView endRefreshing];

                                               if (code == kHXSNoError) {
                                                   
                                                   weakSelf.shareLink = shareLinkStr;
                                                   if (posts.count == 0) {
                                                       weakSelf.hasMore = NO;
                                                       
                                                   } else {
                                                       
                                                       if(weakSelf.indexPage == 1) {
                                                           [weakSelf.postsArray removeAllObjects];
                                                       }
                                                       
                                                       [weakSelf.postsArray addObjectsFromArray:posts];
                                                       weakSelf.indexPage ++;
                                                       weakSelf.hasMore = YES;
                                                   }
                                                 
                                                   
                                               } else {
                                                   
                                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.tableView status:message afterDelay:3];
                                               }
                                               
                                               weakSelf.isLoading = NO;
                                               [weakSelf.tableView reloadData];
                                           }];

}

#pragma mark  - init Methods

- (void)initWithTableView:(UITableView *)tableView superViewController:(UIViewController *)superViewController
{
    self.superViewContrller = superViewController;
    self.tableView = tableView;
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityHeadCell bundle:nil]
          forCellReuseIdentifier:CommunityHeadCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityContentTextCell bundle:nil]
          forCellReuseIdentifier:CommunityContentTextCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityH5Cell bundle:nil]
         forCellReuseIdentifier:CommunityH5Cell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityFootrCell bundle:nil]
          forCellReuseIdentifier:CommunityFootrCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:CommunityImageCell bundle:nil]
          forCellReuseIdentifier:CommunityImageCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSNoDataView class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSNoDataView class])];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245/255.0f green:246/255.0f blue:247/255.0f alpha:1]];
    
    [self.tableView setTableFooterView:[UIView new]];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsArray.count > 0 ? [self.postsArray count] * SINGLE_ROW_NUMS : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.postsArray.count == 0) {
        HXSNoDataView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSNoDataView class])
                                                                     forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSInteger row = indexPath.row;
    
    HXSPost *postEntity = self.postsArray[row / SINGLE_ROW_NUMS];
    
    if (row % SINGLE_ROW_NUMS == CommunityBody_Head) {
        
        if(_type == HXSPostListTypeOther)
        {
            UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"xxx"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
            }
            return cell;
        }
        
        HXSCommunityHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityHeadCell
                                                                     forIndexPath:indexPath];
        cell.postEntity = postEntity;
        
        cell.schoolNameLabel.hidden = self.isSchoolPost;
        
        [cell setLoadPostUserCenter:^{
            
            [weakSelf loadPostUserCenterViewController:postEntity];
        }];
        
        [cell setLoadSchoolCommunityBlock:^{
            [weakSelf loadSchoolPostViewController:postEntity];
        }];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
        
    } else if (row % SINGLE_ROW_NUMS == CommunityBody_Content_Text) {
        
        if (postEntity.postTypeIntNum.intValue == 1)
        {
            //图文混排
            HXSCommunityH5Cell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityH5Cell forIndexPath:indexPath];
            [cell setCellContentWithImageUrlStr:postEntity.firstImgUrlStr titleText:postEntity.postTitleStr];
            
            [cell setLoadCommunityH5detail:^{
                [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
            }];
            
            return cell;
        }
        
        HXSCommunityContentTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityContentTextCell
                                                                        forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.postEntity = postEntity;
      
        cell.delegate = self;
        
        //没有topicId 说明是从首页进入，那么点击话题【黄色文字】可以跳转，否则不可以
        if (self.topicId.length == 0) {
            
            [cell setLoadCommunityTopicList:^(NSInteger index) {
                [weakSelf loadCommunityTopicListViewControllerWithTopicId:postEntity.topicIdStr];
            }];
        }
        
        [cell setSelectCommunityItem:^{
            [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
        }];
        
        return cell;
        
    } else if (row % SINGLE_ROW_NUMS == CommunityBody_Content_Img) {
        
        HXSCommunityImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityImageCell
                                                                      forIndexPath:indexPath];
       
        cell.postEntity = postEntity;
        
        [cell setShowImages:^(NSMutableArray<HXSCommunitUploadImageEntity *> *uploadImageEntitys, NSInteger index,UIImageView *imageView) {
            if (index == -1) {
                return ;
            }
            [weakSelf showCommunityImagesWith:uploadImageEntitys
                                     andIndex:index
                              andTapImageView:imageView
                                andPostEntity:postEntity];
        }];
        return cell;

    } else {
        HXSCommunityFootrCell *cell = [tableView dequeueReusableCellWithIdentifier:CommunityFootrCell
                                                                      forIndexPath:indexPath];

        cell.postEntity = postEntity;
        cell.isNeedDeleteButton = self.needShowDeleteButton;
        
        [cell setLikeActionBlock:^{
          //点赞
            [weakSelf likeTheCommunity:postEntity];
        }];
        
        //回复
        [cell setReplyActionBlock:^{
            [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
//            [weakSelf loadToCommunityDetailViewController:postEntity isReplyRightNow:YES];
        }];

        //分享
        [cell setShareActionBlock:^{
            [weakSelf shareTheCommutity:postEntity];
        }];
        
        //删除
        [cell setDeleteActionBlock:^{
            [weakSelf confirmDelete:postEntity];
        }];
        
//        cell.deleteButtonWithContain.constant = 0;
//        
//        cell.deleteButtonWithTrailing.constant = 0;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(self.postsArray.count <=  indexPath.row / SINGLE_ROW_NUMS) {
        return;
    }
    HXSPost *postEntity = self.postsArray[indexPath.row / SINGLE_ROW_NUMS];
    if (postEntity.postTypeIntNum.integerValue == 0)
    {
         [self loadToCommunityDetailViewController:postEntity isReplyRightNow:NO];
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(self.postsArray.count <= 0) {
        return self.tableView.frame.size.height;
    }
    
    NSInteger row = indexPath.row;
    
    HXSPost *postEntity = self.postsArray[row / SINGLE_ROW_NUMS];
    
    if (row % SINGLE_ROW_NUMS == CommunityBody_Head) {
        if(_type == HXSPostListTypeOther)
        {
            return 0;
        }
        
        return 55;
    
    } else if(row % SINGLE_ROW_NUMS == CommunityBody_Content_Text) {

        if (postEntity.postTypeIntNum.intValue == 1)
        {
            return 54.0f;
        }
        NSString *contentText = [[postEntity topicTitleStr] stringByAppendingString:[postEntity contentStr]];
        
        CGFloat height = [HXSCommunityContentTextCell getCellHeightWithText:contentText];
        
        if(height > 14 * 6) {
        
            return 14 * 6;
        }
        return height;
    
    } else if(row % SINGLE_ROW_NUMS == CommunityBody_Content_Img){
        
        CGFloat height = 0;
        
        if ([postEntity.imagesArr count] > 3) {
            
            height = [HXSCommunityImageCell getCellHeightWithImagesCount:3];
        } else{
            
            height = [HXSCommunityImageCell getCellHeightWithImagesCount:[postEntity.imagesArr count]];
        }
        
        return height;

    }else{
        
        return 40;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //DLog(@"%ld%ld", (long)indexPath.row, (long)indexPath.section);
    if(indexPath.row / SINGLE_ROW_NUMS == self.postsArray.count - 1) {
        [self loadMore];
    }
}

#pragma mark - Target Action

/**
 *  进入帖子详情页面
 *
 *  @param model
 */
-(void)loadToCommunityDetailViewController:(id)model isReplyRightNow:(BOOL)isReply
{
    if (!isReply) {
        HXSPost *postModel = (HXSPost *)model;
        if (postModel.postTypeIntNum.intValue == 1)
        {
            //H5
            NSURL *url = [NSURL URLWithString:postModel.detailLinkStr];
            UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                                       completion:nil];
            if([viewController isKindOfClass:[UIViewController class]]) {
                [self.superViewContrller.navigationController pushViewController:viewController animated:YES];
            }
        }
        else
        {
            HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:postModel.idStr replyLoad:isReply pop:nil];
            
            [self.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
        }
    } else {
        if ([HXSUserAccount currentAccount].isLogin){
            HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:((HXSPost *)model).idStr replyLoad:isReply pop:nil];
            
            [self.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
            
        } else {
            __weak typeof(self) weakSelf = self;
            
            [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{
                HXSCommunityDetailViewController *communityDetailViewController = [HXSCommunityDetailViewController createCommunityDetialVCWithPostID:((HXSPost *)model).idStr replyLoad:isReply pop:nil];
                
                [weakSelf.superViewContrller.navigationController pushViewController:communityDetailViewController animated:YES];
                
            }];
        }

    }
}

/**
 *  跳转发帖人中心
 */
- (void)loadPostUserCenterViewController:(HXSPost *)postEntity
{
    HXSCommunityOthersCenterViewController *communityOthersCenterViewController = [HXSCommunityOthersCenterViewController controllerFromXib];
    
    [communityOthersCenterViewController initCommunityOthersCenterViewControllerWithUser:postEntity.postUser];
    
    [self.superViewContrller.navigationController pushViewController:communityOthersCenterViewController animated:YES];
    
}

/**
 *  进入校园帖子列表
 */
- (void)loadSchoolPostViewController:(HXSPost *)postEntity
{
    HXSSchoolPostListViewController *schoolPostListViewController = [HXSSchoolPostListViewController controllerFromXib];
    
    [schoolPostListViewController initCommunitySchoolListViewControllerSiteName:postEntity.siteNameStr SiteId:postEntity.siteIdStr];
//    [schoolPostListViewController initCommunityOthersCenterViewControllerWithUser:postEntity.postUser];
    
    [self.superViewContrller.navigationController pushViewController:schoolPostListViewController animated:YES];
    
}

/**
 *  进入某一话题列表
 */
- (void)loadCommunityTopicListViewControllerWithTopicId:(NSString *)topicIdStr
{
    __weak typeof(self) weakSelf = self;
    
    [HXSCommunityTopicsModel getTopicInfoWithTopicId:topicIdStr complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic) {
        
        HXSCommunityTopicListViewController *communityTopicListViewController = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topic.idStr title:nil delegate:nil];
        
        [weakSelf.superViewContrller.navigationController pushViewController:communityTopicListViewController animated:YES];
    }];
}
/**
 *  分享帖子
 */
- (void)shareTheCommutity:(HXSPost *)postEntity
{
    WS(weakSelf);
    
    __block NSInteger index = [self.postsArray indexOfObject:postEntity];
    __block int shareCount = 0;

    if (self.shareView) {
        
        [self.shareView close];
        self.shareView = nil;
    }
    
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    HXSImage *imageModel =postEntity.imagesArr[0];
    
    parameter.shareTypeArr = @[@(kHXSShareTypeWechatMoments),
                               @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends),
                               @(kHXSShareTypeQQMoments),
                               @(kHXSShareTypeCopyLink)];
    
    //圈子H5贴
    if (postEntity.postTypeIntNum.intValue == 1)
    {
        parameter.titleStr = postEntity.circleNameStr;
        parameter.textStr = postEntity.postTitleStr;
        parameter.imageURLStr = postEntity.firstImgUrlStr.length == 0 ? ShareDefultImageURL:postEntity.firstImgUrlStr;
        parameter.shareURLStr = postEntity.shareLinkStr;
    }
    else
    {
            //圈子普通贴
        if (postEntity.circleNameStr.length > 0)
        {
            parameter.titleStr = postEntity.circleNameStr;
        }
        else
        {
            //校园普通贴
            parameter.titleStr = @"59社区";
        }
        parameter.textStr = postEntity.contentStr;
        parameter.imageURLStr = imageModel.urlStr.length == 0 ? ShareDefultImageURL:imageModel.urlStr;
        parameter.shareURLStr = postEntity.shareLinkStr;
    }

    self.shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
    [self.shareView show];
    
    [HXSCommunityTagModel communityAddShareWithPostId:postEntity.idStr
                                             complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                                 
                                                 shareCount = [dic[@"share_count"] intValue];
                                                 postEntity.shareCountLongNum = @(shareCount);
                                                 [weakSelf.postsArray replaceObjectAtIndex:index withObject:postEntity];
                                                 [weakSelf.tableView reloadData];
                                             }];
}

/**
 *  点赞
 */
- (void)likeTheCommunity:(HXSPost *)post
{
    __block NSInteger index = [self.postsArray indexOfObject:post];
    __block int likeCount = 0;
    if ([HXSUserAccount currentAccount].isLogin){
        
        __weak typeof(self) weakSelf = self;
        
        [HXSCommunityTagModel communityAddLikeWithPostId:post.idStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic)
        {
            if (code == kHXSNoError) {
                
                likeCount = [dic[@"like_count"] intValue];
                
                post.isLikeIntNum = @(1);
                
                post.likeCountLongNum = @(likeCount);
                
                [weakSelf.postsArray replaceObjectAtIndex:index withObject:post];
                
                [weakSelf.tableView reloadData];
            }
        }];
        
    }else{
        
        [HXSLoginViewController showLoginController:self.superViewContrller loginCompletion:^{

        }];
    }
}

/**
 *  删除帖子
 *
 *  @param entity
 */
- (void)confirmDelete:(HXSPost *)entity
{
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                      message:@"确定删除吗?"
                                                              leftButtonTitle:@"取消"
                                                            rightButtonTitles:@"确定"];
    __weak __typeof(self) weakSelf = self;
    alertView.rightBtnBlock = ^{
        [weakSelf deleteTheMyPostNetworkingWithPostEntity:entity];
    };
    
    [alertView show];
}

/**
 *  删除帖子网络操作
 *
 *  @param postEntity
 */
- (void)deleteTheMyPostNetworkingWithPostEntity:(HXSPost *)postEntity
{
    WS(weakSelf);
    
    [MBProgressHUD showInView:_superViewContrller.view];
    [HXSCommunityModel communityDeletePostWithPostId:postEntity.idStr
                                            complete:^(HXSErrorCode code, NSString *message, NSNumber *result_status)
     {
         [MBProgressHUD hideHUDForView:weakSelf.superViewContrller.view animated:NO];
         if(code == kHXSNoError && result_status)
         {
             [weakSelf deleteTheSelectCellWithEntity:postEntity];
         }
         else
         {
             if (weakSelf.superViewContrller.view)
                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.superViewContrller.view status:message afterDelay:1.5];
         }
     }];
}

/**
 *  删除指定cell
 *
 *  @param entity
 */
- (void)deleteTheSelectCellWithEntity:(HXSPost *)entity
{
    [self.postsArray removeObject:entity];
    
    [self.tableView reloadData];
}

/**
 *  显示图片
 *
 *  @param uploadImageEntitys
 *  @param index
 *  @param tapImageView
 *  @param postEntity
 */
- (void)showCommunityImagesWith:(NSMutableArray<HXSCommunitUploadImageEntity *> *)uploadImageEntitys
                       andIndex:(NSInteger)index
                andTapImageView:(UIImageView *)tapImageView
                  andPostEntity:(HXSPost *)postEntity
{
    HXSCommunityPhotosBrowserViewController *communityPhotosBrowserViewController = [HXSCommunityPhotosBrowserViewController controllerFromXibWithModuleName:@"PhotosBrowse"];
    [communityPhotosBrowserViewController setTheOriginImageView:tapImageView];    
    [communityPhotosBrowserViewController initCommunityPhotosBrowserWithImageParamArray:uploadImageEntitys
                                                                               andIndex:index
                                                                                andType:kCommunitPhotoBrowserTypeViewImage];
    [communityPhotosBrowserViewController setThePostEntity:postEntity];
    communityPhotosBrowserViewController.delegate = self;
    
    [self.superViewContrller.tabBarController addChildViewController:communityPhotosBrowserViewController];
    [self.superViewContrller.tabBarController.view addSubview:communityPhotosBrowserViewController.view];
    [communityPhotosBrowserViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.superViewContrller.tabBarController.view);
    }];
    [communityPhotosBrowserViewController didMoveToParentViewController:self.superViewContrller.tabBarController];
}


/**
 *  刷新某条cell
 *
 *  @param entity
 */
- (void)refreshTheSelectCellWithEntity:(HXSPost *)entity
{
    NSInteger section = [_postsArray indexOfObject:entity];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:section];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark HXSCommunityContentTextCellDelegate

- (void)reportTheContentWithEntity:(HXSPost *)postEntity
{
    if ([HXSUserAccount currentAccount].isLogin)
    {
        HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
        [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:postEntity.idStr];
        [_superViewContrller.navigationController pushViewController:reportVC animated:YES];
    }else
    {
        [HXSLoginViewController showLoginController:_superViewContrller loginCompletion:^{
            HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
            [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:postEntity.idStr];
            [_superViewContrller.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}

- (void)copyTheContentWithEntity:(HXSPost *)postEntity
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = postEntity.contentStr;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]];
    [MBProgressHUD showInView:_superViewContrller.view
                   customView:imageView
                       status:@"复制成功"
                   afterDelay:0.5];
}

- (void)deleteTheContentWithEntity:(HXSPost *)postEntity
{
    [self confirmDelete:postEntity];
}


#pragma Mark HXSCommunityPhotosBrowserViewControllerDelegate

- (void)reportThePhotoWithEntity:(HXSPost *)entity
{
    if ([HXSUserAccount currentAccount].isLogin)
    {
        HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
        [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:entity.idStr];
        [_superViewContrller.navigationController pushViewController:reportVC animated:YES];
    }else
    {
        [HXSLoginViewController showLoginController:_superViewContrller loginCompletion:^{
            HXSCommunityReportViewController *reportVC = [HXSCommunityReportViewController controllerFromXib];
            [reportVC initCommunityReportViewControllerWithType:kHXSCommunityReportTypePost andWithID:entity.idStr];
            [_superViewContrller.navigationController pushViewController:reportVC animated:YES];
        }];
    }
}

#pragma mark - Get Set Methods

- (NSMutableArray *)postsArray
{
    if (!_postsArray) {
        _postsArray = [[NSMutableArray alloc] init];
    }
    
    return _postsArray;
}


@end
