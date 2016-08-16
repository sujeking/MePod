//
//  HXSTaskHandledViewController.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSTaskHandledViewController.h"
#import "HXSTaskHandledTableViewCell.h"
#import "HXSTastHandledSectionHeaderView.h"
#import "HXSTaskDetialViewController.h"
#import "HXSRobTaskNoDataView.h"
#import "HXSRobTaskModel.h"
#import "HXSActionSheet.h"
#import "HXSKnight.h"

#define dateKey @"date"
#define itemsKey @"orders"

#define BUYER_ADDRESS_LABEL_LESS_WIDTH   117
#define SHOP_ADDRESS_LABEL_LESS_WIDTH 111
#define REMARK_LABEL_LESS_WIDTH 111
#define CELL_BASE_HEIGHT_NORMAL 185
#define CELL_BASE_HEIGHT_LAST 195

static NSString *HXSTaskHandledTableViewCellId = @"HXSTaskHandledTableViewCell";

@interface HXSTaskHandledViewController ()<UITableViewDelegate,UITableViewDataSource,HXSTaskHandledTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTable;
@property (nonatomic, strong) HXSRobTaskNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation HXSTaskHandledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registNotification];
    [self initialPrama];
    [self initialTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.firstLoad){
        [self reload];
        self.firstLoad = YES;
    }else{
        [self refreshData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - initial

- (void)initialPrama{
    self.dataArray = [NSMutableArray array];
    self.size = 20;
}

- (void)initialTable{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    [self.myTable setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    [self.myTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskHandledTableViewCellId bundle:nil] forCellReuseIdentifier:HXSTaskHandledTableViewCellId];
    
    if(self.dataArray.count <= 0)
        [self.myTable setTableFooterView:self.noDataView];
    else
        [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    __weak typeof (self) weakSelf = self;
    [self.myTable addRefreshHeaderWithCallback:^{
        [weakSelf reload];
    }];
    [self.myTable addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
    [self.myTable setShowsInfiniteScrolling:YES];
}

- (void)registNotification{
    // 订单取消成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightCancleTaskSuccess object:nil];
    // 订单送达
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightFinishTaskSuccess object:nil];
    // 订单状态改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightOrderStatusUpdate object:nil];
}

#pragma  mark - webService

- (void)refreshData{
    self.page = 1;
    [self fetchPrintOrderList];
}

- (void)reload{
    
    self.page = 1;
    [MBProgressHUD showInView:self.view];
    [self fetchPrintOrderList];
}

- (void)loadMore{
    [self fetchPrintOrderList];
}

- (void)fetchPrintOrderList{
    
    __weak typeof (self) weakSelf = self;
    [HXSRobTaskModel getKnightDeliveryListHadledWithPage:@(self.page) size:@(self.size) complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.myTable endRefreshing];
        [[weakSelf.myTable infiniteScrollingView] stopAnimating];
    
        if(kHXSNoError == code){
            
            if(1 == weakSelf.page){
                [weakSelf.dataArray removeAllObjects];
                 [weakSelf.dataArray addObjectsFromArray:orders];
            }else{
                if([weakSelf.dataArray count] > 0 && orders.count > 0){
                    
                    NSDictionary *dicLastOne = [weakSelf.dataArray lastObject];
                    NSNumber *dateLastOne = [dicLastOne objectForKey:dateKey];
                    
                    NSDictionary *dicFirstOne = [orders firstObject];
                    NSNumber *dateFirstOne = [dicLastOne objectForKey:dateKey];
                    
                    if([dateLastOne isEqual:dateFirstOne]){
                        
                        NSArray *lastArray = [dicLastOne objectForKey:itemsKey];
                        NSArray *firstArray = [dicFirstOne objectForKey:itemsKey];

                        NSMutableArray *arr = [NSMutableArray array];
                        [arr addObjectsFromArray:lastArray];
                        [arr addObjectsFromArray:firstArray];
                        
                        NSDictionary *resultDic = @{dateKey:dateLastOne,itemsKey:arr};
                        
                        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.dataArray.count - 1 withObject:resultDic];
                        NSMutableArray *ordersRemoveFirstObj = [NSMutableArray arrayWithArray:orders];
                        [ordersRemoveFirstObj removeObjectAtIndex:0];
                        [weakSelf.dataArray addObjectsFromArray:ordersRemoveFirstObj];
                    
                    }else{
                        [weakSelf.dataArray addObjectsFromArray:orders];
                    }
                    
                }else{
                    [weakSelf.dataArray addObjectsFromArray:orders];
                }
            }
            
            weakSelf.page ++;
    
            
            if(weakSelf.dataArray.count <= 0)
                [weakSelf.myTable setTableFooterView:weakSelf.noDataView];
            else
                [weakSelf.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            
            [weakSelf.myTable reloadData];
            [weakSelf.myTable setShowsInfiniteScrolling:orders.count > 0];
            
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *arr = [dic objectForKey:itemsKey];
    return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:itemsKey];
    HXSTaskOrder *order = [arr objectAtIndex:indexPath.row];
    
    if([arr count] - 1 == indexPath.row)
        return CELL_BASE_HEIGHT_NORMAL + [order cellHeightWithBuyerAddressWidth:BUYER_ADDRESS_LABEL_LESS_WIDTH shopAddressWidth:SHOP_ADDRESS_LABEL_LESS_WIDTH remarkWidth:REMARK_LABEL_LESS_WIDTH];
    
    return CELL_BASE_HEIGHT_LAST + [order cellHeightWithBuyerAddressWidth:BUYER_ADDRESS_LABEL_LESS_WIDTH shopAddressWidth:SHOP_ADDRESS_LABEL_LESS_WIDTH remarkWidth:REMARK_LABEL_LESS_WIDTH];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HXSTastHandledSectionHeaderView *view = [HXSTastHandledSectionHeaderView headView];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSNumber *dateNum = [dic objectForKey:dateKey];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.intValue];
    view.dateStrLabel.text = [NSString stringWithFormat:@"%@",[HTDateConversion stringFromDate:date formatString:@"yyyy-MM-dd "]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HXSTaskHandledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSTaskHandledTableViewCellId];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:itemsKey];
    cell.taskOrder = [arr objectAtIndex:indexPath.row];
    cell.delegate = self;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *arr = [dic objectForKey:itemsKey];
    
    HXSTaskDetialViewController *taskDetialVC = [[HXSTaskDetialViewController alloc]initWithNibName:nil bundle:nil];
    [taskDetialVC setTaskOrderEntity:[arr objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:taskDetialVC animated:YES];
}

#pragma mark - HXSTaskHandledTableViewCellDelegate
- (void)phoneButtonButtonClicked:(HXSTaskOrder *)taskOrder{
    
    [HXSUsageManager trackEvent:kUsageEventKnightCallPhone parameter:@{@"phone_type":@"买家电话"}];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = taskOrder.buyerPhone;
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     
                                                     [HXSUsageManager trackEvent:kUsageEventKnightBuyersCallComfim parameter:@{@"status":@"确认"}];
                                                     
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:taskOrder.buyerPhone];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];

}

- (void)shopPhoneClicked:(HXSTaskOrder *)taskOrder{
    [HXSUsageManager trackEvent:kUsageEventKnightCallPhone parameter:@{@"phone_type":@"卖家电话"}];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = taskOrder.shopPhoneStr;
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     
                                                     [HXSUsageManager trackEvent:kUsageEventKnightSellerCallComfifm parameter:@{@"status":@"确认"}];
                                                     
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:taskOrder.shopPhoneStr];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];
}

#pragma mark - Get Set Methods
- (HXSRobTaskNoDataView *)noDataView{
    if(_noDataView)
        return _noDataView;
    _noDataView = [HXSRobTaskNoDataView noDataView];
    [_noDataView.imageView  setImage:[UIImage imageNamed:@"img_kong_tiezi"]];
    _noDataView.label.text = @"快去抢任务吧~";
    return _noDataView;
}

@end
