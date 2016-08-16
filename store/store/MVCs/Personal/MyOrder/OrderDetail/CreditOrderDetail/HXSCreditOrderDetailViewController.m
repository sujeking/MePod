//
//  HXSCreditOrderDetailViewController.m
//  store
//
//  Created by ArthurWang on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSCreditOrderDetailViewController.h"

// Controller
#import "HXSCommentViewController.h"
#import "HXSLogisticsViewController.h"
#import "HXSWebViewController.h"
// Model
#import "HXSCreditOrderDetailModel.h"
#import "HXSAlipayManager.h"
#import "HXSCreditPayManager.h"
#import "HXSWXApiManager.h"
// Views
#import "HXSOrderAmountTableViewCell.h"
#import "HXSOrderItemCell.h"
#import "HXSOrderDetailTotalAmountCell.h"
#import "HXSOrderDetailFooterView.h"
#import "HXSOrderPayTableViewCell.h"
#import "HXSCreditOrderDetailHeaderTableViewCell.h"
#import "HXSDigitalMobileDetailTableViewCell.h"
#import "HXSDigitalMobileInstallmentTableViewCell.h"
#import "HXSCreditOrderDetailFooterTableViewCell.h"
#import "HXSOrderActivityInfoView.h"
#import "HXSLoadingView.h"
#import "HXSCreditOrderDetialBottomView.h"
#import "HXSActionSheet.h"
#import "HXSAddressInfoTableViewCell.h"
#import "ApplicationSettings.h"


static CGFloat const kheightOrderPayCell                 = 35.0f;
static CGFloat const kheightOrderDetailCell              = 66.0f;
static CGFloat const kheightOrderAmountCell              = 95.0f;
static CGFloat const kheightOrderNumberPayFooter         = 40.0f;
static CGFloat const kheightOrderFooterViewTwoLines      = 60.0f;
static CGFloat const kheightOrderFooterViewThreeLines    = 80.0f;
static CGFloat const kheightDigitalMobileDetailCell      = 100.0f;
static CGFloat const kheightDigitalMobileInstallmentCell = 100.0f;
static CGFloat const kheightBottomView                   = 44.0f;

@interface HXSCreditOrderDetailViewController () <UITableViewDelegate,
                                                  UITableViewDataSource,
                                                  HXSCreditOrderDetialBottomViewDelegate,
                                                  HXSAlipayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HXSCreditOrderDetialBottomView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (nonatomic, strong) HXSCreditOrderDetailModel *creditOrderDetailModel;
@property (nonatomic, strong) HXSOrderInfo *orderInfo;
@property (nonatomic, strong) HXSOrderActivityInfoView *activityInfoView;

@property (nonatomic, assign, getter=isFirstFetching) BOOL firstFetching;

@end

@implementation HXSCreditOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialNavigationBar];
    
    [self initialTableView];
    
    [self initialLoadingData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Inital Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"订单详情";
}

- (void)initialTableView
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 充值
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderAmountTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSOrderAmountTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderItemCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSOrderItemCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderDetailTotalAmountCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSOrderDetailTotalAmountCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderDetailFooterView class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSOrderDetailFooterView class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSOrderPayTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSOrderPayTableViewCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSAddressInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSAddressInfoTableViewCell class])];
    
    
    // 数码
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCreditOrderDetailHeaderTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSCreditOrderDetailHeaderTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileDetailTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileDetailTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileInstallmentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSDigitalMobileInstallmentTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSCreditOrderDetailFooterTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HXSCreditOrderDetailFooterTableViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchDetailData];
    }];
}

- (void)initialLoadingData
{
    // Show the loading view at first time
    [HXSLoadingView showLoadingInView:self.view];
    
    self.firstFetching = YES;
    
    [self fetchDetailData];
}


#pragma mark - Fetch Data
/**
 *  获取订单详情数据
 */
- (void)fetchDetailData
{
    __weak typeof(self) weakSelf = self;
    
    [self.creditOrderDetailModel fetchCreditCardOrderInfoWithOrderInfo:self.orderSNStr
                                                                  type:self.orderTypeIntNum
                                                              complete:^(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo) {
                                                                  if (kHXSNoError != status) {
                                                                      if ([HXSLoadingView isShowingLoadingViewInView:weakSelf.view]) {
                                                                          [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                                                       block:^{
                                                                                                           [weakSelf fetchDetailData];
                                                                                                       }];
                                                                      } else {
                                                                          [weakSelf.tableView endRefreshing];
                                                                          
                                                                          [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                             status:message
                                                                                                         afterDelay:1.5f];
                                                                      }
                                                                      
                                                                      return ;
                                                                  }
                                                                  
                                                                  if (weakSelf.isFirstFetching
                                                                      && (kHXSOrderStautsCommitted == orderInfo.status)) {
                                                                      
                                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                          [HXSLoadingView closeInView:weakSelf.view];
                                                                          
                                                                          [weakSelf fetchDetailData];
                                                                      });
                                                                      
                                                                      weakSelf.firstFetching = NO;
                                                                      
                                                                      return;
                                                                  }
                                                                  
                                                                  [HXSLoadingView closeInView:weakSelf.view];
                                                                  [weakSelf.tableView endRefreshing];
                                                                  
                                                                  weakSelf.orderInfo = orderInfo;
                                                                  [weakSelf.tableView reloadData];
                                                                  [weakSelf updateBottomView];
                                                                  [weakSelf showShareInfos];
                                                              }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 分期订单 分期付款
    if ((kHXSOrderTypeInstallment == self.orderInfo.type)
        && (kHXSOrderInfoInstallmentYES == [self.orderInfo.installmentIntNum integerValue])) {
        return 4;  // 分期信息 
    }
    
    return 3; // 1.状态  2.购买内容  3.订单信息
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
           return (kHXSOrderTypeInstallment == self.orderInfo.type) ? 1:2;
        }
         
            break;
            
        case 1:
        {
            NSInteger itemsCount = [self.orderInfo.items count];
            NSInteger discountCount = [self.orderInfo.discountDetialArr count];
            
            if (kHXSOrderTypeInstallment == self.orderInfo.type) {
                discountCount += 1; // 1 is 运费
            }
            
            return itemsCount + discountCount + 1; // 1 is footer view
        }
            break;
            
        case 2:
        {
            if ((kHXSOrderTypeInstallment == self.orderInfo.type)
                && (kHXSOrderInfoInstallmentYES == [self.orderInfo.installmentIntNum integerValue])) {
                return 1;
            } else {
                return 1;
            }
        }
            break;
            
        case 3: return 1;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kHXSOrderTypeInstallment == self.orderInfo.type) {
        switch (indexPath.section) {
            case 0:
            {
                return [HXSCreditOrderDetailHeaderTableViewCell heightOfHeaderViewForOrder:self.orderInfo];
            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count] + 1; // 1 is 运费
                
                if (indexPath.row < itemsCount) {
                    return kheightDigitalMobileDetailCell;
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    return kheightOrderPayCell;
                } else {
                    return kheightOrderNumberPayFooter;
                }
            }
                break;
                
            case 2:
            {
                if ((kHXSOrderTypeInstallment == self.orderInfo.type)
                    && (kHXSOrderInfoInstallmentYES == [self.orderInfo.installmentIntNum integerValue])) {
                    return kheightDigitalMobileInstallmentCell;
                } else {
                    return [HXSCreditOrderDetailFooterTableViewCell heightOfFooterViewForOrder:self.orderInfo];
                }
            }
                break;
                
            case 3:
            {
                return [HXSCreditOrderDetailFooterTableViewCell heightOfFooterViewForOrder:self.orderInfo];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {

                    return kheightOrderAmountCell;
                }
                else{

                    CGFloat labelDefaultHeight = 14;
                    // 100 is fixed width of padding
                    CGFloat addressInfoHeight = [self.orderInfo.consigneeAddressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, 0)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                                                 context:nil].size.height;
                    // 102 is fixed width of padding
                    CGFloat remarkInfoHeight = [self.orderInfo.remark boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 102, 0)
                                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                                                context:nil].size.height;
                    
                    addressInfoHeight = ( addressInfoHeight == 0 ) ? labelDefaultHeight : ceilf(addressInfoHeight);
                    
                    if ((remarkInfoHeight == 0) || (remarkInfoHeight < labelDefaultHeight)) {
                        remarkInfoHeight = labelDefaultHeight;
                    } else {
                        remarkInfoHeight = ceilf(remarkInfoHeight);
                    }
                    
                    return addressInfoHeight + remarkInfoHeight + 80; // 80 is the rest height except the address & remark labels' height
                }

            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count];
                
                if (indexPath.row < itemsCount) {
                    return kheightOrderDetailCell;
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    return kheightOrderPayCell;
                } else {
                    return kheightOrderNumberPayFooter;
                }
            }
                break;
                
            case 2:
            {
                if (kHXSOrderStautsCommitted == self.orderInfo.status
                    && self.orderInfo
                    && (kHXSOrderTypeOneDream != self.orderInfo.type)) {
                    return kheightOrderFooterViewTwoLines;
                } else {
                    return kheightOrderFooterViewThreeLines;
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (kHXSOrderTypeInstallment == self.orderInfo.type) {
        switch (indexPath.section) {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCreditOrderDetailHeaderTableViewCell class]) forIndexPath:indexPath];
            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count] + 1; // 1 is 运费
                
                if (indexPath.row < itemsCount) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileDetailTableViewCell class]) forIndexPath:indexPath];
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderPayTableViewCell class]) forIndexPath:indexPath];
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderDetailTotalAmountCell class]) forIndexPath:indexPath];
                }
            }
                break;
                
            case 2:
            {
                if ((kHXSOrderTypeInstallment == self.orderInfo.type)
                    && (kHXSOrderInfoInstallmentYES == [self.orderInfo.installmentIntNum integerValue])) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSDigitalMobileInstallmentTableViewCell class]) forIndexPath:indexPath];
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCreditOrderDetailFooterTableViewCell class]) forIndexPath:indexPath];
                }
            }
                break;
                
            case 3:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSCreditOrderDetailFooterTableViewCell class]) forIndexPath:indexPath];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderAmountTableViewCell class]) forIndexPath:indexPath];
                }
                else{
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSAddressInfoTableViewCell class]) forIndexPath:indexPath];
                }
            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count];
                
                if (indexPath.row < itemsCount) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderItemCell class]) forIndexPath:indexPath];
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderPayTableViewCell class]) forIndexPath:indexPath];
                    cell.separatorInset = UIEdgeInsetsMake(0, tableView.width/2.0, 0, tableView.width/2.0);
                } else {
                    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderDetailTotalAmountCell class]) forIndexPath:indexPath];
                }
            }
                break;
                
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSOrderDetailFooterView class]) forIndexPath:indexPath];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kHXSOrderTypeInstallment == self.orderInfo.type) {
        switch (indexPath.section) {
            case 0:
            {
                HXSCreditOrderDetailHeaderTableViewCell *headerCell = (HXSCreditOrderDetailHeaderTableViewCell *)cell;
                
                [headerCell setupCreditOrderHeaderViewWithOrderInfo:self.orderInfo];

            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count] + 1; // 1 is 运费
                
                if (indexPath.row < itemsCount) {
                    HXSDigitalMobileDetailTableViewCell *detailCell = (HXSDigitalMobileDetailTableViewCell *)cell;
                    HXSOrderItem *orderitem = [self.orderInfo.items objectAtIndex:indexPath.row];
                    
                    [detailCell setupCellWithOrderItem:orderitem];
                    
                    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                        [cell setLayoutMargins:UIEdgeInsetsZero];
                    }
                    if (indexPath.row == (itemsCount - 1)) {
                        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    }
                    else {
                        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
                    }
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    HXSOrderPayTableViewCell *payCell = (HXSOrderPayTableViewCell *)cell;
                    
                    if (indexPath.row == (itemsCount + discountCount - 1)) {
                        payCell.ordrePayCouponNameLabel.text = @"运费";
                        payCell.orderPayPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [self.orderInfo.delivery_fee floatValue]];
                    } else {
                        HXSOrderDiscountDetail *discountDetial = [self.orderInfo.discountDetialArr objectAtIndex:(indexPath.row - itemsCount)];
                        
                        [payCell setupOrderPayCellWithDiscountDetail:discountDetial];
                    }
                    
                    payCell.separatorInset = UIEdgeInsetsMake(0, tableView.width/2.0, 0, tableView.width/2.0);
                } else {
                    HXSOrderDetailTotalAmountCell *totalAmountCell = (HXSOrderDetailTotalAmountCell *)cell;
                    
                    [totalAmountCell setupDetialTotalAmountCellWithOrderInfo:self.orderInfo];
                }
            }
                break;
                
            case 2:
            {
                if ((kHXSOrderTypeInstallment == self.orderInfo.type)
                    && (kHXSOrderInfoInstallmentYES == [self.orderInfo.installmentIntNum integerValue])) {
                    HXSDigitalMobileInstallmentTableViewCell *installmentCell = (HXSDigitalMobileInstallmentTableViewCell *)cell;
                    
                    [installmentCell setupCellWithOrderInfo:self.orderInfo];
                    
                } else {
                    HXSCreditOrderDetailFooterTableViewCell *footerCell = (HXSCreditOrderDetailFooterTableViewCell *)cell;
                    
                    [footerCell setupFooterCellWithOrderInfo:self.orderInfo];
                }
            }
                break;
                
            case 3:
            {
                HXSCreditOrderDetailFooterTableViewCell *footerCell = (HXSCreditOrderDetailFooterTableViewCell *)cell;
                
                [footerCell setupFooterCellWithOrderInfo:self.orderInfo];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
            {


                if (0 == indexPath.row) {
             
                    HXSOrderAmountTableViewCell *amountCell = (HXSOrderAmountTableViewCell *)cell;
                
                    [amountCell setupOrderAmountCellWith:self.orderInfo];
                }


                else if (1 == indexPath.row)
                {
                    HXSAddressInfoTableViewCell *addressCell = (HXSAddressInfoTableViewCell *)cell;
                    
                    [addressCell setOrderInfo:self.orderInfo];
                }

            }
                break;
                
            case 1:
            {
                NSInteger itemsCount = [self.orderInfo.items count];
                NSInteger discountCount = [self.orderInfo.discountDetialArr count];
                
                if (indexPath.row < itemsCount) {
                    HXSOrderItemCell *itemCell = (HXSOrderItemCell *)cell;
                    HXSOrderItem *item = [self.orderInfo.items objectAtIndex:indexPath.row];
                    [itemCell configWithOrderItem:item];
                    
                    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                        [cell setLayoutMargins:UIEdgeInsetsZero];
                    }
                    if (indexPath.row == (itemsCount - 1)) {
                        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    }
                    else {
                        cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
                    }
                } else if (indexPath.row < (itemsCount + discountCount)) {
                    HXSOrderPayTableViewCell *payCell = (HXSOrderPayTableViewCell *)cell;
                    HXSOrderDiscountDetail *discountDetial = [self.orderInfo.discountDetialArr objectAtIndex:(indexPath.row - itemsCount)];
                    
                    [payCell setupOrderPayCellWithDiscountDetail:discountDetial];
                } else {
                    HXSOrderDetailTotalAmountCell *totalAmountCell = (HXSOrderDetailTotalAmountCell *)cell;
                    
                    [totalAmountCell setupDetialTotalAmountCellWithOrderInfo:self.orderInfo];
                }
            }
                break;
                
            case 2:
            {
                HXSOrderDetailFooterView *footerView = (HXSOrderDetailFooterView *)cell;
                
                [footerView configWithOrderInfo:self.orderInfo];
            }
                break;
                
            default:
                break;
        }
    }
}



#pragma mark - Refresh Bottom View

- (void)updateBottomView
{
    BOOL hasAddedSubVies = [self.bottomView addSubViewsWithOrderInfo:self.orderInfo delegate:self];
    
    if (hasAddedSubVies) {
        self.bottomViewHeightConstraint.constant = kheightBottomView;
    } else {
        self.bottomViewHeightConstraint.constant = 0.0;
    }
}


#pragma mark - HXSCreditOrderDetialBottomViewDelegate

- (void)clickCommentBtn
{
    HXSCommentViewController *commentVC = [HXSCommentViewController controllerFromXib];
    
    __weak typeof(self) weakSelf = self;
    [commentVC setupOrderInfo:self.orderInfo
                     complete:^{
                         weakSelf.firstFetching = YES;
                         
                         [weakSelf fetchDetailData];
                     }];
    
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)clickLogisticsBtn
{
    HXSLogisticsViewController *logisticsVC = [HXSLogisticsViewController controllerFromXib];
    
    logisticsVC.orderInfo = self.orderInfo;
    
    [self.navigationController pushViewController:logisticsVC animated:YES];
}

- (void)clickConfirmBtn
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    [self.creditOrderDetailModel confirmCreditCardOrderWithOrderSN:self.orderInfo.order_sn
                                                             complete:^(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo) {
                                                                 [MBProgressHUD hideHUDForView:weakSelf.view
                                                                                          animated:YES];
                                                                 
                                                                 if (kHXSNoError != status) {
                                                                     [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                        status:message
                                                                                                    afterDelay:1.0f];
                                                                     
                                                                     return ;
                                                                 }
                                                                 
                                                                 weakSelf.orderInfo = orderInfo;
                                                                 
                                                                 [weakSelf.tableView reloadData];
                                                                 [weakSelf updateBottomView];
                                                                 [weakSelf showShareInfos];
                                                                 
                                                                 [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                    status:message
                                                                                                afterDelay:1.5f];
                                                                 
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                                                                                     object:nil];
                                                                 
                                                             }];

}

- (void)clickCancelBtn
{
    __weak typeof(self) weakSelf = self;
    HXSCustomAlertView *alertView;
    
    if (kHXSOrderInfoInstallmentNO == [self.orderInfo.installmentIntNum integerValue]) {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                      message:@"您确定要取消该订单吗?"
                                              leftButtonTitle:@"取消"
                                            rightButtonTitles:@"确定"];
    } else {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@""
                                                      message:@"您确定要取消分期购订单吗?"
                                              leftButtonTitle:@"不取消"
                                            rightButtonTitles:@"取消订单"];
    }
    
    alertView.rightBtnBlock = ^{
        [MBProgressHUD showInView:weakSelf.view];
        [weakSelf.creditOrderDetailModel cancelCreditCardOrderWithOrderSN:weakSelf.orderInfo.order_sn
                                                                     type:[NSNumber numberWithInteger:weakSelf.orderInfo.type]
                                                                 complete:^(HXSErrorCode status, NSString *message, HXSOrderInfo *orderInfo) {
                                                                     [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                     
                                                                     if (kHXSNoError != status) {
                                                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                            status:message
                                                                                                        afterDelay:1.0f];
                                                                         
                                                                         return ;
                                                                     }
                                                                     
                                                                     weakSelf.orderInfo = orderInfo;
                                                                     
                                                                     [weakSelf.tableView reloadData];
                                                                     [weakSelf updateBottomView];
                                                                     [weakSelf showShareInfos];
                                                                     
                                                                     if (0 >= [message length]) {
                                                                         message = @"订单取消成功";
                                                                     }
                                                                     
                                                                     if (kHXSOrderInfoInstallmentNO == [weakSelf.orderInfo.installmentIntNum integerValue]) {
                                                                         
                                                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                                                            status:message
                                                                                                        afterDelay:1.5f];
                                                                     } else {
                                                                         HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提醒"
                                                                                                                       message:message
                                                                                                               leftButtonTitle:@"确定"
                                                                                                             rightButtonTitles:nil];
                                                                         
                                                                         [alertView show];

                                                                     }
                                                                     
                                                                     [[HXSUserAccount currentAccount].userInfo updateUserInfo];
                                                                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                                                                                         object:nil];
                                                                     
                                                                 }];
    };
    [alertView show];
}

- (void)clickPayBtn
{
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showInView:self.view];
    [HXSActionSheetModel fetchPayMethodsWith:[NSNumber numberWithInt:self.orderInfo.type]
                                   payAmount:self.orderInfo.order_amount
                                 installment:self.orderInfo.installmentIntNum
                                    complete:^(HXSErrorCode code, NSString *message, NSArray *payArr) {
                                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                                        
                                        if (kHXSNoError != code) {
                                            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                                               status:message
                                                                           afterDelay:1.5f];
                                            
                                            return ;
                                        }
                                        
                                        [weakSelf displaySelectPayTypeView:payArr];
                                    }];
}

- (void)clickPayDownPaymentBtn
{
    [self clickPayBtn];
}

- (void)clickOneDreamDetailBtn
{
    HXSOrderItem *item = [self.orderInfo.items firstObject];
    
    HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
    NSString *urlText = [NSString stringWithFormat:@"%@%@",
                         [[ApplicationSettings instance] currentOneDreamDetailURL],
                         item.rid];
    webVCtrl.url = [NSURL URLWithString:urlText];
    
    [self.navigationController pushViewController:webVCtrl animated:YES];
}


#pragma mark - Pay Methods

- (void)displaySelectPayTypeView:(NSArray *)payMethodsArr
{
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:@"请选择支付方式" cancelButtonTitle:@"取消"];
    
    __weak typeof(self) weakSelf = self;
    
    for (int i = 0; i < [payMethodsArr count]; i++) {
        HXSActionSheetEntity *sheetEntity = [payMethodsArr objectAtIndex:i];
        
        switch ([sheetEntity.payTypeIntNum integerValue]) {
            case kHXSOrderPayTypeCash:
            {
                HXSAction *action = [HXSAction actionWithMethods:sheetEntity
                                                         handler:^(HXSAction *action) {
                                                             // Do nothing
                                                         }];
                [sheet addAction:action];
            }
                break;
                
            case kHXSOrderPayTypeZhifu:
            {
                HXSAction *payAction = [HXSAction actionWithMethods:sheetEntity
                                                            handler:^(HXSAction *action) {
                                                                
                                                                [[HXSAlipayManager sharedManager] pay:weakSelf.orderInfo delegate:weakSelf];
                                                            }];
                
                [sheet addAction:payAction];
            }
                break;
                
            case kHXSOrderPayTypeWechatApp:
            {
                HXSAction *wechatPayAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      [[HXSWXApiManager sharedManager] wechatPay:weakSelf.orderInfo delegate:weakSelf];
                                                                  }];
                [sheet addAction:wechatPayAction];
            }
                break;
                
            case kHXSOrderPayTypeCreditCard:
            {
                HXSAction *baiHuahuaAction = [HXSAction actionWithMethods:sheetEntity
                                                                  handler:^(HXSAction *action) {
                                                                      
                                                                      [[HXSCreditPayManager instance] checkCreditPay:^(HXSCreditCheckResultType operation) {
                                                                          if (operation == HXSCreditCheckSuccess) {
                                                                              [weakSelf payOrderWith:kHXSOrderPayTypeCreditCard withErrorMessage:nil];
                                                                          }
                                                                      }];
                                                                  }];
                
                [sheet addAction:baiHuahuaAction];
            }
                break;
                
            case kHXSOrderPayTypeAlipayScan:
            {
                // Do nothing
            }
                break;
                
            default:
                break;
        }
    }
    
    [sheet show];
}


#pragma mark - Baihuahua Methods

- (void)payOrderWith:(HXSOrderPayType)payType withErrorMessage:(NSString *)errorMessageStr
{
    switch (payType) {
        case kHXSOrderPayTypeCreditCard:
        {
            HXSOrderItem *itemEntity = [[self.orderInfo items] firstObject];
            NSString *titleStr                = itemEntity.name;
            
            HXSCreditPayOrderInfo *order = [[HXSCreditPayOrderInfo alloc] init];
            if (kHXSOrderInfoInstallmentNO == [self.orderInfo.installmentIntNum integerValue]) {
                order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeNormal];
                order.periodsIntNum          = [NSNumber numberWithInteger:1];
            } else {
                order.tradeTypeIntNum        = [NSNumber numberWithInteger:kHXStradeTypeInstallment];
                order.periodsIntNum          = self.orderInfo.installmentNumIntNum;
            }
            order.orderSnStr             = [NSString stringWithFormat:@"%@", self.orderInfo.order_sn];
            order.orderTypeIntNum        = [NSNumber numberWithInteger:self.orderInfo.type];
            order.amountFloatNum         = self.orderInfo.order_amount;
            order.discountFloatNum       = self.orderInfo.discount;
            order.orderDescriptionStr    = titleStr;
            
            __weak typeof(self) weakSelf = self;
            [[HXSCreditPayManager instance] payOrder:order completion:^(HXSCreditPayResulType operation, NSString *message, NSDictionary *info) {
                switch (operation) {
                    case HXSCreditPaySuccess:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:YES];
                    }
                        break;
                    case HXSCreditPayCanceled:
                    {
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayGetPasswdBack:
                    {
                        //[self dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                    case HXSCreditPayFailed:
                    {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                        [weakSelf dealWithBaiHuaHuaResult:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
            }];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealWithBaiHuaHuaResult:(BOOL)hasPaid
{
    HXSCustomAlertView *alertView = nil;
    
    if (hasPaid) {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付成功"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                            object:nil];
        
        self.firstFetching = YES;
        
        [self fetchDetailData];
        
    } else {
        alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                      message:@"支付失败"
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
    }
    
    [alertView show];
}



#pragma mark - pay call back

- (void)payCallBack:(NSString *)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    if(status.intValue == 9000) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                            object:nil];
        self.firstFetching = YES;
        
        [self fetchDetailData];
        messageStr = @"支付成功";
    }else if(status.intValue == 6001){
        messageStr = (message && message.length > 0)?message:@"用户取消";
    }else if(status.intValue == 4000) {
        messageStr = @"支付失败";
    }else if (message.length > 0) {
        messageStr = message;
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
    
}

#pragma mark - HXSWechatPayDelegate

- (void)wechatPayCallBack:(HXSWechatPayStatus)status message:(NSString *)message result:(NSDictionary *)result
{
    NSString *messageStr = nil;
    
    if (HXSWechatPayStatusSuccess == status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CREDIT_PAY_SUCCESS
                                                            object:nil];
        self.firstFetching = YES;
        
        [self fetchDetailData];
        messageStr = @"支付成功";
    } else {
        messageStr = @"支付失败";
    }
    
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"支付结果"
                                                                      message:messageStr
                                                              leftButtonTitle:@"确定"
                                                            rightButtonTitles:nil];
    [alertView show];
}


#pragma mark - Show Share Views

- (void)showShareInfos
{
    [self.activityInfoView showActivityInfos:self.orderInfo.activityInfos
                                      inView:self.view
                                 bottomSpace:((0 > self.bottomViewHeightConstraint.constant) ? 0.0 : 45)];
}


#pragma mark - Setter Getter Methods

- (HXSCreditOrderDetailModel *)creditOrderDetailModel
{
    if (nil == _creditOrderDetailModel) {
        _creditOrderDetailModel = [[HXSCreditOrderDetailModel alloc] init];
    }
    
    return _creditOrderDetailModel;
}

- (HXSOrderActivityInfoView *)activityInfoView
{
    if (nil == _activityInfoView) {
        _activityInfoView = [[HXSOrderActivityInfoView alloc] init];
        _activityInfoView.backgroundColor = [UIColor clearColor];
    }
    
    return _activityInfoView;
}


@end
