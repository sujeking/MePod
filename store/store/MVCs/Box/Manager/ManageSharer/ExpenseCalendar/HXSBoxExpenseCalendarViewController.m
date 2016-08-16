//
//  HXSBoxExpenseCalendarViewController.m
//  store
//
//  Created by 格格 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  XX的消费记录

#import "HXSBoxExpenseCalendarViewController.h"
#import "HXSBoxMacro.h"
#import "HXSBoxModel.h"
#import "HXSMyOrderHeaderTableViewCell.h"
#import "HXSMyOderTableViewCell.h"
#import "HXSMyOderFooterTableViewCell.h"
#import "HXSBoxOrderViewController.h"


static NSString *myOrderHeaderCellIdentifier = @"HXSMyOrderHeaderTableViewCell";
static NSString *myOrderCellIdentifier       = @"HXSMyOderTableViewCell";
static NSString *myOrderFooterCellIdentifier = @"HXSMyOderFooterTableViewCell";

@interface HXSBoxExpenseCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *expenseCalendarArr;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) HXSBoxUserEntity *boxUserEntity;
@property (nonatomic, strong) NSNumber *boxIdNum; // 盒子id
@property (nonatomic, strong) NSNumber *batchNoNum;// 盒子批次号
@property (nonatomic, strong) NSNumber *isBoxerNum; // 判断当前登录者是不是盒主

@property (nonatomic, weak) IBOutlet UIButton *deleteSharerButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *deleteSharerButtonBottom;

@end

@implementation HXSBoxExpenseCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialParam];
    [self initialTable];
    [self getExpenseCalendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (instancetype)controllerWithBoxUserEntity:(HXSBoxUserEntity *)boxUserEntity
                                   boxIdNum:(NSNumber *)boxIdNum
                                 batchNoNum:(NSNumber *)batchNoNum
                                 isBoxerNum:(NSNumber *)isBoxerNum{
    HXSBoxExpenseCalendarViewController *controller = [[HXSBoxExpenseCalendarViewController alloc]initWithNibName:nil bundle:nil];
    controller.boxUserEntity = boxUserEntity;
    controller.boxIdNum = boxIdNum;
    controller.batchNoNum = batchNoNum;
    controller.isBoxerNum = isBoxerNum;
    return controller;
    
}
#pragma mark - initial 

- (void)initialParam{
    [self initialDeleteSharerButton];
    self.expenseCalendarArr = [NSMutableArray array];
    [self reflashUI];
}

- (void)initialDeleteSharerButton{
    self.deleteSharerButton.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.deleteSharerButton.layer.borderWidth = 1;
    [self.deleteSharerButton addTarget:self action:@selector(removeSharerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteSharerButton setTitleColor:[UIColor colorWithR:7 G:169 B:250 A:1] forState:UIControlStateNormal];
    [self.deleteSharerButton setTitleColor:[UIColor colorWithR:7 G:169 B:250 A:0.5] forState:UIControlStateDisabled];
}

- (void)initialTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    [self.myTable registerNib:[UINib nibWithNibName:myOrderHeaderCellIdentifier bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderHeaderCellIdentifier];
    [self.myTable registerNib:[UINib nibWithNibName:myOrderCellIdentifier bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderCellIdentifier];
    [self.myTable registerNib:[UINib nibWithNibName:myOrderFooterCellIdentifier bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:myOrderFooterCellIdentifier];
}

- (void)reflashUI{
    self.navigationItem.title = [NSString stringWithFormat:@"%@的消费记录",_boxUserEntity.unameStr];
    
    if(self.isBoxerNum.intValue == HXSBoxUserStatusYes){// 盒子主人登录
        // 如果是盒主自己，不显示移除共享人按钮
        if(self.boxUserEntity.typeNum.intValue == HXSBoxUserStatusBoxer){
            self.deleteSharerButtonBottom.constant = -45;
        }else{
            if(self.boxUserEntity.statusNum.intValue == HXSBoxShareStatusRemoved ||self.boxUserEntity.statusNum.intValue == HXSBoxShareStatusQuit ){
                self.deleteSharerButtonBottom.constant = -1;
                [self.deleteSharerButton setTitle:@"本期结算后将移除" forState:UIControlStateNormal];
                self.deleteSharerButton.enabled = NO;
            }else if(self.boxUserEntity.statusNum.intValue == HXSBoxShareStatusNormal){
                self.deleteSharerButtonBottom.constant = -1;
                self.deleteSharerButton.enabled = YES;
            }else{
                self.deleteSharerButtonBottom.constant = -45;
            }
        }
    }else{// 分享者登录
        self.deleteSharerButtonBottom.constant = -45;
    }    
}

#pragma mark - Target/Action
- (void)removeSharerButtonClicked{

    [HXSUsageManager trackEvent:kUsageEventBoxRemoveShared parameter:nil];

    NSString *message = [NSString stringWithFormat:@"您确定不再共享给%@吗？",self.boxUserEntity.unameStr];
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"移除共享人"
                                                                 message:message
                                                         leftButtonTitle:@"取消"
                                                       rightButtonTitles:@"确认"];
    WS(weakSelf);
    alert.rightBtnBlock = ^{
        [HXSUsageManager trackEvent:kUsageEventBoxRemoveSharedConfirm parameter:nil];
        [weakSelf removeSharer];
    };
    [alert show];
}

#pragma mark - webService
- (void)getExpenseCalendar
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSBoxModel fetOrderListWithUid:self.boxUserEntity.uidNum boxId:self.boxIdNum batchNo:self.batchNoNum withOrderItems:YES withOrderPays:NO complete:^(HXSErrorCode code, NSString *message, NSArray *orders) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            [weakSelf.expenseCalendarArr removeAllObjects];
            [weakSelf.expenseCalendarArr addObjectsFromArray:orders];
            
            if(weakSelf.expenseCalendarArr.count > 0){
                [weakSelf.myTable setTableFooterView:nil];
            }else{
                [weakSelf.myTable setTableFooterView:weakSelf.tableFooterView];

            }
            
            [weakSelf.myTable reloadData];
        }else{
            [weakSelf.myTable setTableFooterView:nil];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)removeSharer{

    [HXSLoadingView showLoadingInView:self.view];
    WS(weakSelf);
    [HXSBoxModel boxRemoveSharerWithBoxId:self.boxIdNum
                                      uid:self.boxUserEntity.uidNum
                                 complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                     [HXSLoadingView closeInView:weakSelf.view];
                                     if(kHXSNoError == code){
                                         if(weakSelf.removeShareCompleteBlock)
                                             weakSelf.removeShareCompleteBlock();
                                         weakSelf.boxUserEntity.statusNum = @(HXSBoxShareStatusRemoved);
                                         [weakSelf reflashUI];
                                     }else{
                                         [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
                                     }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.expenseCalendarArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    HXSBoxOrderModel *boxOrderModel = [self.expenseCalendarArr objectAtIndex:section];
    return boxOrderModel.itemsArr.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSBoxOrderModel *boxOrderModel = [self.expenseCalendarArr objectAtIndex:indexPath.section];
    if(0 == indexPath.row){
        return 44;
    }else if(boxOrderModel.itemsArr.count + 1 == indexPath.row){
        return 44;
    }else{
        return 92;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSBoxOrderModel *boxOrderModel = [self.expenseCalendarArr objectAtIndex:indexPath.section];
    if(0 == indexPath.row){
        
        HXSMyOrderHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderHeaderCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.boxOrderModel = boxOrderModel;
        return cell;
        
    }else if(boxOrderModel.itemsArr.count + 1 == indexPath.row){
        HXSMyOderFooterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:myOrderFooterCellIdentifier];
        cell.boxOrderModel = boxOrderModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        HXSMyOderTableViewCell * cell = (HXSMyOderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:myOrderCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HXSBoxOrderItemModel *orderItem = [boxOrderModel.itemsArr objectAtIndex:indexPath.row - 1];
        cell.boxOrderItemModel = orderItem;
        
        if (indexPath.row == boxOrderModel.itemsArr.count) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        else {
            cell.separatorInset = UIEdgeInsetsMake(0, 96, 0, 0);
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.boxUserEntity.typeNum.intValue == HXSBoxUserStatusSharer)
        [HXSUsageManager trackEvent:kConsumptionRecordItrmClick parameter:@{@"operator":@"共享人"}];
    else
        [HXSUsageManager trackEvent:kConsumptionRecordItrmClick parameter:@{@"operator":@"盒主"}];
    
    HXSBoxOrderModel *boxOrderModel = [self.expenseCalendarArr objectAtIndex:indexPath.section];
    HXSBoxOrderViewController *boxOrderDetialVC = [[HXSBoxOrderViewController alloc]initWithNibName:nil bundle:nil];
    boxOrderDetialVC.orderSNStr = boxOrderModel.orderIdStr;
    [self.navigationController pushViewController:boxOrderDetialVC animated:YES];
}

#pragma mark - setter
- (void)setBoxUserEntity:(HXSBoxUserEntity *)boxUserEntity{
    _boxUserEntity = boxUserEntity;
}

- (void)setBoxIdNum:(NSNumber *)boxIdNum{
    _boxIdNum = nil;
    _boxIdNum = [boxIdNum copy];
}

- (void)setBatchNoNum:(NSNumber *)batchNoNum{
    _batchNoNum = nil;
    _batchNoNum = [batchNoNum copy];
}

- (void)setIsBoxerNum:(NSNumber *)isBoxerNum{
    _isBoxerNum = nil;
    _isBoxerNum = [isBoxerNum copy];
}

#pragma mark - getter
- (UIView *)tableFooterView{
    if(!_tableFooterView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 190)];
        UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, 80, 80, 80)];
        imgeView.image = [UIImage imageNamed:@"img_empty_cash_record"];
        [view addSubview:imgeView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 20)];
        [label setTextColor:[UIColor colorWithRGBHex:0x999999]];
        [label setText:@"暂无消费记录"];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        _tableFooterView = view;
    }
    return _tableFooterView;
}

@end
