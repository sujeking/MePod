//
//  HXSBoxCheckViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//  

#import "HXSBoxCheckViewController.h"
#import "HXSBoxMacro.h"

// Controllers
#import "HXSBoxConsumptionListViewController.h"
#import "HXSBoxOwnerInfoView.h"

// Model
#import "HXSBoxInfoEntity.h"
#import "HXSBoxModel.h"

// Views
#import "HXSBoxCheckCell.h"

static NSString *HXSBoxCheckCellId = @"HXSBoxCheckCell";

@interface HXSBoxCheckViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView            *myTable;
@property (nonatomic, weak) IBOutlet UIButton               *getConsumerListButton;
@property (nonatomic, strong) NSMutableArray                *snacksArr;
@property (nonatomic, strong) NSNumber                      *quantity;
@property (nonatomic, strong) UIView                        *sectionHeaderView;

@property (nonatomic, strong) HXSBoxOwnerInfoView           *boxOwnerInfoView;
@property (nonatomic, strong) HXSBoxInfoEntity              *boxInfoEntity;
@property (nonatomic, strong) HXSCustomAlertView            *alertView;

@property (nonatomic, copy) void (^refreshBoxInfo)(void);

@end

@implementation HXSBoxCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialParama];
    
    [self initialTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"零食盒";
}

- (void)initialParama
{
    self.quantity = @(0);
    self.snacksArr = [NSMutableArray array];
    self.getConsumerListButton.layer.borderColor = HXS_COLOR_SEPARATION_STRONG.CGColor;
    self.getConsumerListButton.layer.borderWidth = 1;
    [self.getConsumerListButton addTarget:self action:@selector(getConsumerListButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    UIView *tableViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [tableViewHeader addSubview:self.boxOwnerInfoView];
    [self.boxOwnerInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableViewHeader);
    }];
    [self.myTable setTableHeaderView:tableViewHeader];
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSBoxCheckCellId bundle:nil] forCellReuseIdentifier:HXSBoxCheckCellId];
}

#pragma mark - Public Methods

+ (instancetype)createBoxCheckVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity
                                    refresh:(void (^)(void))refreshBoxInfo
{
    HXSBoxCheckViewController *boxCheckVC = [HXSBoxCheckViewController controllerFromXib];
    
    boxCheckVC.boxInfoEntity = boxInfoEntity;
    boxCheckVC.refreshBoxInfo = refreshBoxInfo;
    
    return boxCheckVC;
}

- (void)refresh
{
    [self getBoxInfoWithGoToConsumptionList:NO];
}


#pragma mark - webService

- (void)getBoxInfoWithGoToConsumptionList:(BOOL)goToConsumptionList
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetchBoxInfo:^(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity) {
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(kHXSNoError == code){
            
            // 如果获取到的状态不是清单中和结算中状态，则pop出界面
            if(boxInfoEntity.statusNum.intValue < kHXSBoxStatusChecking)
                [weakSelf.navigationController popViewControllerAnimated:YES];
            
            weakSelf.boxInfoEntity = boxInfoEntity;
            [weakSelf.boxOwnerInfoView initialBoxInfo:boxInfoEntity];
            // 如果需要跳转到消费清单列表，并且盒子状态为结算中
            if(goToConsumptionList){
                if(weakSelf.boxInfoEntity.statusNum.intValue == kHXSBoxStatusClearing){
                    HXSBoxConsumptionListViewController *boxConsumptionListViewController = [HXSBoxConsumptionListViewController cantrollerWithBoxInfoEntity:self.boxInfoEntity];
                    [weakSelf.navigationController pushViewController:boxConsumptionListViewController animated:YES];
                }else{
                    HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:nil
                                                                                 message:@"清点中，请稍候..."
                                                                         leftButtonTitle:@"确定"
                                                                       rightButtonTitles:nil];
                    [alert show];
                }
            }
            else{
                [weakSelf fetSnacksList];
            }
        } else {
            [MBProgressHUD showDrawInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

- (void)fetSnacksList
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetConsumInitListWithBoxId:self.boxInfoEntity.boxIdNum batchNo:self.boxInfoEntity.batchNoNum complete:^(HXSErrorCode code, NSString *message, NSArray *items, NSNumber *quantity){
        [HXSLoadingView closeInView:weakSelf.view];

        if(kHXSNoError == code){
            
            [weakSelf.snacksArr addObjectsFromArray:items];
            [weakSelf.myTable reloadData];
            weakSelf.quantity = quantity;
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.snacksArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == self.snacksArr.count){
        static NSString *cellId = @"boxCheckCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(nil == cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:HXS_SEGMENT_TITLE_COLOR];
            
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.detailTextLabel setTextColor:[UIColor colorWithRGBHex:0xfaa707]];
        }

        cell.textLabel.text = @"总计";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d份零食",self.quantity.intValue];

        return cell;
    }else{
        
        HXSBoxCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSBoxCheckCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HXSDormItem *temp = [self.snacksArr objectAtIndex:indexPath.row];
        cell.boxItem = temp;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Target/Action
- (void)getConsumerListButtonClicked
{
    if(self.boxInfoEntity){
        if(self.boxInfoEntity.isBoxerNum.intValue == HXSBoxUserStatusYes){
            [HXSUsageManager trackEvent:kUsageEventBoxMasterGetConsumptionInventory parameter:@{@"status":@"清点结算并确认账单、清单中未确认账单"}];
        }else{
            [HXSUsageManager trackEvent:kUsageEventBoxSharedGetConsumptionInventory parameter:@{@"status":@"清点结算并确认账单、清单中未确认账单"}];
        }
        [self getBoxInfoWithGoToConsumptionList:YES];
    
    }
}

#pragma mark - getter

- (UIView *)sectionHeaderView
{
    if(!_sectionHeaderView){
        UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        UILabel *sectionHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 35)];
        sectionHeaderLabel.text = @"本期初始零食清单";
        [sectionHeaderLabel setFont:[UIFont systemFontOfSize:13]];
        [sectionHeaderLabel setTextColor:HXS_INFO_NOMARL_COLOR];
        [sectionHeaderView addSubview:sectionHeaderLabel];
        _sectionHeaderView = sectionHeaderView;
    }
    return _sectionHeaderView;
}

- (HXSBoxOwnerInfoView *)boxOwnerInfoView
{
    if(!_boxOwnerInfoView){
        _boxOwnerInfoView = [HXSBoxOwnerInfoView initFromXib];
    }
    return _boxOwnerInfoView;
}

- (HXSCustomAlertView *)alertView
{
    if(!_alertView)
    {
        _alertView = [[HXSCustomAlertView alloc]initWithTitle:@""
                                                      message:@"清点中,请稍后..."
                                              leftButtonTitle:@"确定"
                                            rightButtonTitles:nil];
    }
    
    return _alertView;
}

@end
