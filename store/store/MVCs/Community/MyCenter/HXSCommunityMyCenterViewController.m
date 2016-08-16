//
//  HXSCommunityMineCenterViewController.m
//  store
//
//  Created by J006 on 16/5/5.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCommunityMyCenterViewController.h"
#import "UINavigationBar+AlphaTransition.h"
#import "HXSelectionControl.h"
#import "HXSProfileCenterHeaderView.h"
#import "HXSCommunityMyCenterTableDelegate.h"
#import "HXSCommunityTagTableDelegate.h"

typedef NS_ENUM(NSInteger, HXSMyCenterSelectSectionIndex)
{
    kHXSMyCenterSelectSectionIndexPost       = 0,
    kHXSMyCenterSelectSectionIndexMyReply    = 1,
    kHXSMyCenterSelectSectionIndexReplyForMe = 2,
};

static const NSInteger  SELECTCONTROL_HEIGHT        = 44;       // "我的发帖,我的回复,回复我的"条目栏高度
static const CGFloat    NAVIGATION_STATUSBAR_HEIGHT = 64;       // 顶部NavigationBar高度
static const CGFloat    HEADERVIEW_HEIGHT           = 240;      // 默认顶部高度
static const CGFloat    DEFAULT_IP6_HEIGHT          = 667;      // ip6屏幕高度

#define headerViewHeightResize HEADERVIEW_HEIGHT * SCREEN_HEIGHT / DEFAULT_IP6_HEIGHT

@interface HXSCommunityMyCenterViewController ()

@property (weak, nonatomic) IBOutlet UITableView                  *mainTableView;
@property (weak, nonatomic) IBOutlet HXSelectionControl           *selectionControl;            // tag选择条栏目
@property (weak, nonatomic) IBOutlet HXSProfileCenterHeaderView   *headerView;
@property (nonatomic, strong) UIBarButtonItem                     *rightBarButtonItem;
@property (nonatomic, readwrite) NSInteger                        currentSelectIndex;           // 当前选择的栏目索引
@property (weak, nonatomic) IBOutlet NSLayoutConstraint           *headerViewHeightConstraint;  // 高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint           *headerViewTopConstraint;

@property (nonatomic, strong) NSMutableArray                      *childViewTableDelegatesArray;
@property (nonatomic, strong) HXSCommunityMyCenterTableDelegate   *myReplyDelegate;
@property (nonatomic, strong) HXSCommunityMyCenterTableDelegate   *replyForMeDelegate;
@property (nonatomic, assign) CGFloat                             defaultOffsetY;

@end

@implementation HXSCommunityMyCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeaderView];
    [self initSelectionControl];
    [self initTableView];
    [self initialNavigation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self headerViewHeightConstraintChangeWithScrollView:_mainTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem];
    
    [self.navigationController.navigationBar at_setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationItem setTitle:@"社区中心"];//

}

- (void)initSelectionControl
{
    [_selectionControl setTitles:@[@"我的发帖",@"我的回复",@"回复我的"]];
    [_selectionControl addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
    [_selectionControl setSelectedIdx:0];
}

- (void)initHeaderView
{
    _headerView = [HXSProfileCenterHeaderView profileCenterHeaderView];
    [_headerView initTheProfileCenterHeaderViewWithUserType:HXSCommunityProfileUserTypeMySelf
                                                andWithUser:nil];
    _headerViewHeightConstraint.constant = headerViewHeightResize;
    _headerViewTopConstraint.constant    = -NAVIGATION_STATUSBAR_HEIGHT;
}

- (void)initTableView
{
    _defaultOffsetY =  -(headerViewHeightResize + SELECTCONTROL_HEIGHT - NAVIGATION_STATUSBAR_HEIGHT);
    
    HXSCommunityTagTableDelegate *myPostDelegate = [[HXSCommunityTagTableDelegate alloc] init];
    NSNumber *userIdNum = [[HXSUserAccount currentAccount] userID];
    [myPostDelegate loadDataFromServerWith:HXSPostListTypeOther topicId:nil siteId:nil userId:userIdNum];
    [myPostDelegate initWithTableView:_mainTableView superViewController:self];
    
    HXSCommunityMyCenterTableDelegate *myReplyDelegate = [[HXSCommunityMyCenterTableDelegate alloc]init];
    [myReplyDelegate initWithTableView:_mainTableView superViewController:self andWithType:kHXSCommunitCommentTypeMyReply];
    
    HXSCommunityMyCenterTableDelegate *replyForMeDelegate = [[HXSCommunityMyCenterTableDelegate alloc]init];
    [replyForMeDelegate initWithTableView:_mainTableView superViewController:self andWithType:kHXSCommunitCommentTypeReplyToMe];
    
    myPostDelegate.needShowDeleteButton = YES;
    
    [self.childViewTableDelegatesArray addObject:myPostDelegate];
    [self.childViewTableDelegatesArray addObject:myReplyDelegate];
    [self.childViewTableDelegatesArray addObject:replyForMeDelegate];
    
    _currentSelectIndex = 0;
    
    [myPostDelegate initData];
    
    [_mainTableView addInfiniteScrollingWithActionHandler:^{
        switch (_currentSelectIndex)
        {
            case kHXSMyCenterSelectSectionIndexMyReply:
            {
                [myReplyDelegate fetchMyRepliesNetworkingIsNew:NO isHeaderRefresher:NO];
                break;
            }
            case kHXSMyCenterSelectSectionIndexReplyForMe:
            {
                [replyForMeDelegate fetchRepliesForMeNetworkingIsNew:NO isHeaderRefresher:NO];
                break;
            }
            default:
            {
                [myPostDelegate loadMore];
                break;
            }
            
        }
    }];
    [_mainTableView removeRefreshHeader];
    
    [_mainTableView setContentInset:UIEdgeInsetsMake(-_defaultOffsetY, 0, 0, 0)];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    switch (_currentSelectIndex)
    {
        case kHXSMyCenterSelectSectionIndexMyReply:
        case kHXSMyCenterSelectSectionIndexReplyForMe:
        {
            HXSCommunityMyCenterTableDelegate *delegate = (HXSCommunityMyCenterTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            rows = [delegate tableView:tableView numberOfRowsInSection:section];
            
        }
            break;
            
        default:
        {
            HXSCommunityTagTableDelegate *delegate = (HXSCommunityTagTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            rows = [delegate tableView:tableView numberOfRowsInSection:section];
        }
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_currentSelectIndex)
    {
        case kHXSMyCenterSelectSectionIndexMyReply:
        case kHXSMyCenterSelectSectionIndexReplyForMe:
        {
            HXSCommunityMyCenterTableDelegate *delegate = (HXSCommunityMyCenterTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            break;
            
        default:
        {
            HXSCommunityTagTableDelegate *delegate = (HXSCommunityTagTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
    }
    
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_currentSelectIndex)
    {
        case kHXSMyCenterSelectSectionIndexMyReply:
        case kHXSMyCenterSelectSectionIndexReplyForMe:
        {
            HXSCommunityMyCenterTableDelegate *delegate = (HXSCommunityMyCenterTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
            
        }
            break;
            
        default:
        {
            HXSCommunityTagTableDelegate *delegate = (HXSCommunityTagTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
            break;
    }
    
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_currentSelectIndex)
    {
        case kHXSMyCenterSelectSectionIndexMyReply:
        case kHXSMyCenterSelectSectionIndexReplyForMe:
        {
            HXSCommunityMyCenterTableDelegate *delegate = (HXSCommunityMyCenterTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
            
        }
            break;
            
        default:
        {
            HXSCommunityTagTableDelegate *delegate = (HXSCommunityTagTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:_currentSelectIndex];
            
            return [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
            break;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self headerViewHeightConstraintChangeWithScrollView:scrollView];
}

- (void)headerViewHeightConstraintChangeWithScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY - _defaultOffsetY;
    CGFloat height = headerViewHeightResize - delta;

    if (height < NAVIGATION_STATUSBAR_HEIGHT)
    {
        height = NAVIGATION_STATUSBAR_HEIGHT;
    }
    _headerViewHeightConstraint.constant = height;
    
    CGFloat alpha = delta / (headerViewHeightResize - NAVIGATION_STATUSBAR_HEIGHT);
    if (alpha > 0)
    {
        if (alpha >= 1)
        {
            alpha = 1;
        }
    }
    UIColor *color = HXS_MAIN_COLOR;
    [self.navigationController.navigationBar at_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    [self.navigationController.navigationBar at_setTitleAlpha:alpha];
}

#pragma mark SelectionControl Action

-(void)selectItemAction:(HXSelectionControl *)sender
{
    NSInteger index = sender.selectedIdx;
    _currentSelectIndex = index;
    
    switch (index)
    {
        case 1:
        case 2:
        {
            HXSCommunityMyCenterTableDelegate *delegate = (HXSCommunityMyCenterTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:index];
            [delegate reload];
        }   break;
            
        default:
        {
            HXSCommunityTagTableDelegate *delegate = (HXSCommunityTagTableDelegate *)[_childViewTableDelegatesArray objectAtIndex:index];
            [delegate initData];
            [delegate reload];
        }
            break;
    }
}

#pragma mark UIBarButtonItem Action

/**
 *  跳转到个人信息编辑界面
 *
 *  @param barButtonItem
 */
- (void)profileEditAction:(UIBarButtonItem *)barButtonItem
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PersonalInfo" bundle:nil];
    UIViewController *personalInfoVC = [storyboard instantiateViewControllerWithIdentifier:@"HXSPersonalInfoTableViewController"];
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

#pragma mark private methods

#pragma mark getter setter

- (UIBarButtonItem *)rightBarButtonItem
{
    if(!_rightBarButtonItem)
    {
        UIImage *image = [UIImage imageNamed:@"ic_edit_personal_information"];
        _rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(profileEditAction:)];
    }
    return _rightBarButtonItem;
}

- (NSMutableArray *)childViewTableDelegatesArray
{
    if(!_childViewTableDelegatesArray)
    {
        _childViewTableDelegatesArray = [[NSMutableArray alloc]init];
    }
    return _childViewTableDelegatesArray;
}

@end
