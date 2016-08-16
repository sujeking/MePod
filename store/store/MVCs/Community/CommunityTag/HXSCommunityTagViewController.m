//
//  HXSCommunityTagViewController.m
//  store
//
//  Created by  黎明 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSCommunityTagViewController.h"
#import "HXSCommunityDetailViewController.h"
#import "HXSCommunityTopicListViewController.h"
#import "HXSCommunityOthersCenterViewController.h"

// Views
#import "HXSCommunityHeadCell.h"
#import "HXSCommunityContentTextCell.h"
#import "HXSCommunityFootrCell.h"
#import "HXSCommunityImageCell.h"
#import "HXSShareView.h"

// Model
#import "HXSCommunityModel.h"
#import "HXSPost.h"
#import "HXSNoDataView.h"
#import "HXSCommunityTagModel.h"
#import "HXSCommunityTopicsModel.h"

@interface HXSCommunityTagViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) CGFloat                      lastOffSet;
@property (nonatomic, strong) HXSShareView                 *shareView;
@property (nonatomic, strong) HXSCommunityTagTableDelegate *delegate;

@end

@implementation HXSCommunityTagViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableview];
    [self.delegate initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)dealloc
{
    
}

#pragma mark - Target Methods

- (void)loadDataFromServerWith:(HXSPostListType)type topicId:(NSString *)topicId siteId:(NSString *)siteId userId:(NSNumber *)userId
{
    [self.delegate loadDataFromServerWith:type topicId:topicId siteId:siteId userId:userId];
}

- (void)setIsSchoolPost:(BOOL)isSchoolPost
{
    self.delegate.isSchoolPost = isSchoolPost;
}

#pragma mark - Intial Methods

- (void)initTableview
{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mTableView.scrollsToTop = YES;
    [self.delegate initWithTableView:self.mTableView superViewController:self];
    
    [self.mTableView addRefreshHeaderWithCallback:^{
        
        [self.delegate reload];
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.delegate numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark - Get Set Methods
- (HXSCommunityTagTableDelegate *)delegate
{
    if(!_delegate) {
        _delegate = [[HXSCommunityTagTableDelegate alloc] init];
    }
    
    return _delegate;
}

@end
