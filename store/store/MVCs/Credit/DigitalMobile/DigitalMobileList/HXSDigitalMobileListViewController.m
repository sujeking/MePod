//
//  HXSDigitalMobileListViewController.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileListViewController.h"

// Controllers
#import "HXSDigitalMobileDetailViewController.h"
// Model
#import "HXSDigitalMobileModel.h"
// Views
#import "HXSDigitalMobileTableViewCell.h"


@interface HXSDigitalMobileListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) HXSDigitalMobileModel *digitalMobileModel;

@property (nonatomic, assign) CGFloat beginningOffsetY;

@end

@implementation HXSDigitalMobileListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self intitalTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle(self.index);
    
    if (0 >= [self.dataSource count]) {
        [HXSLoadingView showLoadingInView:self.view];
        
        [self fetchItemData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.tableView endRefreshing];
    [HXSLoadingView closeInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.updateSelectionTitle = nil;
    self.scrollviewScrolled   = nil;
}


#pragma mark - Initial Methods

- (void)intitalTableView
{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchItemData];
    }];
}


#pragma mark - Fetch Data

- (void)fetchItemData
{
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileModel fetchTipItemListWithCategoryID:self.categoryIDIntNum
                                                   complete:^(HXSErrorCode status, NSString *message, NSArray *slideArr) {
                                                       [weakSelf.tableView endRefreshing];
                                                       [HXSLoadingView closeInView:weakSelf.view];
                                                       
                                                       if (kHXSNoError != status) {
                                                           if (weakSelf.isFirstLoading) {
                                                               [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                                            block:^{
                                                                                                [weakSelf fetchItemData];
                                                                                            }];
                                                           } else {
                                                               [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                  status:message
                                                                                              afterDelay:1.5f];
                                                           }
                                                           
                                                           
                                                           return ;
                                                       }
                                                       
                                                       weakSelf.firstLoading = NO;
                                                       
                                                       weakSelf.dataSource = slideArr;
                                                       
                                                       [weakSelf.tableView reloadData];
                                                   }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileTableViewCell class]) forIndexPath:indexPath];
    
    HXSDigitalMobileItemListEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell setupCellWithEntity:entity];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSDigitalMobileItemListEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    
    HXSDigitalMobileDetailViewController *detailVC = [HXSDigitalMobileDetailViewController controllerFromXib];
    
    detailVC.itemIDIntNum = entity.itemIDIntNum;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginningOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (0 < scrollView.contentSize.height) {
        if (nil != self.scrollviewScrolled) {
            self.scrollviewScrolled(CGPointMake(0, scrollView.contentOffset.y - self.beginningOffsetY));
        }
    }
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileModel *)digitalMobileModel
{
    if (nil == _digitalMobileModel) {
        _digitalMobileModel = [[HXSDigitalMobileModel alloc] init];
    }
    
    return _digitalMobileModel;
}

@end
