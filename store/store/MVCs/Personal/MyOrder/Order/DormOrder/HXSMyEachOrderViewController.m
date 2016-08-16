//
//  HXSDormOrderViewController.m
//  store
//
//  Created by ArthurWang on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSMyEachOrderViewController.h"

#import "HXSMyOrderRequest.h"
#import "HXSMyOrderHeaderTableViewCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSMyOderFooterTableViewCell.h"
#import "HXSMyOrderDetailViewController.h"

static NSString *myOrderHeaderCell           = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderHeaderCellIdentifier = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderCell                 = @"HXSMyOderTableViewCell";
static NSString *myOrderCellIdentifier       = @"HXSMyOderTableViewCell";
static NSString *myOrderFooterCell           = @"HXSMyOderFooterTableViewCell";
static NSString *myOrderFooterCellIdentifier = @"HXSMyOderFooterTableViewCell";

typedef enum : NSUInteger {
    ORDER_TYPE_DORM      = 0,
    ORDER_TYPE_BOX       = 1,
    ORDER_TYPE_STORE     = 2,
    ORDER_TYPE_STAGE_PAY = 3
} ORDER_TYPE;

@interface HXSMyEachOrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *myOrders;
@property (nonatomic, strong) HXSMyOrderRequest *request;
@property (nonatomic, assign) int page;

@end

@implementation HXSMyEachOrderViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.myOrders = [NSMutableArray array];
    
    [self initialTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"pay_success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:kLoginCompleted object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle([self.typeNumber integerValue]);
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCompleted object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Initial Methods

- (void)initialTableView
{
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    
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
    self.page = 1;
    self.request = [[HXSMyOrderRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    int orderType = (self.typeNumber.intValue == ORDER_TYPE_DORM ? 4 : 0);
    [self.request getMyOrderListWithToken:[HXSUserAccount currentAccount].strToken
                                     page:self.page
                                     type:orderType
                                 complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
                                     [weakSelf.tableView endRefreshing];
                                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
                                     DLog(@"--------- ");
        
                                     if (code == kHXSNoError && orders && [orders isKindOfClass:[NSArray class]]) {
            
                                         [weakSelf.myOrders removeAllObjects];
            

                                         NSArray *currentOrderArr = nil;

                                         switch ([weakSelf.typeNumber intValue]) {

                                             case ORDER_TYPE_DORM:// 夜猫店

                                             {

                                                 NSMutableArray *orderMArr = [[NSMutableArray alloc] initWithArray:orders];

                                                 for(HXSOrderInfo * order in orders) {

                                                     if (kHXSOrderTypeDorm != order.type) { // 0表示正常，1表示团购订单，2表示预定订单，3表示中国移动项目，4表示夜猫店

                                                         [orderMArr removeObject:order];

                                                     }
                    
                                                 }
                                                 currentOrderArr = [NSArray arrayWithArray:orderMArr];
                                             }

                                                 break;
                

                                             case ORDER_TYPE_BOX:
                                             case ORDER_TYPE_STAGE_PAY:
                                             {
                                                 currentOrderArr = nil;
                                             }
                                                 break;

                                             case ORDER_TYPE_STORE:
                                             {
                                                 NSMutableArray *orderMArr = [[NSMutableArray alloc] initWithArray:orders];

                                                 for(HXSOrderInfo * order in orders) {

                                                     if (kHXSOrderTypeDorm == order.type) { // 0表示正常，1表示团购订单，2表示预定订单，3表示中国移动项目，4表示夜猫店

                                                         [orderMArr removeObject:order];

                                                     }

                                                 }

                                                 currentOrderArr = [NSArray arrayWithArray:orderMArr];
                                             }
                                                 break;
                                             default:
                                                 break;

                                         }

                                         [weakSelf loadOrders:currentOrderArr];

                                         [weakSelf.tableView setShowsInfiniteScrolling:orders.count>0];

                                         weakSelf.page++;

                                     } else {

                                         [weakSelf.tableView setShowsInfiniteScrolling:NO];

                                         if(code != kHXSItemNotExit) {

                                             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                status:message
                                                                            afterDelay:1.5f];

                                         }

                                     }

                                 }];
}

- (void)loadMore
{
    self.request = [[HXSMyOrderRequest alloc] init];
    __weak typeof (self) weakSelf = self;
    int orderType = (self.typeNumber.intValue == ORDER_TYPE_DORM ? 4 : 0);
    [self.request getMyOrderListWithToken:[HXSUserAccount currentAccount].strToken page:self.page type:orderType complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [[weakSelf.tableView infiniteScrollingView] stopAnimating];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if(code == kHXSNoError && orders && [orders isKindOfClass:[NSArray class]]) {
            
            NSArray *currentOrderArr = nil;
            switch ([weakSelf.typeNumber intValue]) {
                case ORDER_TYPE_DORM:// 夜猫店
                {
                    NSMutableArray *orderMArr = [[NSMutableArray alloc] initWithArray:orders];
                    for(HXSOrderInfo * order in orders) {
                        if (kHXSOrderTypeDorm != order.type) { // 0表示正常，1表示团购订单，2表示预定订单，3表示中国移动项目，4表示夜猫店
                            [orderMArr removeObject:order];
                        }
                    }
                    
                    currentOrderArr = [NSArray arrayWithArray:orderMArr];
                }
                    break;
                    
                case ORDER_TYPE_BOX:
                case ORDER_TYPE_STAGE_PAY:
                {
                    currentOrderArr = nil;
                }
                    break;
                case ORDER_TYPE_STORE:
                {
                    NSMutableArray *orderMArr = [[NSMutableArray alloc] initWithArray:orders];
                    for(HXSOrderInfo * order in orders) {
                        if (kHXSOrderTypeDorm == order.type) { // 0表示正常，1表示团购订单，2表示预定订单，3表示中国移动项目，4表示夜猫店
                            [orderMArr removeObject:order];
                        }
                    }
                    
                    currentOrderArr = [NSArray arrayWithArray:orderMArr];
                }
                    break;
                    
                default:
                    break;
            }
            
            [weakSelf loadOrders:currentOrderArr];
            [weakSelf.tableView setShowsInfiniteScrolling:orders.count>0];
            weakSelf.page ++;
        }else {
            [weakSelf.tableView setShowsInfiniteScrolling:NO];
            if(code != kHXSItemNotExit) {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
        }
    }];
}

- (void)loadOrders:(NSArray *)orders
{
    for(HXSOrderInfo * order in orders) {
        if([order isKindOfClass:[HXSOrderInfo class]]) {
            [self.myOrders addObject:order];
        }
    }
    
    [self.tableView reloadData];
    
    if (self.myOrders.count > 0) {
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
    return self.myOrders.count;
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
    if(section < self.myOrders.count) {
        HXSOrderInfo * orderInfo = [self.myOrders objectAtIndex:section];
        return orderInfo.items.count + 2;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.myOrders.count) {
        HXSOrderInfo * order = [self.myOrders objectAtIndex:indexPath.section];
        if ((0 < indexPath.row) && (indexPath.row <= order.items.count)) {
            return 92;
        } else {
            return 44;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.myOrders.count) {
        HXSOrderInfo * order = [self.myOrders objectAtIndex:indexPath.section];
        if (0 == indexPath.row) {
            HXSMyOrderHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderHeaderCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.section < self.myOrders.count) {
                HXSOrderInfo * orderInfo = [self.myOrders objectAtIndex:indexPath.section];
                
                [cell setOrderInfo:orderInfo];
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            return cell;
        } else if (indexPath.row <= order.items.count) {
            HXSMyOderTableViewCell * cell = (HXSMyOderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myOrderCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            HXSOrderItem * item = [order.items objectAtIndex:(indexPath.row - 1)];
            
            [cell setOrderItem:item];
            
            if (indexPath.row == order.items.count) {
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
            else {
                cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
            }
            
            return cell;
        } else {
            HXSMyOderFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderFooterCellIdentifier];
            
            if(indexPath.section < self.myOrders.count) {
                HXSOrderInfo * orderInfo = [self.myOrders objectAtIndex:indexPath.section];
                
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
    
    HXSMyOrderDetailViewController *orderDetailVC = [[HXSMyOrderDetailViewController alloc]initWithNibName:@"HXSMyOrderDetailViewController" bundle:nil];
    orderDetailVC.order = self.myOrders[indexPath.section];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

@end
