//
//  HXSCommunityViewController.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

//External Lib
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

// Controllers
#import "HXSLoginViewController.h"
#import "HXSCommunityViewController.h"
#import "HXSCommunityMyCenterViewController.h"
#import "HXSCommunityPostingViewController.h"
#import "HXSCommunityMessageViewController.h"
#import "HXSCommunityTopicViewController.h"
#import "HXSCommunityTopicListViewController.h"

// Views
#import "HXSelectionControl.h"
#import "HXSLocationCustomButton.h"
#import "HXSLocationManager.h"
#import "HXSCommunityNitifacationCell.h"
#import "HXSMyAttentionTopicCell.h"
#import "HXSCommunityTagTableDelegate.h"
#import "HXSBannerLinkHeaderView.h"
#import "HXSPostButton.h"

// Model
#import "HXSShopViewModel.h"
#import "HXSCommunityModel.h"
#import "HXSCommunityTopicsModel.h"


static NSString * const kMyattentiontopiccell      = @"HXSMyAttentionTopicCell";
static NSString * const kCommunitynitifacationcell = @"HXSCommunityNitifacationCell";
static NSString * const kGetnoticemsg              = @"kGetnoticemsg";
static CGFloat const kSelectcontrolhright = 44;
static CGFloat const kMsgcellrowheight    = 60;

NSString * const CommunityTitle     = @"59社区";
NSString * const CommunityTagHot    = @"热门";
NSString * const CommunityTagFocus  = @"关注";
NSString * const CommunityTagCampus = @"校园";
NSString * const CommunityTagAll    = @"全部";

//社区主页section结构
typedef NS_ENUM(NSInteger, CommunityHomeSection) {
    CommunityHomeSection_Notification  = 0,
    CommunityHomeSection_CommunityItem = 1,
    //总个数
    CommunityHomeSection_Count         = 2
};
//标签选择
typedef NS_ENUM(NSInteger, CommunityTagIndex) {
    CommunityTagIndex_Hot    = 0,
    CommunityTagIndex_Focus  = 1,
    CommunityTagIndex_Campus = 2,
    CommunityTagIndex_All    = 3
};


//社区消息数量
typedef NS_ENUM(NSInteger, MSGCOUNT) {
    MSGCOUNT_MoreThanHundred  = 99,
    MSGCOUNT_MoreThanThousand = 999,
};

@interface HXSCommunityViewController ()<UITableViewDataSource,
                                        UITableViewDelegate,
                                        HXSBannerLinkHeaderViewDelegate,
                                        PostButtonDelegate>

@property (nonatomic, strong) HXSelectionControl  *selectionControl;
@property (nonatomic, strong) NSMutableArray      *followedTopics;//已关注按的话题
@property (nonatomic, strong) NSMutableArray      *childViewTableDelegates;
@property (nonatomic, strong) NSMutableDictionary * contentOffsets;

//推送消息
@property (nonatomic, strong) NSString *msgBadgeValue;//消息条数
@property (nonatomic, strong) NSString *msgContent;//消息内容
@property (nonatomic, strong) NSString *msgIconURL;//消息图片

@property (nonatomic, strong) HXSCommunityTagTableDelegate *currentTableViewDelegate;//当前显示的ViewController
@property (nonatomic, strong) HXSLocationManager           *locationManager;
@property (nonatomic, strong) HXSCommunityTopicsModel      *topicModel;//话题Model

//banner
@property (nonatomic, strong) HXSBannerLinkHeaderView *bannerLinkHeaderView;

@property (nonatomic, assign) NSInteger   currentSelectIndex;
@property (nonatomic, weak  ) IBOutlet UITableView *mTableView;
@property (nonatomic, copy  ) NSNumber    *currentSiteId;//学校id

@end

@implementation HXSCommunityViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self initTableview];
    
    [self initAddObserver];
    
    [self setupChildViewDelegates];
    
    [self setupPostButtonOnWindow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.currentSiteId = [[HXSLocationManager manager] currentSite].site_id;
    
    [self setupNavgationBar];
    
    [self getRecommentedTopics];
    
    [self getNewNotifacationMsgIfNew];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.currentTableViewDelegate) {
        [self.currentTableViewDelegate initData];
    }
    
}

#pragma mark - Intial Methods
/**
 *  注册通知
 */
- (void)initAddObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNoticeMsgWith:)
                                                 name:kGetnoticemsg object:nil];
}

//收到推送消息
- (void)getNoticeMsgWith:(NSNotification *)notifacation
{
    
    NSDictionary *msgDict = nil;
    if ([notifacation.object isKindOfClass:[NSString class]])
    {
        NSString *apsMsg = notifacation.object;
        NSData *data = [apsMsg dataUsingEncoding:NSUTF8StringEncoding];
        msgDict = [NSJSONSerialization JSONObjectWithData:data
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
    }
    else
    {
        msgDict = (NSDictionary *)notifacation.object;
    }
    
    NSNumber *msgNum = msgDict[@"data"][@"msg_num"];
    self.msgBadgeValue = [msgNum stringValue];
    
    if (msgNum.intValue > MSGCOUNT_MoreThanHundred) {
        [[self.tabBarController.tabBar.items objectAtIndex:kHXSTabBarCommunity] setBadgeValue:@"..."];
    } else {
        [[self.tabBarController.tabBar.items objectAtIndex:kHXSTabBarCommunity] setBadgeValue:self.msgBadgeValue];
    }
    
    if (msgNum.intValue > MSGCOUNT_MoreThanThousand) {
        self.msgContent = [NSString stringWithFormat:@"999+条新消息"];
    } else {
        self.msgContent = [NSString stringWithFormat:@"%@条新消息",self.msgBadgeValue];
    }
    
    self.msgIconURL = msgDict[@"data"][@"user_portrait"];
    [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:CommunityHomeSection_Notification] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CommunityTopicUpdate object:nil];
}

- (void)setupPostButtonOnWindow
{
    HXSPostButton *postButton = [[HXSPostButton alloc] init];
    [postButton setDelegate:self];
    postButton.alpha = 0;
    
    CGFloat margin = 15;
    CGFloat navBarHeight = 64;
    CGFloat tabBarHeight = 49;
    
    CGFloat x = SCREEN_WIDTH - CGRectGetWidth(postButton.bounds)/2 - margin;
    CGFloat y = SCREEN_HEIGHT - CGRectGetWidth(postButton.bounds)/2 - margin - tabBarHeight - navBarHeight;
    
    postButton.center = CGPointMake(x, y);
    [self.view addSubview:postButton];
    
    [UIView animateWithDuration:1 animations:^{
        
        postButton.alpha = 1;
    }];
}

#pragma mark - setup Subviews

- (void)setupNavgationBar
{
    self.navigationItem.title   = CommunityTitle;
    UIButton  *userCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    
    if ([HXSUserAccount currentAccount].isLogin) {
        HXSUserInfo *userInfo       = [HXSUserAccount currentAccount].userInfo;
        HXSUserBasicInfo *info      = userInfo.basicInfo;
        [userCenterButton sd_setBackgroundImageWithURL:[NSURL URLWithString:info.portrait] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_headsculpture_small"]];
    }else{
        [userCenterButton setBackgroundImage:[UIImage imageNamed:@"img_headsculpture_small"]
                                    forState:UIControlStateNormal];

    }

    userCenterButton.layer.cornerRadius  = 16;
    userCenterButton.layer.masksToBounds = YES;
    [userCenterButton addTarget:self
                         action:@selector(loadMyCenterViewController:)
               forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *userCenterItem = [[UIBarButtonItem alloc]
                                        initWithCustomView:userCenterButton];
    UIBarButtonItem *topicItem      = [[UIBarButtonItem alloc]
                                  initWithTitle:@"话题"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(loadMoreTopicItemSelectViewController)];
    
    self.navigationItem.leftBarButtonItem  = userCenterItem;
    self.navigationItem.rightBarButtonItem = topicItem;
    
}

- (void)initTableview
{
    WS(weakSelf);
    
    [self.mTableView setTableHeaderView:self.bannerLinkHeaderView];
    [self.mTableView registerNib:[UINib nibWithNibName:kMyattentiontopiccell bundle:nil]
          forCellReuseIdentifier:kMyattentiontopiccell];

    [self.mTableView registerNib:[UINib nibWithNibName:kCommunitynitifacationcell bundle:nil]
          forCellReuseIdentifier:kCommunitynitifacationcell];
    
    [self.mTableView addRefreshHeaderWithCallback:^{
        
        [weakSelf fetchDormentrySlide];
        [weakSelf.currentTableViewDelegate reload];
    }];
    
    [MBProgressHUD showInView:self.view];
    [self fetchDormentrySlide];
    
}

- (void)setupChildViewDelegates
{
    HXSCommunityTagTableDelegate  *hotCommunityTagTableDelegate    = [[HXSCommunityTagTableDelegate alloc] init];
    HXSCommunityTagTableDelegate  *focusCommunityTagTableDelegate  = [[HXSCommunityTagTableDelegate alloc] init];
    HXSCommunityTagTableDelegate  *AllCommunityTagTableDelegate    = [[HXSCommunityTagTableDelegate alloc] init];
    HXSCommunityTagTableDelegate  *campusCommunityTagTableDelegate = [[HXSCommunityTagTableDelegate alloc] init];
    
    [hotCommunityTagTableDelegate loadDataFromServerWith:HXSPostListTypeHot topicId:nil siteId:@"0" userId:nil];
    [focusCommunityTagTableDelegate loadDataFromServerWith:HXSPostListTypeFollow topicId:nil siteId:@"0"  userId:nil];
    [AllCommunityTagTableDelegate loadDataFromServerWith:HXSPostListTypeAll topicId:nil siteId:@"0"  userId:nil];

    [hotCommunityTagTableDelegate initWithTableView:self.mTableView superViewController:self];
    [focusCommunityTagTableDelegate initWithTableView:self.mTableView superViewController:self];
    [AllCommunityTagTableDelegate initWithTableView:self.mTableView superViewController:self];
    [campusCommunityTagTableDelegate initWithTableView:self.mTableView superViewController:self];
    
    hotCommunityTagTableDelegate.needShowDeleteButton    = NO;
    focusCommunityTagTableDelegate.needShowDeleteButton  = NO;
    AllCommunityTagTableDelegate.needShowDeleteButton    = NO;
    campusCommunityTagTableDelegate.needShowDeleteButton = NO;
    
    
    [self.childViewTableDelegates addObjectsFromArray:@[hotCommunityTagTableDelegate,
                                                        focusCommunityTagTableDelegate,
                                                        campusCommunityTagTableDelegate,
                                                        AllCommunityTagTableDelegate]];
    
    self.currentSelectIndex = 0;
    self.currentTableViewDelegate = hotCommunityTagTableDelegate;
    [self.currentTableViewDelegate initData];
}

//从服务器获取新消息
- (void)getNewNotifacationMsgIfNew
{
    if ([HXSUserAccount currentAccount].isLogin) {
        [HXSCommunityModel getCommunityNewMsgComplete:^(HXSErrorCode code, NSString *message, NSDictionary *resultDict) {
        if (resultDict) {
            
            NSNumber *msgNum = resultDict[@"count"];
            self.msgIconURL = resultDict[@"user_avatar"];
            self.msgBadgeValue = [msgNum stringValue];
            if (msgNum.intValue > MSGCOUNT_MoreThanHundred) {
                
                [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:@"..."];
            }
            else {
                [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:self.msgBadgeValue];
            }
            
            if (msgNum.intValue > MSGCOUNT_MoreThanThousand) {
                self.msgContent = [NSString stringWithFormat:@"999+条新消息"];
            }
            else {
                self.msgContent = [NSString stringWithFormat:@"%@条新消息",self.msgBadgeValue];
            }
          [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    } else {
        
        [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
    }
}

//获取推荐的话题
- (void)getRecommentedTopics
{
    WS(weakSelf);
    
    [HXSCommunityTopicsModel getCommunityRecommendTopicWithComplete:^(HXSErrorCode code, NSString *message, NSArray *topics) {
        [weakSelf.followedTopics removeAllObjects];
        [weakSelf.followedTopics addObjectsFromArray:topics];
        [weakSelf.mTableView reloadData];

    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return CommunityHomeSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == CommunityHomeSection_Notification) {
        return 1;
    } else {
        
        return [self.currentTableViewDelegate tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case CommunityHomeSection_Notification: {
            
            HXSCommunityNitifacationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunitynitifacationcell
                                                                            forIndexPath:indexPath];
            [cell initMsgContent:self.msgContent andMsgIconUrl:self.msgIconURL];
            return cell;
        }
            break;
        
        case CommunityHomeSection_CommunityItem : {
            
            return [self.currentTableViewDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    
    if (section == CommunityHomeSection_Notification) {
        if ([HXSUserAccount currentAccount].isLogin) {
            if (self.msgContent.length == 0) {
                return 0;

            } else {
                return kMsgcellrowheight;
            }
        }
        else {
            return 0;
        }
    } else {
        
        return [self.currentTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != CommunityHomeSection_CommunityItem) {
        return 0;
    } else {
        return kSelectcontrolhright;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == CommunityHomeSection_CommunityItem) {
        
        return self.selectionControl;
    }else {
        return nil;
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self saveOffset];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == CommunityHomeSection_Notification) {
            HXSCommunityMessageViewController *communityMessageViewController = [HXSCommunityMessageViewController controllerFromXib];
        
        [communityMessageViewController setCleanNotifacationMsgBlock:^{
            weakSelf.msgContent = nil;
            weakSelf.msgIconURL = nil;
            [[weakSelf.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:nil];
            
            [weakSelf.mTableView reloadData];
        }];
    
        [self.navigationController pushViewController:communityMessageViewController animated:YES];
    }else if(indexPath.section == CommunityHomeSection_CommunityItem) {
        [self.currentTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == CommunityHomeSection_CommunityItem) {
        [self.currentTableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self saveOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self saveOffset];
}

- (void)saveOffset
{
    //保存当前tab对应的位置
    NSString * title = [NSString stringWithFormat:@"%ld", (long)self.currentSelectIndex];
    [self.contentOffsets setObject:[NSNumber numberWithInteger:self.mTableView.contentOffset.y] forKey:title];
}

#pragma mark - Target Methods
-(void)selectItemAction:(HXSelectionControl *)sender
{
    NSInteger index = sender.selectedIdx;
    WS(weakSelf);
    
    self.currentSelectIndex = index;
    self.currentTableViewDelegate = self.childViewTableDelegates[index];
    [self.currentTableViewDelegate initData];
    [self.mTableView reloadData];
    
    //选择学校  如果没有选择地址  需要重新选择
    if (index == CommunityTagIndex_Campus)
    {
        self.currentSiteId = [[HXSLocationManager manager]currentSite].site_id;
        
        if(self.currentSiteId == nil)
        {
            [self.selectionControl setSelectedIdx:0];
            
            [[HXSLocationManager manager]resetPosition:PositionSite completion:^{
                
                
                weakSelf.currentSiteId = [[HXSLocationManager manager]currentSite].site_id;
                
                [weakSelf.selectionControl setSelectedIdx:2];
                
                [(HXSCommunityTagTableDelegate *)weakSelf.currentTableViewDelegate loadDataFromServerWith:HXSPostListTypeAll
                                                                                                  topicId:nil
                                                                                                   siteId:[weakSelf.currentSiteId stringValue]
                                                                                                   userId:nil];
                
                [(HXSCommunityTagTableDelegate *)weakSelf.currentTableViewDelegate reload];
            }];
        }
        else if(![[self.currentSiteId stringValue] isEqualToString:self.currentTableViewDelegate.siteId]) {
            [(HXSCommunityTagTableDelegate *)self.currentTableViewDelegate loadDataFromServerWith:HXSPostListTypeAll
                                                                                          topicId:nil
                                                                                           siteId:[self.currentSiteId stringValue]
                                                                                           userId:nil];
            
            [(HXSCommunityTagTableDelegate *)self.currentTableViewDelegate reload];
        }
        
    }
    
    NSString * title = [NSString stringWithFormat:@"%ld", (long)index];
    NSNumber * offset = [self.contentOffsets objectForKey:title];
    CGRect sectionHeader = [self.mTableView rectForHeaderInSection:1];
    if(self.mTableView.contentOffset.y < CGRectGetMinY(sectionHeader)) {
        [self.mTableView setContentOffset:self.mTableView.contentOffset animated:NO];
    }else if(offset == nil || offset.integerValue < CGRectGetMinY(sectionHeader)) {
        [self.mTableView setContentOffset:CGPointMake(0, CGRectGetMinY(sectionHeader)) animated:NO];
    }else {
        [self.mTableView setContentOffset:CGPointMake(0, offset.integerValue) animated:NO];
    }
    
    [self saveOffset];
}
/**
 *  发帖操作
 */
- (void)postItemClickAction
{
    
    if ([HXSUserAccount currentAccount].isLogin){
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }else{
        [HXSLoginViewController showLoginController:self loginCompletion:^{
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
        }];
    }
}


/**
 *  加载更多 话题选择页面
 */
- (void)loadMoreTopicItemSelectViewController
{
    HXSCommunityTopicViewController *communityTopicViewController=[[HXSCommunityTopicViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityTopicViewController class]) bundle:nil];
    
    [self.navigationController pushViewController:communityTopicViewController animated:YES];
}

/**
 *  加载我的帖子中心
 */
- (void)loadMyCenterViewController:(UIButton *)sender
{
    if ([HXSUserAccount currentAccount].isLogin) {
        HXSCommunityMyCenterViewController *communityMineCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
        [self.navigationController pushViewController:communityMineCenterViewController animated:YES];

    }else{// 点击编辑去登录，然后获取登录以后的话题状态
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSUserInfo *userInfo = [HXSUserAccount currentAccount].userInfo;
            HXSUserBasicInfo *info = userInfo.basicInfo;
            [sender sd_setBackgroundImageWithURL:[NSURL URLWithString:info.portrait] forState:UIControlStateNormal];
            
            HXSCommunityMyCenterViewController *communityMineCenterViewController = [HXSCommunityMyCenterViewController controllerFromXib];
            [self.navigationController pushViewController:communityMineCenterViewController animated:YES];
        }];
    }
}

/**
 *  加载话题列表页面
 */
- (void)loadCommunityTopicListViewController:(NSInteger)index
{
    HXSTopic *topic = self.followedTopics[index];
    
    HXSCommunityTopicListViewController *communityTopicListViewController = [HXSCommunityTopicListViewController createCommunityTopicListVCWithTopicID:topic.idStr title:nil delegate:nil];
    
    [self.navigationController pushViewController:communityTopicListViewController animated:YES];
}

#pragma mark PostButtonDelegate

//发帖
- (void)postButtonClickAction
{
    if ([HXSUserAccount currentAccount].isLogin){
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }else{
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
            [self.navigationController pushViewController:communityPostingViewController animated:YES];
        }];
    }
}


/**
 *  获取banner 图片
 */
- (void)fetchDormentrySlide
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    HXSShopViewModel *shopModel = [[HXSShopViewModel alloc] init];
    [shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSCommunityInletTop)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                              
                                              if (0 < [entriesArr count]) {
                                                  [weakSelf.bannerLinkHeaderView setSlideItemsArray:entriesArr];
                                              } else {
                                                  [weakSelf.mTableView setTableHeaderView:nil];
                                              }
                                          }];
    
}

#pragma - HXSBannerLinkHeaderViewDelegate

- (void)didSelectedLink:(NSString *)linkStr
{
    NSURL *url = [NSURL URLWithString:linkStr];
    if (nil == url) {
        url = [NSURL URLWithString:[linkStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    UIViewController *viewController = [[HXSMediator sharedInstance] performActionWithUrl:url
                                                                               completion:nil];
    if([viewController isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - Get Set Methods

- (NSMutableArray *)followedTopics
{
    if (!_followedTopics) {
        _followedTopics = [NSMutableArray array];
    }
    return _followedTopics;
}

- (NSMutableArray *)childViewTableDelegates
{
    if (!_childViewTableDelegates) {
        _childViewTableDelegates = [NSMutableArray array];
    }
    return _childViewTableDelegates;
}

- (HXSLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[HXSLocationManager alloc]init];
    }
    return _locationManager;
}

- (HXSelectionControl *)selectionControl
{
    if (!_selectionControl) {
        _selectionControl = [[HXSelectionControl alloc] init];
        [_selectionControl setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kSelectcontrolhright)];
        [_selectionControl setTitles:@[CommunityTagHot,CommunityTagFocus,CommunityTagCampus,CommunityTagAll]];
        [_selectionControl addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
        [_selectionControl setSelectedIdx:0];
    }
    return _selectionControl;
}

- (NSMutableDictionary *)contentOffsets
{
    if (!_contentOffsets) {
        _contentOffsets = [NSMutableDictionary dictionary];
    }
    return _contentOffsets;
}

- (HXSBannerLinkHeaderView *)bannerLinkHeaderView
{
    if (!_bannerLinkHeaderView) {
        _bannerLinkHeaderView = [[HXSBannerLinkHeaderView alloc] initHeaderViewWithDelegate:self];
        _bannerLinkHeaderView.eventDelegate = self;
        _bannerLinkHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
    }
    return _bannerLinkHeaderView;
}

@end
