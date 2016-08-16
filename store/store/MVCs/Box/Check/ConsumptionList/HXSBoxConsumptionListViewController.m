//
//  HXSBoxConsumptionListViewController.m
//  store
//
//  Created by 格格 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxConsumptionListViewController.h"
#import "HXSBoxMacro.h"
// views
#import "HXSBoxCheckCell.h"

// VC
#import "HXSBoxUnclaimedSnackViewController.h"
#import "HXSBoxManageSharerViewController.h"
#import "HXSPaymentOrderViewController.h"
#import "HXSPaymentResultViewController.h"

#import "HXSBoxModel.h"
#import "HXSLineView.h"

static CGFloat const sectionOneHeaderHeight = 35;

// 订单状态
typedef NS_ENUM(NSInteger, HXSBoxBillStatus){
    HXSBoxBillStatusNoPay        = 0,// 未支付
    HXSBoxBillStatusPayed        = 1,// 已支付
    HXSBoxBillStatusWiating      = 2,// 等待店长支付中
};

static NSString *HXSBoxCheckCellId = @"HXSBoxCheckCell";

@interface HXSBoxConsumptionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView                *myTable;
@property (nonatomic, weak) IBOutlet UIView                     *checkOutView;
@property (nonatomic, weak) IBOutlet UILabel                    *orderAmountLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *checkOutViewBottom;
@property (nonatomic, weak) IBOutlet UIButton                   *payButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint         *payButtonWidth;
@property (nonatomic, weak) IBOutlet UILabel                    *payFinishLable;

@property (nonatomic, strong) UIView                            *tableSectionHeaderView;

@property (nonatomic, strong) NSMutableArray                    *snacksArr;
/**未支付总计 */
@property (nonatomic, strong) NSNumber                          *notPaidAmountNum;
/** 已支付未领取零食数量 */
@property (nonatomic, strong) NSNumber                          *untakeQuantityNum;
/** 账单状态 */
@property (nonatomic, strong) NSNumber                          *billStatusNum;
@property (nonatomic, strong) HXSOrderInfo                      *orderInfo;

@property (nonatomic, strong) HXSBoxInfoEntity                  *boxInfoEntity;

@end

@implementation HXSBoxConsumptionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initialPrama];
    
    [self initialTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self fetBoxConsumList];
}

+ (instancetype)cantrollerWithBoxInfoEntity:(HXSBoxInfoEntity *)boxInfoEntity;
{
    HXSBoxConsumptionListViewController *controller = [HXSBoxConsumptionListViewController controllerFromXib];
    controller.boxInfoEntity = boxInfoEntity;
    return controller;
}


#pragma mark - initial

- (void)initNavigationBar
{
   self.navigationItem.title = @"消费清单";
}

- (void)initialPrama
{
    self.checkOutView.layer.borderWidth = 1;
    self.checkOutView.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.orderAmountLabel.adjustsFontSizeToFitWidth = YES;
    
    self.snacksArr = [NSMutableArray array];
    self.notPaidAmountNum = @(0);
    self.untakeQuantityNum = @(0);
    
    [self.payButton addTarget:self action:@selector(immediatePayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.myTable registerNib:[UINib nibWithNibName:HXSBoxCheckCellId bundle:nil] forCellReuseIdentifier:HXSBoxCheckCellId];
}


#pragma mark - others

/**
 *  刷新当期的"消费清单"
 */
- (void)refrashCheckOutView
{
    self.orderAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",self.orderInfo.order_amount.doubleValue];
    /*
     如果账单已经支付，隐藏立即支付，显示清单已经完成
     只有盒主有支付的权限
     */
    if(self.boxInfoEntity.isBoxerNum.intValue == HXSBoxUserStatusYes){
        
        self.checkOutViewBottom.constant = -1;
        [self.view setNeedsLayout];
        
        if(self.billStatusNum.intValue == HXSBoxBillStatusNoPay){
            self.payButton.hidden = NO;
        }else{
            self.payButton.hidden = YES;
        }
    }else{
        self.checkOutViewBottom.constant = -45;
        [self.view setNeedsLayout];
    }
}


#pragma mark - Target/Action

- (void)immediatePayButtonClicked
{
    [HXSUsageManager trackEvent:kUsageEventBoxOnlinePayment parameter:nil];
    
    if(self.orderInfo.order_amount.doubleValue >= 0.01){
        [HXSUsageManager trackEvent:kUsageEventBoxConsumptionInventoryAmountIsZero parameter:@{@"is_zero":@"否"}];

        HXSPaymentOrderViewController *paymentOrderViewController = [HXSPaymentOrderViewController createPaymentOrderVCWithOrderInfo:self.orderInfo installment:NO];
        [self.navigationController pushViewController:paymentOrderViewController animated:YES];
    }else{
        
        [HXSUsageManager trackEvent:kUsageEventBoxConsumptionInventoryAmountIsZero parameter:@{@"is_zero":@"是"}];
        HXSPaymentResultViewController *vc = [HXSPaymentResultViewController createPaymentResultVCWithOrderInfo:self.orderInfo result:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - webServices

- (void)fetBoxConsumList
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetBoxConsumListWithBoxId:self.boxInfoEntity.boxIdNum
                                   batchNo:self.boxInfoEntity.batchNoNum
                                  complete:^(HXSErrorCode code,
                                             NSString *message,
                                             NSArray *notPaidItems,
                                             NSNumber *notPaidAmount,
                                             NSNumber *untakeQuantity,
                                             NSNumber *billStatus,
                                             HXSOrderInfo *order
                                             ) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code){
            
            [weakSelf.snacksArr removeAllObjects];
            [weakSelf.snacksArr addObjectsFromArray:notPaidItems];
            weakSelf.notPaidAmountNum = notPaidAmount;
            weakSelf.untakeQuantityNum = untakeQuantity;
            weakSelf.billStatusNum = billStatus;
            
            weakSelf.orderInfo = order;

            [weakSelf refrashCheckOutView];
            [weakSelf.myTable reloadData];
        }else{
            [MBProgressHUD showInView:weakSelf.view
                           customView:nil
                               status:message
                           afterDelay:1.0f];
        }
    }];
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(0 == section)
        return self.snacksArr.count + 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(0 == section)
    {
        return sectionOneHeaderHeight;
    }
    else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(0 == section)
    {
        return self.tableSectionHeaderView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section){
        
        if(indexPath.row < self.snacksArr.count){
            HXSBoxCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSBoxCheckCellId];
            HXSDormItem *temp = [self.snacksArr objectAtIndex:indexPath.row];
            cell.boxItem = temp;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *cellId = @"consumptionListCell";
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if(nil == cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [cell.textLabel setTextColor:HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL];
                
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
                [cell.detailTextLabel setTextColor:HXS_SPECIAL_COLOR];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"未支付总计";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.notPaidAmountNum.doubleValue];
            return cell;
        }

    }else{
        static NSString *cellId = @"consumptionCheckCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(nil == cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.textLabel setTextColor:HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL];
            
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailTextLabel setTextColor:HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(0 == indexPath.row){
            cell.textLabel.text = @"已支付零食";
            cell.detailTextLabel.text = @"查看全部订单";
        }else{
            cell.textLabel.text = @"已支付未领取零食";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d件",self.untakeQuantityNum.intValue];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(1 == indexPath.section){
        if(0 == indexPath.row){
            // 已经支付零食
            if(self.boxInfoEntity){
                if(self.boxInfoEntity.isBoxerNum.intValue == HXSBoxUserStatusYes){
                    [HXSUsageManager trackEvent:kUsageEventBoxAlreadyPaySnack parameter:@{@"user_type":@"盒主"}];
                }else{
                    [HXSUsageManager trackEvent:kUsageEventBoxAlreadyPaySnack parameter:@{@"user_type":@"分享者"}];
                }
            }

            HXSBoxManageSharerViewController *boxManageSharerViewController = [HXSBoxManageSharerViewController controllerWithBoxInfoEntity:self.boxInfoEntity];
            [self.navigationController pushViewController:boxManageSharerViewController animated:YES];
        }else{
            // 已支付未领取零食
            if(self.boxInfoEntity){
                if(self.boxInfoEntity.isBoxerNum.intValue == HXSBoxUserStatusYes){
                    [HXSUsageManager trackEvent:kUsageEventBoxUntalkSnack parameter:@{@"user_type":@"盒主"}];
                }else{
                    [HXSUsageManager trackEvent:kUsageEventBoxUntalkSnack parameter:@{@"user_type":@"分享者"}];
                }
            }
            HXSBoxUnclaimedSnackViewController *unclaimedSnackVC = [HXSBoxUnclaimedSnackViewController controllerWithBoxId:self.boxInfoEntity.boxIdNum bactchId:self.boxInfoEntity.batchNoNum];
            [self.navigationController pushViewController:unclaimedSnackVC animated:YES];
        }
    }
}


#pragma mark - getter

- (UIView *)tableSectionHeaderView
{
    if(!_tableSectionHeaderView)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, sectionOneHeaderHeight)];
        UILabel *sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, sectionOneHeaderHeight)];
        [sectionLabel setFont:[UIFont systemFontOfSize:13]];
        [sectionLabel setTextColor:HXS_INFO_NOMARL_COLOR];
        sectionLabel.text = @"未支付零食";
        [view addSubview:sectionLabel];
        _tableSectionHeaderView = view;
    }
    return _tableSectionHeaderView;
}


@end
