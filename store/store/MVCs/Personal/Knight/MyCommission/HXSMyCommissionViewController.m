//
//  HXSMyCommissionViewController.m
//  store
//
//  Created by 格格 on 16/4/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSGetCashViewController.h"
#import "HXSMyCommissionViewController.h"

// Views
#import "HXSMyCommissionTableHeaderView.h"
#import "HXSMyCommissionSectionHeader.h"
#import "HXSMyCommissionCell.h"
#import "HXSCommissionNoDataView.h"

// Model
#import "HXSCommissionModel.h"

static NSString *HXSMyCommissionCellId = @"HXSMyCommissionCell";

@interface HXSMyCommissionViewController ()<UITableViewDelegate,UITableViewDataSource,GetCashDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSNumber *allCommission;

@property (nonatomic, strong) HXSMyCommissionTableHeaderView *myCommissionTableHeaderView;
@property (nonatomic, strong) HXSMyCommissionSectionHeader *myCommissionSectionHeader;
@property (nonatomic, strong) HXSCommissionNoDataView *commissionNoDataView;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@end

@implementation HXSMyCommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialPrama];
    [self initialMyTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- initial
- (void)initialNav{
    self.navigationItem.title = @"我的佣金";
}

- (void)initialPrama{
    self.size = 20;
    self.allCommission = @(0);
    self.dataArray = [NSMutableArray array];
    
}

- (void)initialMyTableView{
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorColor = [UIColor colorWithRGBHex:0xe1e2e3];
    
    [self.myTableView registerNib:[UINib nibWithNibName:HXSMyCommissionCellId bundle:nil] forCellReuseIdentifier:HXSMyCommissionCellId];
    
    if(self.dataArray.count <= 0)
       [self.myTableView setTableFooterView:self.commissionNoDataView];
    else
        [self.myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __weak typeof (self) weakSelf = self;
    [self.myTableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [self reload];
    
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.myTableView setShowsInfiniteScrolling:NO];
}

#pragma mark - reflash
- (void)reloadTableHeaderView{
    self.myCommissionTableHeaderView.myCommissionLabel.text = [NSString stringWithFormat:@"%.2f",self.allCommission.doubleValue ];
    if(self.allCommission.doubleValue > 0)
        [self.myCommissionTableHeaderView updategetCashButtonStatus:YES];
    else
        [self.myCommissionTableHeaderView updategetCashButtonStatus:NO];
    
    [self.myCommissionTableHeaderView setNeedsLayout];
}

#pragma mark - webService
- (void)reload{
    self.page = 1;
    [self fetchPrintOrderList];
}

- (void)loadMore{
    [self fetchPrintOrderList];
}

- (void)fetchPrintOrderList{
    
    if(1 == self.page)
        [MBProgressHUD showInView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [HXSCommissionModel getKnightCommissionRewardsWithPage:@(self.page) Size:@(self.size) complete:^(HXSErrorCode code, NSString *message, NSArray *commissions,NSNumber *allCommission) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf.myTableView endRefreshing];
        [[weakSelf.myTableView infiniteScrollingView] stopAnimating];
        
        if(kHXSNoError == code){
            if(1 == weakSelf.page){
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.page ++;
            [weakSelf.dataArray addObjectsFromArray:commissions];
            [weakSelf.myTableView reloadData];
            [weakSelf.myTableView setShowsInfiniteScrolling:commissions.count>0];
            
            weakSelf.allCommission = allCommission;
            [weakSelf reloadTableHeaderView];
            
            if(weakSelf.dataArray.count <= 0)
                [weakSelf.myTableView setTableFooterView:self.commissionNoDataView];
            else
                [weakSelf.myTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

        
        }else{
            [weakSelf.myTableView setShowsInfiniteScrolling:NO];
            if(code != kHXSItemNotExit) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
        }
    }];
}

#pragma mark - Target/Action
// 点击取现
- (void)getCrashButtonClicked{
    HXSGetCashViewController *getCashViewController = [[HXSGetCashViewController alloc]initWithNibName:nil
                                                                                                bundle:nil];
    [getCashViewController setMaxCashAmount:self.allCommission];
    getCashViewController.delegate = self;
    [self.navigationController pushViewController:getCashViewController animated:YES];
}

#pragma mark - GetCashDelegate
- (void)getCashSuccessed{
    [self reload];
}

#pragma mark - UITabelViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section)
        return 0;
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section)
        return 104;
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(0 == section)
        return self.myCommissionTableHeaderView;
    return self.myCommissionSectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSMyCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSMyCommissionCellId];
    cell.commissionEntity = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataArray.count - 1 > indexPath.row){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
}

#pragma mark - Get Set Methods
- (HXSMyCommissionTableHeaderView *)myCommissionTableHeaderView{
    if(_myCommissionTableHeaderView)
        return _myCommissionTableHeaderView;
    
    _myCommissionTableHeaderView = [HXSMyCommissionTableHeaderView headerView];
    [_myCommissionTableHeaderView.getCashButton addTarget:self action:@selector(getCrashButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _myCommissionTableHeaderView.myCommissionLabel.text = [NSString stringWithFormat:@"%.2f",self.allCommission.doubleValue ];
    return _myCommissionTableHeaderView;
}

- (HXSMyCommissionSectionHeader *)myCommissionSectionHeader{
    if(_myCommissionSectionHeader)
        return _myCommissionSectionHeader;
    _myCommissionSectionHeader = [HXSMyCommissionSectionHeader sectionHeader];
    return _myCommissionSectionHeader;
}

- (HXSCommissionNoDataView *)commissionNoDataView{
    if(_commissionNoDataView)
        return _commissionNoDataView;
    
    _commissionNoDataView = [HXSCommissionNoDataView noDataView];
    return _commissionNoDataView;
}


@end
