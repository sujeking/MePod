//
//  HXSMyBoxOderViewController.m
//  store
//
//  Created by ArthurWang on 15/8/13.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyBoxOderViewController.h"
#import "HXSBoxMacro.h"
#import "HXSBoxModel.h"
#import "HXSMyOrderHeaderTableViewCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSMyOderFooterTableViewCell.h"
#import "HXSBoxOrderEntity.h"
#import "HXSBoxOrderViewController.h"

static NSString *myOrderHeaderCell           = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderHeaderCellIdentifier = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderCell                 = @"HXSMyOderTableViewCell";
static NSString *myOrderCellIdentifier       = @"HXSMyOderTableViewCell";
static NSString *myOrderFooterCell           = @"HXSMyOderFooterTableViewCell";
static NSString *myOrderFooterCellIdentifier = @"HXSMyOderFooterTableViewCell";

@interface HXSMyBoxOderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HXSBoxModel *boxModel;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HXSMyBoxOderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self initialTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:kBoxOrderHasPayed
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kLoginCompleted object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle([self.typeNumber integerValue]);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
}

#pragma mark - Initial Methods

- (void)initialTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak typeof (self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [MBProgressHUD showInView:self.view];
    
    [self reload];
    
    [self.tableView registerNib:[UINib nibWithNibName:myOrderHeaderCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:myOrderCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:myOrderFooterCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderFooterCellIdentifier];
    self.tableView.estimatedRowHeight = 44;
}

#pragma mark - Target Methods

- (void)reload
{
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetOrderListWithUid:nil boxId:nil batchNo:nil withOrderItems:YES withOrderPays:NO complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.tableView endRefreshing];
        
        if (kHXSNoError != code) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
            
            [weakSelf loadOrders];
            return ;
        }
        weakSelf.dataSource = orders;
        [weakSelf loadOrders];
    }];
}


- (void)loadOrders
{
    [self.tableView reloadData];
    
    if (self.dataSource.count > 0) {
        self.tableView.hidden = NO;
        self.cannotFindImageView.hidden = YES;
        self.cannotFindLabel.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.cannotFindImageView.hidden = NO;
        self.cannotFindLabel.hidden = NO;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < self.dataSource.count) {
        
        HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:section];
        return boxOrderEntity.itemsArr.count + 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataSource.count) {
        HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:indexPath.section];
        if ((0 < indexPath.row) && (indexPath.row <= boxOrderEntity.itemsArr.count)) {
            return 92;
        } else {
            return 44;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.dataSource.count) {
        HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:indexPath.section];
        
        if (0 == indexPath.row) {
            HXSMyOrderHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderHeaderCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section < self.dataSource.count) {
                HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:indexPath.section];
                cell.boxOrderModel = boxOrderEntity;
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return cell;
        }
        else if (indexPath.row <= boxOrderEntity.itemsArr.count) {
            HXSMyOderTableViewCell * cell = (HXSMyOderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myOrderCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXSBoxOrderItemModel *itemEntity = [boxOrderEntity.itemsArr objectAtIndex:(indexPath.row - 1)];
            
            cell.boxOrderItemModel = itemEntity;
            
            if (indexPath.row == boxOrderEntity.itemsArr.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
            }
            
            return cell;
        } else {
            HXSMyOderFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderFooterCellIdentifier];
            
            if(indexPath.section < self.dataSource.count) {
                HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:indexPath.section];
                cell.boxOrderModel = boxOrderEntity;
            }
            
            [cell setBackgroundColor:[UIColor clearColor]];
            
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HXSBoxOrderModel *boxOrderEntity = [self.dataSource objectAtIndex:indexPath.section];
    
    switch (boxOrderEntity.orderStatusNum.intValue) {
        case kHXSBoxOrderStayusNotPay:
            [HXSUsageManager trackEvent:kUsageEventBoxOrderListItemClick parameter:@{@"order_status":@"未支付"}];
            break;
        case kHXSBoxOrderStayusFinished:
            [HXSUsageManager trackEvent:kUsageEventBoxOrderListItemClick parameter:@{@"order_status":@"已完成"}];
            break;
        case kHXSBoxOrderStayusCancled:
            [HXSUsageManager trackEvent:kUsageEventBoxOrderListItemClick parameter:@{@"order_status":@"已取消"}];
            break;
        default:
            break;
    }
    HXSBoxOrderViewController *orderDetailVC = [HXSBoxOrderViewController controllerFromXib];
    orderDetailVC.orderSNStr = boxOrderEntity.orderIdStr;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - Setter Getter Methods

- (HXSBoxModel *)boxModel
{
    if (nil == _boxModel) {
        _boxModel = [[HXSBoxModel alloc] init];
    }
    
    return _boxModel;
}
@end
