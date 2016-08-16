//
//  HXSPrintOrderViewController.m
//  store
//
//  Created by 格格 on 16/3/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  我的订单-云印店

#import "HXSPrintOrderViewController.h"

#import "HXSMyOrderHeaderTableViewCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSMyOderFooterTableViewCell.h"
#import "HXSPrintOrderDetailViewController.h"
#import "HXSPrintModel.h"
#import "HXSMyPrintOrderItem.h"


static NSString *myOrderHeaderCell           = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderHeaderCellIdentifier = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderCell                 = @"HXSMyOderTableViewCell";
static NSString *myOrderCellIdentifier       = @"HXSMyOderTableViewCell";
static NSString *myOrderFooterCell           = @"HXSMyOderFooterTableViewCell";
static NSString *myOrderFooterCellIdentifier = @"HXSMyOderFooterTableViewCell";

@interface HXSPrintOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *printOrders;
@property(nonatomic,assign) int page;

@end

@implementation HXSPrintOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.printOrders = [NSMutableArray array];
    
    [self initialTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.updateSelectionTitle([self.typeNumber integerValue]);
}

#pragma mark - initialMethod
-(void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 44;
    
    [_tableView registerNib:[UINib nibWithNibName:myOrderHeaderCell bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:myOrderHeaderCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:myOrderCell bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:myOrderCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:myOrderFooterCell bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:myOrderFooterCellIdentifier];
    
    __weak typeof (self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [MBProgressHUD showInView:self.view];
    
    [self reload];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    
}

#pragma mark - targetMethod
// 下拉刷新
-(void)reload{
    self.page = 1;
    [self fetchPrintOrderList];
}

// 上来更多
-(void)loadMore{
    self.page++;
    [self fetchPrintOrderList];
}


- (void)fetchPrintOrderList
{
    __weak typeof (self) weakSelf = self;
    [HXSPrintModel getPrintOrderListWithPage:self.page complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_tableView endRefreshing];
        [[_tableView infiniteScrollingView] stopAnimating];
        
        if(kHXSNoError == code){
            if(1 == weakSelf.page){
                [weakSelf.printOrders removeAllObjects];
            }
           [weakSelf loadOrders:orders];
           [weakSelf.tableView setShowsInfiniteScrolling:orders.count>0];
            
        }else{
            [weakSelf.tableView setShowsInfiniteScrolling:NO];
            if(code != kHXSItemNotExit) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
            
            [weakSelf loadOrders:orders];
        }
    }];
}

-(void)loadOrders:(NSArray *)orders{
    [self.printOrders addObjectsFromArray:orders];
    [self.tableView reloadData];
    if(self.printOrders.count > 0){
        self.tableView.hidden = NO;
        self.cannotFindImageView.hidden = YES;
        self.cannotFindLabel.hidden = YES;
    }else{
        self.tableView.hidden = YES;
        self.cannotFindImageView.hidden = NO;
        self.cannotFindLabel.hidden = NO;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.printOrders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSPrintOrderInfo *order = self.printOrders[indexPath.section];
    if ((indexPath.row > 0) && (indexPath.row <= order.itemsArr.count)) {
        return 92;
    }
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section < self.printOrders.count) {
        HXSPrintOrderInfo * orderInfo = [self.printOrders objectAtIndex:section];
        return orderInfo.itemsArr.count + 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSPrintOrderInfo *order = self.printOrders[indexPath.section];
    if ( 0 == indexPath.row) {
        HXSMyOrderHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderHeaderCellIdentifier];
        cell.printOrder = order;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return cell;
    }else if (indexPath.row <= order.itemsArr.count){
        HXSMyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderCellIdentifier];
        HXSMyPrintOrderItem *item = order.itemsArr[indexPath.row - 1];
        cell.printItem = item;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == order.itemsArr.count) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        else {
            cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
        }
        return cell;
    }else{
        HXSMyOderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myOrderFooterCellIdentifier];
        cell.printOrderInfo = order;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HXSPrintOrderInfo *order = self.printOrders[indexPath.section];
    
    HXSPrintOrderDetailViewController *orderDetailVC = [[HXSPrintOrderDetailViewController alloc]initWithNibName:@"HXSPrintOrderDetailViewController" bundle:nil];
    orderDetailVC.orderSNNum = order.orderSnLongNum;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}


#pragma mark - public method

- (void)replaceOrderInfo:(HXSPrintOrderInfo *)order
{
    int i = -1;
    for ( i = 0; i < self.printOrders.count ; i++) {
        HXSPrintOrderInfo * item = self.printOrders[i];
        if ([item.orderSnLongNum isEqual:order.orderSnLongNum]) {
            break;
        }
    }
    if (i >= 0 && i < self.printOrders.count) {
        [self.printOrders replaceObjectAtIndex:i withObject:order];
        [self loadOrders:nil];
    }
}

@end
