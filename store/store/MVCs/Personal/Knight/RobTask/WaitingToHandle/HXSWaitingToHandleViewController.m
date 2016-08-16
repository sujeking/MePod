//
//  HXSWaitingToHandleViewController.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKnight.h"
// Controllers
#import "HXSWaitingToHandleViewController.h"
#import "HXSTaskQRCodeViewController.h"
#import "HXSTaskDetialViewController.h"
// Views
#import "HXSWaitingToHandleTableViewCell.h"
#import "HXSRobTaskNoDataView.h"
#import "HXSActionSheet.h"
// Model
#import "HXSRobTaskModel.h"


static CGFloat const kBuyerAddressLabelLessWidth = 117.0f;
static CGFloat const kShopAddressLabelLessWidth  = 111.0f;
static CGFloat const kRemarkLabelLessWidth       = 111.0f;
static CGFloat const kCellBaseHeight             = 188.0f;

static NSString *HXSWaitingToHandleTableViewCellId = @"HXSWaitingToHandleTableViewCell";


@interface HXSWaitingToHandleViewController ()<UITableViewDataSource,
                                                UITableViewDelegate,
                                                HXSWaitingToHandleTableViewCellDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTable;
@property (nonatomic, strong) HXSRobTaskNoDataView *noDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int size;

@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation HXSWaitingToHandleViewController

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
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [tableHeaderView setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    [self.myTable setTableHeaderView:tableHeaderView];
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSWaitingToHandleTableViewCellId bundle:nil] forCellReuseIdentifier:HXSWaitingToHandleTableViewCellId];
    
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

- (void)registNotification{
    // 订单取消成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightCancleTaskSuccess object:nil];
    // 订单送达
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightFinishTaskSuccess object:nil];
    // 抢单成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reload) name:KnightRobTaskSuccess object:nil];
    // 抢单成功
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
    [HXSRobTaskModel getKnightDeliveryOrderListWithStatus:@(HXSKnightStatusWaitingHandle) page:nil size:nil complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf.myTable endRefreshing];
        [[weakSelf.myTable infiniteScrollingView] stopAnimating];
        
        if(kHXSNoError == code){
            
            if(1 == weakSelf.page){
                [weakSelf.dataArray removeAllObjects];
            }
            
            weakSelf.page ++;
            [weakSelf.dataArray addObjectsFromArray:orders];
            
            if(weakSelf.dataArray.count <= 0)
                [weakSelf.myTable setTableFooterView:weakSelf.noDataView];
            else
                [weakSelf.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
            
            [weakSelf.myTable reloadData];
//            [weakSelf.myTable setShowsInfiniteScrolling:orders.count > 20];
            
            if([weakSelf.delegate respondsToSelector:@selector(waitingToHandleTableReloadFinish:)])
               [weakSelf.delegate waitingToHandleTableReloadFinish:weakSelf.dataArray.count];
            
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
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSTaskOrder *order = [self.dataArray objectAtIndex:indexPath.section];
    
    if(indexPath.section < self.dataArray.count - 1 )
        return kCellBaseHeight + [order cellHeightWithBuyerAddressWidth:kBuyerAddressLabelLessWidth shopAddressWidth:kShopAddressLabelLessWidth remarkWidth:kRemarkLabelLessWidth];
    return kCellBaseHeight + [order cellHeightWithBuyerAddressWidth:kBuyerAddressLabelLessWidth shopAddressWidth:kShopAddressLabelLessWidth remarkWidth:kRemarkLabelLessWidth] - 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXSWaitingToHandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSWaitingToHandleTableViewCellId];
    cell.delegate = self;
    cell.taskOrder = [self.dataArray objectAtIndex:indexPath.section];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSTaskDetialViewController *taskDetialVC = [[HXSTaskDetialViewController alloc]initWithNibName:nil bundle:nil];
    [taskDetialVC setTaskOrderEntity:[self.dataArray objectAtIndex:indexPath.section]];
    [self.navigationController pushViewController:taskDetialVC animated:YES];
}


#pragma mark - HXSWaitingToHandleTableViewCellDelegate
// 买家电话
- (void)phoneButtonButtonClicked:(HXSTaskOrder *)taskOrder{
    
    // 友盟 点击买家电话
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
// 卖家电话
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
// 点击二维码
- (void)qrCodeButtonClicked:(HXSTaskOrder *)taskOrder{
    
    [HXSUsageManager trackEvent:kUsageEventKnightShowQrCode parameter:nil];
    
    HXSTaskQRCodeViewController *taskQRCodeViewController = [[HXSTaskQRCodeViewController alloc]initWithNibName:nil bundle:nil];
    [taskQRCodeViewController setTaskOrderEntity:taskOrder];
    [self.navigationController pushViewController:taskQRCodeViewController animated:YES];

}

- (void)getDataCount{
    __weak typeof (self) weakSelf = self;
    [HXSRobTaskModel getKnightDeliveryOrderListWithStatus:@(HXSKnightStatusWaitingHandle) page:@(1) size:@(20) complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        if(kHXSNoError == code){
            if([weakSelf.delegate respondsToSelector:@selector(waitingToHandleTableReloadFinish:)])
                [weakSelf.delegate waitingToHandleTableReloadFinish:orders.count];
        }
    }];
}

#pragma mark - getter
- (HXSRobTaskNoDataView *)noDataView{
    if(_noDataView)
        return _noDataView;
    _noDataView = [HXSRobTaskNoDataView noDataView];
    [_noDataView.imageView  setImage:[UIImage imageNamed:@"img_kong_tiezi"]];
    _noDataView.label.text = @"快去抢任务吧~";
    return _noDataView;
}

@end
