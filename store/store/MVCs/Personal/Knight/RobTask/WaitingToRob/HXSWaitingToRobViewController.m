//
//  HXSWaitingToRobViewController.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

// Controllers
#import "HXSWaitingToRobViewController.h"

// Views
#import "HXSWaitingToRobTableViewCell.h"
#import "HXSRobTaskNoDataView.h"

// Model
#import "HXSRobTaskModel.h"

static CGFloat const  kBuyerAddressLabelLessWidth = 72.0f;
static CGFloat const  kShopAddressLabelLessWidth  = 72.0f;
static CGFloat const  kRemarkLabelLessWidth       = 72.0f;
static CGFloat const  kCellBaseHeight             = 188.0f;
static CGFloat const  kPadding                   = 10.0f;

static NSString *HXSWaitingToRobTableViewCellId = @"HXSWaitingToRobTableViewCell";

@interface HXSWaitingToRobViewController ()<UITableViewDelegate,
                                            UITableViewDataSource,
                                            HXSWaitingToRobTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTable;
@property (nonatomic, strong) HXSRobTaskNoDataView *noDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation HXSWaitingToRobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(knightHaveNewTask:) name:KnightHaveNewTask object:nil];

    [self initialPrama];
    [self initialTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.firstLoad) {
        [self reload];
        self.firstLoad = YES;
    }else{
        [self refreshData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - initial
- (void)initialPrama
{
    self.firstLoad = NO;
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    self.size = 20;
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    [self.myTable setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    [self.myTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [tableHeaderView setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    [self.myTable setTableHeaderView:tableHeaderView];
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSWaitingToRobTableViewCellId bundle:nil] forCellReuseIdentifier:HXSWaitingToRobTableViewCellId];
    
    if(self.dataArray.count <= 0)
        [self.myTable setTableFooterView:self.noDataView];
    else
        [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __weak typeof (self) weakSelf = self;
    [self.myTable addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
//    [self.myTable addInfiniteScrollingWithActionHandler:^{
//        [weakSelf loadMore];
//    }];
//    [self.myTable setShowsInfiniteScrolling:NO];
}

#pragma mark - Target/Action
- (void)knightHaveNewTask:(NSNotification *)noti
{
    // 有新的订单可抢，刷新列表
    [self reload];
}

#pragma  mark - webService

- (void)refreshData
{
    self.page = 1;
    [self fetchPrintOrderList];
}

- (void)reload
{
    
    self.page = 1;
    [MBProgressHUD showInView:self.view];
    [self fetchPrintOrderList];
}

- (void)loadMore
{
    [self fetchPrintOrderList];
}

- (void)fetchPrintOrderList
{
    __weak typeof (self) weakSelf = self;
    
    [HXSRobTaskModel getKnightDeliveryOrderListWithStatus:@(HXSKnightStatusWaitingTask) page:nil size:nil complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        [weakSelf.myTable endRefreshing];
        [[weakSelf.myTable infiniteScrollingView] stopAnimating];
        
        if(kHXSNoError == code){
            
            if(1 == weakSelf.page){
                [weakSelf.dataArray removeAllObjects];
            }
            
            weakSelf.page ++;
            [weakSelf.dataArray addObjectsFromArray:orders];
            
            [weakSelf.myTable reloadData];
//            [weakSelf.myTable setShowsInfiniteScrolling:orders.count >= 20];
            
            if(weakSelf.dataArray.count <= 0)
                [weakSelf.myTable setTableFooterView:weakSelf.noDataView];
            else
                [weakSelf.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            
            if([weakSelf.delegate respondsToSelector:@selector(waitingToRobTableReloadFinish:)])
                [weakSelf.delegate waitingToRobTableReloadFinish:weakSelf.dataArray.count];
        
        }else{
            [weakSelf.myTable setShowsInfiniteScrolling:NO];
            if(code != kHXSItemNotExit) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
        }
    }];
}

#pragma mark - UITabelViewDelegate/UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXSTaskOrder *order = [self.dataArray objectAtIndex:indexPath.section];
    
    if(indexPath.section < self.dataArray.count - 1)
        return kCellBaseHeight + [order buyerAddressAddHeightRob:kBuyerAddressLabelLessWidth] + [order shopAddressAddHeight:kShopAddressLabelLessWidth] + [order remarkAddHeightLessTwoLines:kRemarkLabelLessWidth];
    
    return kCellBaseHeight + [order buyerAddressAddHeightRob:kBuyerAddressLabelLessWidth] + [order shopAddressAddHeight:kShopAddressLabelLessWidth] + [order remarkAddHeightLessTwoLines:kRemarkLabelLessWidth] - kPadding;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXSWaitingToRobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSWaitingToRobTableViewCellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.taskOrder = [self.dataArray objectAtIndex:indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - HXSWaitingToRobTableViewCellDelegate
- (void)robTaskButtonClickedWithTaskOrder:(HXSTaskOrder *)taskOrder
{
    
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    [HXSRobTaskModel robTaskWithOrderSn:taskOrder.orderSnStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if(kHXSNoError == code){
            // 发送通知,更新待处理列
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:@"抢单成功，请到待处理中查看任务！" afterDelay:1.5];
            [weakSelf reload];
            [[NSNotificationCenter defaultCenter]postNotificationName:KnightRobTaskSuccess object:weakSelf];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - getter
- (HXSRobTaskNoDataView *)noDataView
{
    if(_noDataView)
        return _noDataView;
    _noDataView = [HXSRobTaskNoDataView noDataView];
    [_noDataView.imageView  setImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
    _noDataView.label.text = @"任务已抢光~";
    return _noDataView;
}

@end
