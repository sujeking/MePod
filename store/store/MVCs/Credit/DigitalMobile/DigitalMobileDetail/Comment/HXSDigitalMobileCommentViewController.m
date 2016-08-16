//
//  HXSDigitalMobileCommentViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileCommentViewController.h"

// Controllers
#import "HXSAddressBookViewController.h"
// Model
#import "HXSDigitalMobileCommentModel.h"
// Views
#import "HXSDigitalMobileAverageTableViewCell.h"
#import "HXSDigitalMobileCommentTableViewCell.h"

static NSInteger const  kNumPerPage        = 20;
static NSInteger const  kHeightDefaultCell = 44;
static NSInteger const  kHeightCommentCell = 100;

@interface HXSDigitalMobileCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) HXSDigitalMobileCommentModel *commentModel;

@end

@implementation HXSDigitalMobileCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"商品评价";
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchCommentList];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [weakSelf fetchCommentList];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self fetchCommentListMore];
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    label.text = @"显示更多···";
    label.textColor = HXS_COLOR_MASTER;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.tableView.infiniteScrollingView setCustomView:label forState:SVInfiniteScrollingStateAll];
    
    [self.tableView setShowsInfiniteScrolling:YES];
}


#pragma mark - Target Methods

- (void)fetchCommentList
{
    self.currentPage = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.commentModel fetchCommtentListWithItemID:self.itemIDIntNum
                                              page:[NSNumber numberWithInteger:self.currentPage]
                                        numPerPage:[NSNumber numberWithInteger:kNumPerPage]
                                         completed:^(HXSErrorCode status, NSString *message, NSArray *commentsArr) {
                                             [weakSelf.tableView endRefreshing];
                                             [HXSLoadingView closeInView:weakSelf.view];
                                             
                                             if (kHXSNoError != status) {
                                                 if (weakSelf.isFirstLoading) {
                                                     [HXSLoadingView showLoadFailInView:weakSelf.view block:^{
                                                         [weakSelf fetchCommentList];
                                                     }];
                                                 } else {
                                                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5f];
                                                 }
                                                 
                                                 return ;
                                             }
                                             
                                             weakSelf.firstLoading = NO;
                                             
                                             [weakSelf.dataSource removeAllObjects];
                                             weakSelf.dataSource = [[NSMutableArray alloc] initWithArray:commentsArr];
                                             
                                             [weakSelf.tableView reloadData];
                                             
                                             weakSelf.currentPage++;
                                             [weakSelf.tableView setShowsInfiniteScrolling:(0 < [commentsArr count])];
                                         }];
}

- (void)fetchCommentListMore
{
    __weak typeof(self) weakSelf = self;
    [self.commentModel fetchCommtentListWithItemID:self.itemIDIntNum
                                              page:[NSNumber numberWithInteger:self.currentPage]
                                        numPerPage:[NSNumber numberWithInteger:kNumPerPage]
                                         completed:^(HXSErrorCode status, NSString *message, NSArray *commentsArr) {
                                             [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                             if (kHXSNoError != status) {
                                                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5f];
                                                 
                                                 return ;
                                             }
                                             
                                             [weakSelf.dataSource addObjectsFromArray:commentsArr];
                                             
                                             [weakSelf.tableView reloadData];
                                             
                                             weakSelf.currentPage++;
                                             [weakSelf.tableView setShowsInfiniteScrolling:(0 < [commentsArr count])];
                                        }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (nil == self.dataSource) {
        return 1; // Don't display comment cells
    }
    
    return 2; // 1 is average score 2 is comment
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    } else {
        return [self.dataSource count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return kHeightDefaultCell;
    } else {
        return kHeightCommentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.1;
    } else {
        return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (0 == indexPath.section) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileAverageTableViewCell class]) forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileCommentTableViewCell class]) forIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        HXSDigitalMobileAverageTableViewCell *averageCell = (HXSDigitalMobileAverageTableViewCell *)cell;
        
        [averageCell setupCellWithAverageScore:self.averageScoreFloatNum];
    } else {
        HXSDigitalMobileCommentTableViewCell *commentCell = (HXSDigitalMobileCommentTableViewCell *)cell;
        
        if (indexPath.row < [self.dataSource count]) {
            HXSDigitalMobileDetailCommentEntity *commentEntity = [self.dataSource objectAtIndex:indexPath.row];
            [commentCell setupCellWithEntity:commentEntity];
        }
    }
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileCommentModel *)commentModel
{
    if (nil == _commentModel) {
        _commentModel = [[HXSDigitalMobileCommentModel alloc] init];
    }
    
    return _commentModel;
}

@end
