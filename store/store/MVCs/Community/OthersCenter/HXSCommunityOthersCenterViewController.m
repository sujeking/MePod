//
//  HXSCommunityOthersCenterViewController.m
//  store
//
//  Created by ArthurWang on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPost.h"

// Controllers
#import "HXSCommunityOthersCenterViewController.h"
#import "HXSCommunityTopicListViewController.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityTagTableDelegate.h"

// Views
#import "UINavigationBar+AlphaTransition.h"
#import "HXSProfileCenterHeaderView.h"
#import "HXSShareView.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityFootrCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSCommunitOtherCenterFooterView.h"

// Model
#import "HXSCommunityModel.h"
#import "HXSCommunityTagModel.h"
#import "HXSCommunityTopicsModel.h"



static const CGFloat    HEADERVIEW_HEIGHT = 240;            // 默认顶部高度
static const CGFloat    DEFAULT_IP6HEIGHT = 667;            // ip6高度
static const CGFloat    NAVIGATION_STATUSBAR_HEIGHT = 64;   // 顶部NavigationBar高度
static const CGFloat    NAVBAR_CHANGE_POINT = 20;

#define headerViewHeightResize HEADERVIEW_HEIGHT * SCREEN_HEIGHT / DEFAULT_IP6HEIGHT // 适配当前机型的顶部高度

typedef NS_ENUM(NSInteger, CommunityOthersProfileSection)
{
    kCommunityOthersProfileSectionHeader   = 0,
    kCommunityOthersProfileSectionContent  = 1,
};

@interface HXSCommunityOthersCenterViewController ()

@property (weak, nonatomic  ) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) HXSCommunityCommentUser      *userEntity;
@property (nonatomic, strong) HXSCommunityTagTableDelegate *delegate;

@end

@implementation HXSCommunityOthersCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialNavigation];
    [self initTableView];
    [self initCommunityTagTableDelegate];
    [self.navigationController.navigationBar at_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar at_setTitleAlpha:0.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self changeNavigationBarWithScrollView:_mainTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar at_reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark init

- (void)initialNavigation
{
    [self.navigationItem setRightBarButtonItem:nil];
    
    [self.navigationItem setTitle:_userEntity.userNameStr];
}

- (void)initTableView
{
    [self.delegate initWithTableView:self.mainTableView superViewController:self];
    __weak typeof(self) weakSelf = self;
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.delegate loadMore];
    }];
    [_mainTableView removeRefreshHeader];
}

- (void)initCommunityOthersCenterViewControllerWithUser:(HXSCommunityCommentUser *)user
{
    _userEntity = user;
    [self.delegate loadDataFromServerWith:HXSPostListTypeOther topicId:nil siteId:nil userId:user.uidNum];
}

/**
 *  初始化帖子列表
 */
- (void)initCommunityTagTableDelegate
{
    [self.delegate initData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + [self.delegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if(section == 0)
    {
        rows = 0;
    }
    else
    {
        rows = [self.delegate tableView:tableView numberOfRowsInSection:section];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"xxx"];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xxx"];
        }
        return cell;
    }
    else
    {
        return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 0;
    }
    else
    {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    if(section == 0)
    {
        height = headerViewHeightResize;
    }
 
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        HXSProfileCenterHeaderView *headerProfileView = [HXSProfileCenterHeaderView profileCenterHeaderView];
        [headerProfileView initTheProfileCenterHeaderViewWithUserType:HXSCommunityProfileUserTypeOthers
                                                          andWithUser:_userEntity];
        return headerProfileView;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeNavigationBarWithScrollView:scrollView];
}

#pragma mark private methods

- (void)changeNavigationBarWithScrollView:(UIScrollView *)scrollView
{
    if (self.navigationController.topViewController != self)
    {
        return;
    }
    
    UIColor * color = HXS_MAIN_COLOR;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + NAVIGATION_STATUSBAR_HEIGHT - offsetY) / NAVIGATION_STATUSBAR_HEIGHT));
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [self.navigationController.navigationBar at_setTitleAlpha:alpha];
    }
    else
    {
        [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:0]];
        [self.navigationController.navigationBar at_setTitleAlpha:0];
    }
}

#pragma mark - Get Set Methods
- (HXSCommunityTagTableDelegate *)delegate
{
    if(_delegate == nil)
    {
        _delegate = [[HXSCommunityTagTableDelegate alloc] init];
    }
    
    return _delegate;
}

@end
