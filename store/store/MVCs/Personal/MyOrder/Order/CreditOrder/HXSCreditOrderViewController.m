 //
//  HXSCreditOrderViewController.m
//  store
//
//  Created by ArthurWang on 16/2/23.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderViewController.h"

// Controller
#import "HXSCreditOrderDetailViewController.h"
// views
#import "HXSMyOrderHeaderTableViewCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSMyOderFooterTableViewCell.h"
// Model
#import "HXSCreditOrderModel.h"


#define NUM_PER_PAGE  20

static NSString *myOrderHeaderCell           = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderHeaderCellIdentifier = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderCell                 = @"HXSMyOderTableViewCell";
static NSString *myOrderCellIdentifier       = @"HXSMyOderTableViewCell";
static NSString *myOrderFooterCell           = @"HXSMyOderFooterTableViewCell";
static NSString *myOrderFooterCellIdentifier = @"HXSMyOderFooterTableViewCell";

@interface HXSCreditOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *creditOrderListMArr;
@property (nonatomic, strong) HXSCreditOrderModel *creditOrderModel;
@property (nonatomic, assign) NSInteger page;

@end

@implementation HXSCreditOrderViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialTableView];
    
    [self initialNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle([self.typeNumber integerValue]);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginCompleted
                                                  object:nil];
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 44;
    
    
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    
    [MBProgressHUD showInView:self.view];
    
    [self reload];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.tableView setShowsInfiniteScrolling:NO];
    
    [self.tableView registerNib:[UINib nibWithNibName:myOrderHeaderCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderHeaderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:myOrderCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:myOrderFooterCell bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderFooterCellIdentifier];
    
}

- (void)initialNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:NOTIFICATION_CREDIT_PAY_SUCCESS
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:kLoginCompleted
                                               object:nil];
}


#pragma mark - Public Methods

- (void)replaceOrderInfo:(HXSOrderInfo *)order
{
    NSInteger index = -1;
    for (int i = 0; i < [self.creditOrderListMArr count]; i++) {
        HXSOrderInfo *orderInfo = [self.creditOrderListMArr objectAtIndex:i];
        if ([orderInfo.order_sn isEqualToString:order.order_sn]) {
            index = i;
            break;
        }
    }
    
    if (-1 != index) {
        [self.creditOrderListMArr replaceObjectAtIndex:index withObject:order];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Target Methods

- (void)reload
{
    self.page = 1;
    
    [self fetchCreditOrderList];
}

- (void)loadMore
{
    self.page++;
    
    [self fetchCreditOrderList];
}

- (void)fetchCreditOrderList
{
    __weak typeof(self) weakSelf = self;
    [self.creditOrderModel fetchCreditcardOrderListWithPage:[NSNumber numberWithInteger:self.page]
                                                 numPerPage:[NSNumber numberWithInt:NUM_PER_PAGE]
                                                       type:[NSNumber numberWithInteger:kHXSCreditCardOrderTypeAll]
                                                   complete:^(HXSErrorCode status, NSString *message, HXSCreditOrderEntity *orderEntity) {
                                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                       [weakSelf.tableView endRefreshing];
                                                       [[weakSelf.tableView infiniteScrollingView] stopAnimating];
                                                       
                                                       if (kHXSNoError != status) {
                                                           [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                              status:message
                                                                                          afterDelay:1.5f];
                                                           [weakSelf reloadOrderList];
                                                           
                                                           return ;
                                                       }
                                                       
                                                       if (1 == weakSelf.page) {  // reload
                                                           [weakSelf.creditOrderListMArr removeAllObjects];
                                                       }
                                                       
                                                       [weakSelf.creditOrderListMArr addObjectsFromArray:orderEntity.orderListArr];
                                                       
                                                       BOOL hasMoreOrder = [orderEntity.orderListArr count] >= NUM_PER_PAGE;
                                                       [weakSelf.tableView setShowsInfiniteScrolling:hasMoreOrder];
                                                       
                                                       [weakSelf reloadOrderList];
                                                   }];
}

- (void)reloadOrderList
{
    [self.tableView reloadData];
    
    if (self.creditOrderListMArr.count > 0) {
        self.tableView.hidden = NO;
        self.cannotFindImageView.hidden = YES;
        self.cannotFindLabel.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        self.cannotFindImageView.hidden = NO;
        self.cannotFindLabel.hidden = NO;
    }
}

- (NSMutableArray *)creditOrderListMArr
{
    if (nil == _creditOrderListMArr) {
        _creditOrderListMArr = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    return _creditOrderListMArr;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.creditOrderListMArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < [self.creditOrderListMArr count]) {
        HXSOrderInfo *orderInfo = [self.creditOrderListMArr objectAtIndex:section];
        return [orderInfo.items count] + 2; // 2 is header & footer views
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.creditOrderListMArr count]) {
        HXSOrderInfo *order = [self.creditOrderListMArr objectAtIndex:indexPath.section];
        if ((0 < indexPath.row) && (indexPath.row <= [order.items count])) {
            return 92;
        } else {
            return 44;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < [self.creditOrderListMArr count]) {
        HXSOrderInfo *orderInfo = [self.creditOrderListMArr objectAtIndex:indexPath.section];
        if (0 == indexPath.row) {
            HXSMyOrderHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderHeaderCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section < [self.creditOrderListMArr count]) {
                [cell setOrderInfo:orderInfo];
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return cell;
        } else if (indexPath.row <= [orderInfo.items count]) {
            HXSMyOderTableViewCell * cell = (HXSMyOderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myOrderCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXSOrderItem * item = [orderInfo.items objectAtIndex:(indexPath.row - 1)];
            
            [cell setOrderItem:item];
            
            if (indexPath.row == [orderInfo.items count]) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
            }
            
            return cell;
        } else {
            HXSMyOderFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderFooterCellIdentifier];
            
            if(indexPath.section < [self.creditOrderListMArr count]) {
                HXSOrderInfo * orderInfo = [self.creditOrderListMArr objectAtIndex:indexPath.section];
                
                [cell setOrderInfo:orderInfo];
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
    
    HXSCreditOrderDetailViewController *orderDetailVC = [HXSCreditOrderDetailViewController controllerFromXib];
    
    HXSOrderInfo *orderInfo = [self.creditOrderListMArr objectAtIndex:indexPath.section];
    orderDetailVC.orderSNStr = orderInfo.order_sn;
    orderDetailVC.orderTypeIntNum = [NSNumber numberWithInteger:orderInfo.type];
    
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - Setter Getter Methods

- (HXSCreditOrderModel *)creditOrderModel
{
    if (nil == _creditOrderModel) {
        _creditOrderModel = [[HXSCreditOrderModel alloc] init];
    }
    
    return _creditOrderModel;
}

@end
