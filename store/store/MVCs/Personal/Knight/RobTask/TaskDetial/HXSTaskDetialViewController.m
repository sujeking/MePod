//
//  HXSTaskDetialViewController.m
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSKnight.h"
// Controllers
#import "HXSTaskDetialViewController.h"
#import "HXSTaskQRCodeViewController.h"

// Views
#import "HXSActionSheet.h"
#import "HXSTaskDetialGoodsCell.h"
#import "HXSTaskDetialOrderStateCell.h"
#import "HXSTaskDetialInfoCell.h"
#import "HXSTaskDetialTimeCell.h"
#import "HXSTaskTotalNumCell.h"
#import "HXSTaskOrderTimeCell.h"
#import "HXSTaskOrderFeeCell.h"

// Model
#import "HXSTaskDetialModel.h"

static NSString *HXSTaskDetialGoodsCellId = @"HXSTaskDetialGoodsCell";
static NSString *HXSTaskDetialOrderStateCellId = @"HXSTaskDetialOrderStateCell";
static NSString *HXSTaskDetialInfoCellId = @"HXSTaskDetialInfoCell";
static NSString *HXSTaskDetialTimeCellId = @"HXSTaskDetialTimeCell";
static NSString *HXSTaskTotalNumCellId = @"HXSTaskTotalNumCell";
static NSString *HXSTaskOrderTimeCellId = @"HXSTaskOrderTimeCell";
static NSString *HXSTaskOrderFeeCellId = @"HXSTaskOrderFeeCell";

@interface HXSTaskDetialViewController ()< UITableViewDelegate,
                                            UITableViewDataSource,
                                            HXSTaskDetialInfoCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTable;

@property (nonatomic, weak) IBOutlet UIView *actionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionViewHeight;
@property (nonatomic, weak) IBOutlet UIButton *cancleButton;
@property (nonatomic, weak) IBOutlet UIButton *QRCodeButton;
@property (nonatomic, weak) IBOutlet UIButton *finishButton;

@property (nonatomic, strong) HXSTaskOrder *taskOrder;
@property (nonatomic, strong) HXSTaskOrderDetial *orderDetial;

@end

@implementation HXSTaskDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadOrderDetial) name:KnightOrderStatusUpdate object:nil];
    
    [self initialNav];
    [self initialPrama];
    [self initialTable];
    
    self.actionView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadOrderDetial];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - initial
- (void) setTaskOrderEntity:(HXSTaskOrder *)taskOrder{
    self.taskOrder = taskOrder;
}

- (void)initialPrama{
    self.actionView.clipsToBounds = YES;
    self.actionView.layer.borderColor = [UIColor colorWithRGBHex:0xe1e2e3].CGColor;
    self.actionView.layer.borderWidth = 1;
    
    self.cancleButton.layer.borderColor = [UIColor colorWithRGBHex:0xe1e2e3].CGColor;
    self.cancleButton.layer.borderWidth = 1;
    
    [self.cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.QRCodeButton addTarget:self action:@selector(QRCodeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.finishButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initialNav{
 
    self.navigationItem.title = @"订单详情";
}

- (void)initialTable{
    
    [self.myTable setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    [self.myTable setSeparatorColor:[UIColor colorWithRGBHex:0xe1e2e3]];
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskDetialGoodsCellId bundle:nil] forCellReuseIdentifier:HXSTaskDetialGoodsCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskDetialOrderStateCellId bundle:nil] forCellReuseIdentifier:HXSTaskDetialOrderStateCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskDetialInfoCellId bundle:nil] forCellReuseIdentifier:HXSTaskDetialInfoCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskDetialTimeCellId bundle:nil] forCellReuseIdentifier:HXSTaskDetialTimeCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskTotalNumCellId bundle:nil] forCellReuseIdentifier:HXSTaskTotalNumCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskOrderTimeCellId bundle:nil] forCellReuseIdentifier:HXSTaskOrderTimeCellId];
    [self.myTable registerNib:[UINib nibWithNibName:HXSTaskOrderFeeCellId bundle:nil] forCellReuseIdentifier:HXSTaskOrderFeeCellId];
    
    [self.myTable setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
}

#pragma mark - webService
- (void)loadOrderDetial{
    
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    [HXSTaskDetialModel getTaskOrderDerialWithDeliveryOrderId:self.taskOrder.deliveryOrderIdStr complete:^(HXSErrorCode code, NSString *message, HXSTaskOrderDetial *orderDetial) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if(kHXSNoError == code){
            weakSelf.orderDetial = orderDetial;
            weakSelf.myTable.delegate = weakSelf;
            weakSelf.myTable.dataSource = weakSelf;
            [weakSelf.myTable reloadData];
            [weakSelf reflashAction];
            
        }else{
            
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)cancleOrder{
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    
    [HXSTaskDetialModel cancleKnightDeliveryOrderWithDeliveryorderId:self.orderDetial.deliveryOrderStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code){
//            [weakSelf loadOrderDetial];
            [[NSNotificationCenter defaultCenter]postNotificationName:KnightCancleTaskSuccess object:weakSelf];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view.window status:@"取消成功！" afterDelay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - others
- (void)reflashAction{
    if(!self.orderDetial)
        return;
    
    self.actionView.hidden = NO;
    
    switch (self.orderDetial.statusIntNum.intValue) {
        case HXSKnightDeliveryStatusWaitingGet:
            self.actionView.hidden = NO;
            self.cancleButton.hidden = NO;
            self.QRCodeButton.hidden = NO;
            self.finishButton.hidden = YES;
            self.actionViewHeight.constant = 44;
            break;
        case HXSKnightDeliveryStatusDelivering:
            self.actionView.hidden = NO;
            self.cancleButton.hidden = YES;
            self.QRCodeButton.hidden = YES;
            self.finishButton.hidden = NO;
            self.actionViewHeight.constant = 44;
            break;
        case HXSKnightDeliveryStatusFinish:
            self.actionViewHeight.constant = 0;
            self.actionView.hidden = YES;
            break;
        case HXSKnightDeliveryStatusCancle:
            self.actionViewHeight.constant = 0;
            self.actionView.hidden = YES;
            break;
        case HXSKnightDeliveryStatusSettled:
            self.actionViewHeight.constant = 0;
            self.actionView.hidden = YES;
            break;
        default:
            self.actionViewHeight.constant = 0;
            self.actionView.hidden = YES;
            break;
    }
}

#pragma mark - Target/Action
// 取消订单
- (void)cancleButtonClicked{
    
    [HXSUsageManager trackEvent:kUsageEventKnightCancleDelivery parameter:nil];

    __weak typeof(self) weakSelf = self;
    HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"您确定要取消配送吗？"
                                                                      message:@"一天内取消订单超过3次，\n七天内您将被禁止抢单！"
                                                              leftButtonTitle:@"取消配送"
                                                            rightButtonTitles:@"继续配送"];
    alertView.leftBtnBlock = ^{
        
        [HXSUsageManager trackEvent:kUsageEventKnightCancleDeliveryComfirm parameter:@{@"status":@"确认"}];
        [weakSelf cancleOrder];
    };
    
    [alertView show];
}

// 二维码
-(void)QRCodeButtonClicked{
    
    HXSTaskQRCodeViewController *taskQRCodeViewController = [[HXSTaskQRCodeViewController alloc]initWithNibName:nil bundle:nil];
    [taskQRCodeViewController setTaskOrderEntity:self.taskOrder];
    [self.navigationController pushViewController:taskQRCodeViewController animated:YES];
}

// 完成订单
-(void)finishButtonClicked{
    
    [HXSUsageManager trackEvent:kUsageEventKnightComfirmDelivery parameter:nil];
    
    [MBProgressHUD showInView:self.view];
    __weak typeof (self) weakSelf = self;
    
    [HXSTaskDetialModel finishKnightDeliveryOrderWithDeliveryOrderId:self.orderDetial.deliveryOrderStr complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if(kHXSNoError == code){
//            [weakSelf loadOrderDetial];
            // 发送通知,更新待处理列表
            [[NSNotificationCenter defaultCenter]postNotificationName:KnightFinishTaskSuccess object:weakSelf];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view.window status:@"确认成功!" afterDelay:1.5];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableVieDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section){
        return self.orderDetial.itemsArr.count + 1;
    }else if(1 == section){
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 == section)
        return 0.1;
    else
        return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( 0 == indexPath.section){
        if(indexPath.row < self.orderDetial.itemsArr.count){
            return 80;
        }else{
            return 44;
        }
    }else if(1 == indexPath.section){
        if( 0 == indexPath.row){
            return 44;
        }else if(1 == indexPath.row){
            return 140 + [self.orderDetial buyerAddressAddHeight:72] + [self.orderDetial shopAddressAddHeight:72] + [self.orderDetial remarkAddHeight:72];

        }else{
            if(self.orderDetial.statusIntNum.integerValue == HXSKnightDeliveryStatusCancle)
                return 60;
            return 44;
        }
        
    }else{
        if(0 == indexPath.row){
            return 44;
        }else{
            
            switch (self.orderDetial.statusIntNum.intValue) {
                case HXSKnightDeliveryStatusWaitingGet:
                    return 44;
                    break;
                case HXSKnightDeliveryStatusDelivering:
                    return 68;
                    break;
                case HXSKnightDeliveryStatusFinish:
                    return 90;
                    break;
                case HXSKnightDeliveryStatusCancle:
                {
                    if(self.orderDetial.claimTimeLongNum)
                        return 68;
                    return 44;
                }
                    break;
                default:
                    return 0;
                    break;
            }
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( 0 == indexPath.section){
        if(indexPath.row < self.orderDetial.itemsArr.count){
            HXSTaskDetialGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSTaskDetialGoodsCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskItem = [self.orderDetial.itemsArr objectAtIndex:indexPath.row];
            return cell;
        }else{
            HXSTaskTotalNumCell *cell = (HXSTaskTotalNumCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskTotalNumCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }
    }else if(1 == indexPath.section){
        if( 0 == indexPath.row){
            HXSTaskDetialOrderStateCell *cell = (HXSTaskDetialOrderStateCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskDetialOrderStateCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }else if(1 == indexPath.row){
            HXSTaskDetialInfoCell *cell = (HXSTaskDetialInfoCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskDetialInfoCellId];
            cell.delete = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }else{
            HXSTaskOrderTimeCell *cell = (HXSTaskOrderTimeCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskOrderTimeCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }
    
    }else{
        if(0 == indexPath.row){
            HXSTaskOrderFeeCell *cell = (HXSTaskOrderFeeCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskOrderFeeCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }else{
            HXSTaskDetialTimeCell *cell = (HXSTaskDetialTimeCell *)[tableView dequeueReusableCellWithIdentifier:HXSTaskDetialTimeCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.taskOrderDetial = self.orderDetial;
            return cell;
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section){
        if(self.orderDetial.itemsArr.count - 1 > indexPath.row){
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 80, 0, 0)];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 80, 0, 0)];
            }
        }else{
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
            
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }
    }else if(1 == indexPath.section){
        if(2 != indexPath.row){
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
    }else{
        if(1 != indexPath.row){
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
}


#pragma mark - HXSTaskDetialInfoCellDelegate

- (void)buyerPhoneClicked:(HXSTaskOrderDetial *)taskOrderDetial{
    [HXSUsageManager trackEvent:kUsageEventKnightCallPhone parameter:@{@"phone_type":@"买家电话"}];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = taskOrderDetial.buyerPhoneStr;
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     
                                                     [HXSUsageManager trackEvent:kUsageEventKnightBuyersCallComfim parameter:@{@"status":@"确认"}];
                                                     
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:taskOrderDetial.buyerPhoneStr];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];

}
- (void)shopPhoneClicked:(HXSTaskOrderDetial *)taskOrderDetial{
    [HXSUsageManager trackEvent:kUsageEventKnightCallPhone parameter:@{@"phone_type":@"卖家电话"}];
    
    HXSActionSheet *sheet = [HXSActionSheet actionSheetWithMessage:nil cancelButtonTitle:@"取消"];
    
    HXSActionSheetEntity *callEntity = [[HXSActionSheetEntity alloc] init];
    callEntity.nameStr = taskOrderDetial.shopPhoneStr;
    
    HXSAction *callAction = [HXSAction actionWithMethods:callEntity
                                                 handler:^(HXSAction *action) {
                                                     
                                                     [HXSUsageManager trackEvent:kUsageEventKnightSellerCallComfifm parameter:@{@"status":@"确认"}];
                                                     
                                                     NSString *phoneNumber = [@"tel://" stringByAppendingString:taskOrderDetial.shopPhoneStr];
                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                                                 }];
    
    [sheet addAction:callAction];
    
    [sheet show];
    
}
@end
