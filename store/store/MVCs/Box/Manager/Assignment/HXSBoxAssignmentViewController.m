//
//  HXSBoxAssignmentViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  转让零食盒

#import "HXSBoxAssignmentViewController.h"
#import "HXSBoxModel.h"
#import "HXSBoxMacro.h"

@interface HXSBoxAssignmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *sharersArr;
@property (nonatomic, strong) NSNumber *boxIdNum;
@property (nonatomic, strong) NSNumber *batchNoNum;
@property (nonatomic, assign) BOOL isTransfering; // 是否用户正在转让中
@property (nonatomic, strong) HXSBoxUserEntity *currentSelectUserEntity;

@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation HXSBoxAssignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialPrama];
    [self initialTable];
    [self getSharesWebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initial

- (void)initialNav{
   self.navigationItem.title = @"转让零食盒";
}

- (void)initialTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    self.myTable.rowHeight = 44;
    [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)initialPrama{
    self.sharersArr = [NSMutableArray array];
    self.isTransfering = NO;
}

+ (instancetype)controllerWithBoxId:(NSNumber *)boxId batchId:(NSNumber *)batchNo{
    HXSBoxAssignmentViewController *conrtoller = [[HXSBoxAssignmentViewController alloc]initWithNibName:nil bundle:nil];
    conrtoller.batchNoNum = batchNo;
    conrtoller.boxIdNum = boxId;
    return conrtoller;
}

#pragma mark - webService
- (void)getSharesWebService
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetSharerListWithBoxId:self.boxIdNum batchNo:self.batchNoNum ifWithBill:NO complete:^(HXSErrorCode code, NSString *message, NSArray *boxerInfoArr, NSArray *sharedInfoArr) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            [weakSelf.sharersArr removeAllObjects];
            [weakSelf.sharersArr addObjectsFromArray:sharedInfoArr];
            [weakSelf getTransferStatus];
            [weakSelf.myTable reloadData];
            
            if(weakSelf.sharersArr.count > 0){
                [weakSelf.myTable setTableFooterView:nil];
            }else{
                [weakSelf.myTable setTableFooterView:weakSelf.tableFooterView];
            }
        }else{
            [weakSelf.myTable setTableFooterView:nil];
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
        
    }];
}


- (void)transferBox
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel tansferBoxWithBoxId:self.boxIdNum
                              userId:self.currentSelectUserEntity.uidNum
                            complete:^(HXSErrorCode code, NSString *message, NSDictionary *dic) {
                                [HXSLoadingView closeInView:weakSelf.view];
                                if(kHXSNoError == code){
                                    
                                    weakSelf.currentSelectUserEntity = nil;
                                    [weakSelf getSharesWebService];
                                    
                                }else{
                                    
                                    weakSelf.currentSelectUserEntity = nil;
                                    [weakSelf.myTable reloadData];
                                    weakSelf.myTable.allowsSelection = YES;
                                    if(code == 7023){
                                        HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"转让失败"
                                                                                                     message:message
                                                                                             leftButtonTitle:@"取消"
                                                                                           rightButtonTitles:@"确定"];
                                        [alert show];
                                    }
                                }
    }];
 
}

#pragma mark - Others

- (void)getTransferStatus{
    for(HXSBoxUserEntity *userEntity in self.sharersArr){
        if(userEntity.transferStatusNum.intValue == HXSBoxTransferStatusTransfer){
            self.isTransfering = YES;
            self.myTable.allowsSelection = NO;
            return;
        }
    }
    self.isTransfering = NO;
    self.myTable.allowsSelection = YES;
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sharersArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"BoxManageSharerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(nil == cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell.textLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HXSBoxUserEntity *userEntity = [self.sharersArr objectAtIndex:indexPath.row];
    cell.textLabel.text = userEntity.unameStr;
    
    if(self.currentSelectUserEntity == userEntity){
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
    }else{
        cell.accessoryView = nil;
    }
    
    if(userEntity.transferStatusNum.intValue == HXSBoxTransferStatusTransfer){
        [cell.detailTextLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
        cell.detailTextLabel.text = @"转让中...";
    }else{
        cell.detailTextLabel.text = @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [HXSUsageManager trackEvent:kUsageEventBoxTransferUseListItemClick parameter:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXSBoxUserEntity *userEntity = [self.sharersArr objectAtIndex:indexPath.row];
    self.currentSelectUserEntity = userEntity;
    [self.myTable reloadData];
    
    NSString *messageStr = [NSString stringWithFormat:@"您确定把零食盒转让给%@？",self.currentSelectUserEntity.unameStr];
    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"确认转让"
                                                                 message:messageStr
                                                         leftButtonTitle:@"取消"
                                                       rightButtonTitles:@"确定"];
    __weak typeof(self) weakSelf = self;
    alert.leftBtnBlock = ^{
        weakSelf.currentSelectUserEntity = nil;
        [weakSelf.myTable reloadData];
        weakSelf.myTable.allowsSelection = YES;
    };
    alert.rightBtnBlock = ^{
        [HXSUsageManager trackEvent:kUsageEventBoxConfirmTransfer parameter:nil];
        [weakSelf transferBox];
    };
    [alert show];
}

#pragma mark - GET && SET Methods

- (void)setBoxIdNum:(NSNumber *)boxIdNum{
    _boxIdNum = nil;
    _boxIdNum = [boxIdNum copy];
}

- (void)setBatchNoNum:(NSNumber *)batchNoNum{
    _batchNoNum = nil;
    _batchNoNum = [batchNoNum copy];
}

- (UIView *)tableFooterView{
    if(!_tableFooterView){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 190)];
        UIImageView *imgeView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, 80, 80, 80)];
        imgeView.image = [UIImage imageNamed:@"img_lingshihe_wugongxiangren"];
        [view addSubview:imgeView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 20)];
        [label setTextColor:[UIColor colorWithRGBHex:0xcacaca]];
        [label setText:@"没有可转让的共享人"];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        _tableFooterView = view;
    }
    return _tableFooterView;
}
@end
