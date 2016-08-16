//
//  HXSCommunityTopicListViewController.m
//  store
//
//  Created by  黎明 on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

//External Lib
#import <Masonry.h>

//ViewControllers
#import "HXSCommunityTopicListViewController.h"
#import "HXSLoginViewController.h"
#import "HXSCommunityTagViewController.h"
#import "HXSCommunityPostingViewController.h"

//data Model
#import "HXSTopic.h"
#import "HXSCommunityTopicsModel.h"

//subviews
#import "HXSelectionControl.h"
#import "HXSTopicIntroView.h"
#import "HXSPostButton.h"
#import "HXSShareView.h"
#import "HXSLoadingView.h"


#define SELECTCONTROLHRIGHT 44

typedef NS_ENUM(NSInteger, TopicList)
{
    TopicList_Top    = 0,
    TopicList_Bottum = 1
};

NSString * const TopicTagTitleHot = @"热门";
NSString * const TopicTagTitleAll = @"全部";


@interface HXSCommunityTopicListViewController ()<UITableViewDataSource,UITableViewDelegate,PostButtonDelegate>

@property (nonatomic, strong) NSMutableArray               *childViewControllerDelegates;
@property (nonatomic, strong) HXSCommunityTagTableDelegate *currentTableViewDelegate; // 当前显示的ViewController
@property (nonatomic, assign) NSInteger                    currentSelectIndex;

@property (nonatomic, strong) NSMutableDictionary          *contentOffsets;

@property (weak, nonatomic  ) IBOutlet UITableView        *mTableView;
@property (nonatomic, strong) UIView             *tableHeaderView;
@property (nonatomic, strong) HXSelectionControl *selectionControl;
@property (nonatomic, strong) HXSTopicIntroView  *topicIntroView;

@property (nonatomic, strong) HXSShareView *shareView;
@property (nonatomic, strong) HXSTopic     *topic;
@property (nonatomic, strong) NSString     *topicIDStr;

@property(nonatomic, weak) id<HXSCommunityTopicListDelegate> delegate;

@property (nonatomic, strong) NSString *titleStr;

@end

@implementation HXSCommunityTopicListViewController


#pragma mark - Public Methods

+ (instancetype)createCommunityTopicListVCWithTopicID:(NSString *)topicIDStr
                                                title:(NSString *)titleStr
                                             delegate:(id<HXSCommunityTopicListDelegate>)delegate
{
    HXSCommunityTopicListViewController *communityTopicListViewController = [HXSCommunityTopicListViewController controllerFromXib];
    
    communityTopicListViewController.topicIDStr = topicIDStr;
    communityTopicListViewController.delegate   = delegate;
    communityTopicListViewController.titleStr   = titleStr;
    
    return communityTopicListViewController;
}


#pragma mark - Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPostButtonOnView];
    
    [self topicIfFollowed];
    
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.topicIntroView.followTopicButton addTarget:self
                                              action:@selector(followButtonClicked)
                                    forControlEvents:UIControlEventTouchUpInside];
    
    WS(weakSelf);
    
    [self.mTableView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf.currentTableViewDelegate loadMore];
    }];
    
    [self.mTableView addRefreshHeaderWithCallback:^{
        
        [weakSelf.currentTableViewDelegate reload];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    self.delegate = nil;
}


#pragma mark - somme thing init

- (void)registerCommunityTopicUpdateNotice {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommunityTopicUpdate" object:nil];
}

- (void)setTopic:(HXSTopic *)topic {
    
    _topic = topic;
    [self.topicIntroView.topicIconImageView  sd_setImageWithURL:[NSURL URLWithString:_topic.smallImageStr]
                                               placeholderImage:nil];
    self.topicIntroView.topicIntroLabel.text = _topic.introStr;
    [self.topicIntroView setIsFollowThisTopic:topic.isFollowedIntNum.intValue == HXSTopicFollowTypeFollowed?YES:NO];
}

- (void)setupPostButtonOnView
{
    HXSPostButton *postButton = [[HXSPostButton alloc] init];
    [postButton setDelegate:self];
    postButton.alpha = 0;
    
    CGFloat RightMargin = 15;
    CGFloat BottomMargin = 15;
    
    CGFloat x = SCREEN_WIDTH - CGRectGetWidth(postButton.frame)/2 - RightMargin;
    CGFloat y = SCREEN_HEIGHT - CGRectGetWidth(postButton.frame)/2 - BottomMargin - 64;
    
    postButton.center = CGPointMake(x, y);

    [self.view addSubview:postButton];
    
    [UIView animateWithDuration:1 animations:^{
        
        postButton.alpha = 1;
    }];
}


#pragma mark - Target Action
- (void)followButtonClicked {
    WS(weakSelf);
    if ([HXSUserAccount currentAccount].isLogin) {
        
        [weakSelf followTopicOrNot];
    } else {
        
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            
            [weakSelf.delegate refreshTopicList];
            [weakSelf registerCommunityTopicUpdateNotice];
            [MBProgressHUD showInView:weakSelf.view];
            
            [HXSCommunityTopicsModel getTopicInfoWithTopicId:weakSelf.topic.idStr
                                                    complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic) {
                                                        
                                                        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                        if(kHXSNoError == code) {
                                                            // 状态相等，改变
                                                            if(weakSelf.topic.isFollowedIntNum.integerValue == topic.isFollowedIntNum.integerValue) {
                                                                
                                                                [weakSelf followTopicOrNot];
                                                            } else {
                                                                
                                                                weakSelf.topic = topic;
                                                            }
                                                        }else{
                                                            
                                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1];
                                                        }
                                                    }];
        }];
    }
}

- (void)followTopicOrNot {
    
    WS(weakSelf);
    [MBProgressHUD showInView:self.view];
    int follow = self.topic.isFollowedIntNum.intValue == HXSTopicFollowTypeUnFollowed ? HXSTopicFollowTypeFollowed:HXSTopicFollowTypeUnFollowed;
    [HXSCommunityTopicsModel followTopicWithTopicId:self.topic.idStr followOrNot:@(follow)
                                           complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic) {
                                               
                                               [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                               
                                               if(kHXSNoError == code) {
                                                   weakSelf.topic = topic;
                                                   [weakSelf.delegate refreshTopicList];
                                                   [weakSelf registerCommunityTopicUpdateNotice];
                                               } else {
                                                   
                                                   [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1];
                                               }
                                           }];
}

- (void)topicIfFollowed
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    
    [HXSCommunityTopicsModel getTopicInfoWithTopicId:self.topicIDStr complete:^(HXSErrorCode code, NSString *message, HXSTopic *topic) {
        
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(kHXSNoError == code) {
            weakSelf.topic = topic;
            
            [weakSelf.mTableView reloadData];
            
            [weakSelf setupNavigationBar];
            
            [weakSelf setupChildViewDelegate];
        } else {
            [HXSLoadingView showLoadFailInView:weakSelf.view
                                         block:^{
                                             [weakSelf topicIDStr];
                                         }];
        }
    }];
}

#pragma mark  - setup Subviews

/**
 *  设置导航栏
 */
- (void)setupNavigationBar
{
    self.navigationItem.title = (0 < [self.titleStr length]) ? self.titleStr : self.topic.titleStr;
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_fenxiangBig"]
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(shareItemClickAction)];


    
    self.navigationItem.rightBarButtonItem = postItem;
}

/**
 *  设置子ViewController
 */

- (void)setupChildViewDelegate
{
    HXSCommunityTagTableDelegate *hotCommunityTagViewDelegate         = [[HXSCommunityTagTableDelegate alloc]init];
    HXSCommunityTagTableDelegate *reCommendedCommunityTagDelegate = [[HXSCommunityTagTableDelegate alloc]init];
    
    [hotCommunityTagViewDelegate loadDataFromServerWith:HXSPostListTypeHot
                                                  topicId:self.topic.idStr
                                                   siteId:@"0"
                                                   userId:nil];
    
    [reCommendedCommunityTagDelegate loadDataFromServerWith:HXSPostListTypeAll
                                                          topicId:self.topic.idStr
                                                           siteId:@"0" userId:nil];

    
    [hotCommunityTagViewDelegate initWithTableView:self.mTableView superViewController:self];
    [reCommendedCommunityTagDelegate initWithTableView:self.mTableView superViewController:self];

    [self.childViewControllerDelegates addObjectsFromArray:@[hotCommunityTagViewDelegate,
                                                             reCommendedCommunityTagDelegate,
                                                             ]];
        
    self.currentSelectIndex = 0;
    self.currentTableViewDelegate = hotCommunityTagViewDelegate;
    [self.currentTableViewDelegate initData];
    
}

- (void)selectItemAction:(HXSelectionControl *)sender {
    
    NSInteger index = sender.selectedIdx;
    
    self.currentSelectIndex = index;
    self.currentTableViewDelegate = self.childViewControllerDelegates[index];
    [self.currentTableViewDelegate initData];
    [self.mTableView reloadData];
    
    
    
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self saveOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    [self saveOffset];
}

- (void)tableView:(UITableView *)tableView scrollToOffSet:(CGPoint)point {
    
    [tableView setContentOffset:point animated:YES];
}

- (void)saveOffset
{
    //保存当前tab对应的位置
    NSString * title = [NSString stringWithFormat:@"%ld", (long)self.currentSelectIndex];
    [self.contentOffsets setObject:[NSNumber numberWithInteger:self.mTableView.contentOffset.y] forKey:title];
    DLog(@"%@, == %f", title, self.mTableView.contentOffset.y);
}



/**
 *  分享整个话题
 */
- (void)shareItemClickAction
{
    
    if (self.shareView) {
        
        [self.shareView close];
        self.shareView = nil;
    }
    
    HXSShareParameter *parameter = [[HXSShareParameter alloc] init];
    
    
    parameter.shareTypeArr = @[@(kHXSShareTypeWechatMoments),
                               @(kHXSShareTypeWechatFriends),
                               @(kHXSShareTypeQQFriends),
                               @(kHXSShareTypeQQMoments),
                               @(kHXSShareTypeCopyLink)];
    parameter.titleStr = self.topic.titleStr;
    parameter.textStr = self.topic.introStr;
    parameter.imageURLStr = self.topic.smallImageStr;
    parameter.shareURLStr = self.currentTableViewDelegate.shareLink;
    self.shareView = [[HXSShareView alloc] initShareViewWithParameter:parameter callBack:nil];
    [self.shareView show];
}

#pragma mark  - UITableViewDataSource && UITableViewDelegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    } else {
        
        return [self.currentTableViewDelegate tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (section == 1) {
        
        return [self.currentTableViewDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
     
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if (section == 1) {
        
        return [self.currentTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == TopicList_Top) {
    
        return 72;
    }
    return SELECTCONTROLHRIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == TopicList_Top) {
        
        return self.tableHeaderView;
    }
    return self.selectionControl;
}

#pragma mark PostButtonDelegate

- (void)postButtonClickAction
{
    if ([HXSUserAccount currentAccount].isLogin){
        HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
        [communityPostingViewController setTopicId:self.topic.idStr topicName:self.topic.titleStr];
        [self.navigationController pushViewController:communityPostingViewController animated:YES];
    }else{
        [HXSLoginViewController showLoginController:self loginCompletion:^{
            HXSCommunityPostingViewController *communityPostingViewController = [[HXSCommunityPostingViewController alloc] initWithNibName:NSStringFromClass([HXSCommunityPostingViewController class]) bundle:nil];
            [self.navigationController pushViewController:communityPostingViewController animated:YES];
        }];
    }
}

#pragma mark - Get Set Methods
- (NSMutableArray *)childViewControllerDelegates {
    
    if (!_childViewControllerDelegates) {
        
        _childViewControllerDelegates = [NSMutableArray array];
    }
    return _childViewControllerDelegates;
}

- (HXSelectionControl *)selectionControl {
    
    if (!_selectionControl) {
        
        _selectionControl = [[HXSelectionControl alloc] init];
        [_selectionControl setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), SELECTCONTROLHRIGHT)];
        [_selectionControl setTitles:@[TopicTagTitleHot, TopicTagTitleAll]];
        [_selectionControl addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
        [_selectionControl setSelectedIdx:0];
    }
    return _selectionControl;
}

-(HXSTopicIntroView *)topicIntroView {
    if(!_topicIntroView) {
        
        _topicIntroView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSTopicIntroView class])
                                                        owner:nil
                                                      options:nil].firstObject;
        
    }
    return _topicIntroView;
}

- (UIView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
        [_tableHeaderView addSubview:self.topicIntroView];
        [self.topicIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(72);
        }];
    }
    return _tableHeaderView;
}

- (NSMutableDictionary *)contentOffsets {
    
    if (!_contentOffsets) {
        _contentOffsets = [NSMutableDictionary dictionary];
    }
    return _contentOffsets;
}


@end
