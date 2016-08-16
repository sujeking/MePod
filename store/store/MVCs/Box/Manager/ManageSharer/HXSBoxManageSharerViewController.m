//
//  HXSBoxManageSharerViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxManageSharerViewController.h"
#import "HXSBoxExpenseCalendarViewController.h"
#import "HXSBoxShareViewController.h"
#import "HXSBoxMacro.h"
#import "HXSBoxModel.h"

#define SECTION_HEADER_HEIGHT 35

@interface HXSBoxManageSharerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *sharersArr;
@property (nonatomic, strong) NSMutableArray *boxerArr;

@property (nonatomic, strong) HXSBoxInfoEntity *boxInfoEntity;

// sectionHeader
@property (nonatomic, strong) UIView *sectionOneHeader;
@property (nonatomic, strong) UIView *sectionTwoHeader;


@end

@implementation HXSBoxManageSharerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialPrama];
    
    [self initialTable];
    
    [self getSharesWebService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)controllerWithBoxInfoEntity:(HXSBoxInfoEntity *)boxInfoEntity;
{
    HXSBoxManageSharerViewController *controller = [HXSBoxManageSharerViewController controllerFromXib];
    controller.boxInfoEntity = boxInfoEntity;
    return controller;
}

#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"使用者列表";
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    self.myTable.rowHeight = 44;
    [self.myTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (void)initialPrama
{
    self.sharersArr = [NSMutableArray array];
    self.boxerArr = [NSMutableArray array];
}

#pragma mark - webService
- (void)getSharesWebService
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSBoxModel fetSharerListWithBoxId:self.boxInfoEntity.boxIdNum batchNo:self.boxInfoEntity.batchNoNum ifWithBill:YES complete:^(HXSErrorCode code, NSString *message, NSArray *boxerInfoArr, NSArray *sharedInfoArr) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            
            [weakSelf.boxerArr removeAllObjects];
            [weakSelf.sharersArr removeAllObjects];
            [weakSelf.boxerArr addObjectsFromArray:boxerInfoArr];
            [weakSelf.sharersArr addObjectsFromArray:sharedInfoArr];
            [weakSelf.myTable reloadData];
            
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
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
        return [self.boxerArr count];
    
    return [self.sharersArr count] > 0 ?[self.sharersArr count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(0 == section)
        return self.sectionOneHeader;
    return self.sectionTwoHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"BoxManageSharerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(nil == cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setTextColor:HXS_INFO_NOMARL_COLOR];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
    
    if(0 == indexPath.section){
        
        HXSBoxUserEntity *tempUserEntity = [self.boxerArr objectAtIndex:indexPath.row];
        cell.textLabel.text = tempUserEntity.unameStr;
        NSString *str = [NSString stringWithFormat:@"本期已付￥%.2f",tempUserEntity.paidAmountDoubleNum.doubleValue];
        NSMutableAttributedString *tipTextAttributeMStr = [[NSMutableAttributedString alloc] initWithString:str];
        [tipTextAttributeMStr addAttribute:NSForegroundColorAttributeName value:HXS_COLOR_COMPLEMENTARY range:[str rangeOfString:[NSString stringWithFormat:@"￥%.2f",tempUserEntity.paidAmountDoubleNum.doubleValue]]];
        cell.detailTextLabel.attributedText = tipTextAttributeMStr;
        
    }else{
        if(self.sharersArr.count > 0){
            
            HXSBoxUserEntity *tempUserEntity = [self.sharersArr objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@",tempUserEntity.unameStr,[tempUserEntity statusStr]];
            NSString *str = [NSString stringWithFormat:@"本期已付￥%.2f",tempUserEntity.paidAmountDoubleNum.doubleValue];
            NSMutableAttributedString *tipTextAttributeMStr = [[NSMutableAttributedString alloc] initWithString:str];
            [tipTextAttributeMStr addAttribute:NSForegroundColorAttributeName value:HXS_COLOR_COMPLEMENTARY range:[str rangeOfString:[NSString stringWithFormat:@"￥%.2f",tempUserEntity.paidAmountDoubleNum.doubleValue]]];
            cell.detailTextLabel.attributedText = tipTextAttributeMStr;
        
        }else{
            cell.textLabel.text = @"暂无";
            cell.detailTextLabel.text = @"分享盒子";
            [cell.detailTextLabel setTextColor:HXS_COLOR_MASTER];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(0 == indexPath.section){
        
        //埋点 盒主点击列表条目
        [HXSUsageManager trackEvent:kUsageEventBoxMasterClickItem parameter:nil];
        
        HXSBoxExpenseCalendarViewController *expenseCalendarViewController = [HXSBoxExpenseCalendarViewController controllerWithBoxUserEntity:[self.boxerArr objectAtIndex:indexPath.row] boxIdNum:self.boxInfoEntity.boxIdNum batchNoNum:self.boxInfoEntity.batchNoNum isBoxerNum:self.boxInfoEntity.isBoxerNum];
        WS(weakSelf);
        expenseCalendarViewController.removeShareCompleteBlock = ^{
            [weakSelf getSharesWebService];
        };
        
        [self.navigationController pushViewController:expenseCalendarViewController animated:YES];
    }else{
        if(self.sharersArr.count > 0){
            
            [HXSUsageManager trackEvent:kUsageEventBoxSharedClickItem parameter:nil];
            
            HXSBoxExpenseCalendarViewController *expenseCalendarViewController = [HXSBoxExpenseCalendarViewController controllerWithBoxUserEntity:[self.sharersArr objectAtIndex:indexPath.row] boxIdNum:self.boxInfoEntity.boxIdNum batchNoNum:self.boxInfoEntity.batchNoNum isBoxerNum:self.boxInfoEntity.isBoxerNum];
            WS(weakSelf);
            expenseCalendarViewController.removeShareCompleteBlock = ^{
                [weakSelf getSharesWebService];
            };
            
            [self.navigationController pushViewController:expenseCalendarViewController animated:YES];
        }else{
            HXSBoxShareViewController *boxShareViewController = [[HXSBoxShareViewController alloc]initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:boxShareViewController animated:YES];
        }
    }
}

#pragma mark - getter

- (UIView *)sectionOneHeader
{
    if(!_sectionOneHeader){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTION_HEADER_HEIGHT)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, SECTION_HEADER_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:HXS_INFO_NOMARL_COLOR];
        label.text = @"盒主";
        [view addSubview:label];
        _sectionOneHeader = view;
    }
    return _sectionOneHeader;
}

- (UIView *)sectionTwoHeader
{
    if(!_sectionTwoHeader){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SECTION_HEADER_HEIGHT)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, SECTION_HEADER_HEIGHT)];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:HXS_INFO_NOMARL_COLOR];
        label.text = @"共享者";
        [view addSubview:label];
        _sectionTwoHeader = view;
    }
    return _sectionTwoHeader;
}


@end
