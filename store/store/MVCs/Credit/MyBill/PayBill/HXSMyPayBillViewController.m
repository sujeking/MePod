//
//  HXSMyPayBillViewController.m
//  store
//
//  Created by J006 on 16/2/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillViewController.h"
#import "HXSMyPayBillCell.h"
#import "HXSMyPayBillTableHeaderView.h"
#import "HXSMyPayBillTableFooterView.h"
#import "HXSMyPayBillInstallmentViewController.h"
#import "HXSMyPayBillModel.h"
#import "UIScrollView+HXSPullRefresh.h"

static NSInteger mainPayBillTableHeaderViewHeight = 44;
static NSInteger mainPayBillTableFooterViewHeight = 180;

@interface HXSMyPayBillViewController ()<UITableViewDelegate,UITableViewDataSource>

/**日期上翻箭头 */
@property (weak, nonatomic) IBOutlet UIButton                            *prevButton;
/**上个月 */
@property (weak, nonatomic) IBOutlet UIButton                            *prevDateButton;
/**本期订单 标题 */
@property (weak, nonatomic) IBOutlet UILabel                             *titleBillLabel;
/**下个月 */
@property (weak, nonatomic) IBOutlet UIButton                            *nextDateButton;
/**日期下翻箭头 */
@property (weak, nonatomic) IBOutlet UIButton                            *nextButton;
/**主要消费类账单记录列表 */
@property (weak, nonatomic) IBOutlet UITableView                         *mainPayBillTable;
/**我要分期 */
@property (weak, nonatomic) IBOutlet UIButton                            *wantoInstallmentButton;
@property (weak, nonatomic) IBOutlet UIView                              *viewTopView;
@property (weak, nonatomic) IBOutlet UIImageView                         *noBillsImageView;
/**暂时没有订单哦 */
@property (weak, nonatomic) IBOutlet UILabel                             *noBillLabel;
/**合计view */
@property (nonatomic, strong) HXSMyPayBillTableHeaderView                *tableViewHeaderView;
/**提示view */
@property (nonatomic, strong) HXSMyPayBillTableFooterView                *tableViewFooterView;
@property (nonatomic, strong) HXSMyPayBillInstallmentViewController      *myPayBillInstallmentVC;

/**当前所有账单集合,肯定会有3个以上元素,倒数第二个为本期订单,倒数第一个为下期订单,倒数第三个为上期订单 */
@property (nonatomic, strong) NSArray                                    *totalBillArray;
/**当前账单在集合中的索引 */
@property (nonatomic, readwrite) NSInteger                               currentListEntityIndex;

@end

@implementation HXSMyPayBillViewController

#pragma mark life cycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self initTheTableView];
    [self networking];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
}


#pragma mark init

/**
 *  初始化订单列表部分相关设置
 */
- (void)initTheTableView
{
    [_mainPayBillTable registerNib:[UINib nibWithNibName:HXSMyPayBillCellIdentify bundle:nil] forCellReuseIdentifier:HXSMyPayBillCellIdentify];
    __weak __typeof(self)weakSelf = self;
    [_mainPayBillTable addRefreshHeaderWithCallback:^{
        [weakSelf fetchMyPayBillDetailWithMBProgressHUD:NO];
    }];
}

#pragma mark networking

/**
 *  初始化网络请求
 */
- (void)networking
{
    [self fetchMyPayBillsListAndDetailWithMBProgressHUD:YES];
}

/**
 *  获取我的消费账单列表
 */
- (void)fetchMyPayBillsListAndDetailWithMBProgressHUD:(BOOL)isMBProgressHUD
{
    if(isMBProgressHUD)
        [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    [[HXSMyPayBillModel sharedManager] fetchMyPayBillListComplete:^(HXSErrorCode status, NSString *message, NSArray *billsArr)
     {
        if(isMBProgressHUD)
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
         else
             [_mainPayBillTable endRefreshing];
         if(!billsArr)//为空列表
         {
             [weakSelf noBillsShowIsShow:YES];
             [weakSelf setThePrevButtonLabelAndNextButtonLabelByCurrentIndex];
             return;
         }
         _currentListEntityIndex = [billsArr count]-2;
         weakSelf.totalBillArray = billsArr;
         [weakSelf fetchMyPayBillDetailWithMBProgressHUD:YES];
     }
     failure:^(NSString *errorMessage)
     {
        if(isMBProgressHUD)
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        else
            [weakSelf.mainPayBillTable endRefreshing];
         if (weakSelf.view)
             [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
         [weakSelf noBillsShowIsShow:YES];
         [weakSelf.wantoInstallmentButton setHidden:YES];
     }];
}


/**
 *  获取当前列表索引的消费账单详细
 */
- (void)fetchMyPayBillDetailWithMBProgressHUD:(BOOL)isMBProgressHUD
{
    if(isMBProgressHUD)
        [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    HXSMyPayBillListEntity *currentListEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    
    [[HXSMyPayBillModel sharedManager]fetchMyPayBillDetailWithBillID:currentListEntity.billIDNum complete:^(HXSErrorCode status, NSString *message, HXSMyPayBillEntity *detailEntity)
    {
        if(isMBProgressHUD)
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        else
            [weakSelf.mainPayBillTable endRefreshing];
        currentListEntity.billEntity = detailEntity;
        if(detailEntity.billAmountNum > 0)
        {
            [weakSelf noBillsShowIsShow:NO];
        }
        else
        {
            [weakSelf noBillsShowIsShow:YES];
        }
        [weakSelf.mainPayBillTable reloadData];
        [weakSelf setThePrevButtonLabelAndNextButtonLabelByCurrentIndex];
    } failure:^(NSString *errorMessage) {
        if(isMBProgressHUD)
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        else
            [weakSelf.mainPayBillTable endRefreshing];
        if (weakSelf.view)
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
        [weakSelf setThePrevButtonLabelAndNextButtonLabelByCurrentIndex];
        [weakSelf noBillsShowIsShow:YES];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if(_totalBillArray)
    {
        HXSMyPayBillListEntity *listEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
        HXSMyPayBillEntity *billEntity =  listEntity.billEntity;
        if(billEntity)
            rows = [billEntity.detailArr count];
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    if(_totalBillArray)
        section = 1;
    return section;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSMyPayBillCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSMyPayBillCellIdentify forIndexPath:indexPath];
    HXSMyPayBillListEntity *listEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    HXSMyPayBillEntity *billEntity =  listEntity.billEntity;
    [cell initMyPayBillCellWithEntity:[billEntity.detailArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return mainPayBillTableFooterViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return mainPayBillTableHeaderViewHeight;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    HXSMyPayBillListEntity *listEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    [self.tableViewHeaderView initTheViewWithEntity:listEntity];    
    return self.tableViewHeaderView;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    HXSMyPayBillListEntity *listEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    [self.tableViewFooterView initTheViewWithMyPayBillListEntity:listEntity];
    return self.tableViewFooterView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}



#pragma mark Button Action

/**
 *  日期上翻箭头按钮事件
 */
- (IBAction)prevBtnAction:(id)sender
{
    _currentListEntityIndex -= 1;
    HXSMyPayBillListEntity *currentEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    if(!currentEntity.billEntity)
    {
        [self fetchMyPayBillDetailWithMBProgressHUD:YES];
    }
    else
    {
        [self.mainPayBillTable reloadData];
        [self setThePrevButtonLabelAndNextButtonLabelByCurrentIndex];
    }

}

/**
 *  日期下翻箭头按钮时间
 */
- (IBAction)nextBtnAction:(id)sender
{
    _currentListEntityIndex += 1;
    HXSMyPayBillListEntity *currentEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    if(!currentEntity.billEntity)
    {
        [self fetchMyPayBillDetailWithMBProgressHUD:YES];
    }
    else
    {
        [self.mainPayBillTable reloadData];
        [self setThePrevButtonLabelAndNextButtonLabelByCurrentIndex];
    }

}

/**
 *  我要分期
 */
- (IBAction)installmentAction:(id)sender
{
    HXSMyPayBillInstallmentViewController *vc = [HXSMyPayBillInstallmentViewController controllerFromXib];
    HXSMyPayBillListEntity *currentEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    [vc initMyNewPayBillInstallmentViewControllerWithEntity:currentEntity];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark private method

/**
 *  对Number类型的日期进行格式化,转化成合适的字符串
 *
 *  @param billTime
 *
 *  @return
 */
- (NSString*)formatTheTimeToString:(NSNumber*)billTime
{
    if(!billTime)
        return @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[billTime doubleValue]];
    NSString *time = [formatter stringFromDate:date];
    return time;
}

/**
 *  根据当前的索引值设置顶部左右按钮和文案显示
 */
- (void)setThePrevButtonLabelAndNextButtonLabelByCurrentIndex
{
    if(!_totalBillArray || [_totalBillArray count]==0)
    {
        [_wantoInstallmentButton setHidden:YES];
        [_nextButton setHidden:YES];
        [_nextDateButton setHidden:YES];
        [_prevButton setHidden:YES];
        [_prevDateButton setHidden:YES];
        return;
    }
    HXSMyPayBillListEntity *currentEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex];
    [_titleBillLabel setText:currentEntity.billServiceFeeDescStr];
    if(currentEntity.billTypeNum==HXSMyBillConsumeTypeNext)
    {
        [_nextButton setHidden:YES];
        [_nextDateButton setHidden:YES];
        [_prevButton setHidden:NO];
        [_prevDateButton setHidden:NO];
        HXSMyPayBillListEntity *prevEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex-1];
        [_prevDateButton setTitle:prevEntity.billServiceFeeDescStr forState:UIControlStateNormal];
    }
    else if(_currentListEntityIndex == 0)
    {
        [_nextButton setHidden:NO];
        [_nextDateButton setHidden:NO];
        [_prevDateButton setHidden:YES];
        [_prevButton setHidden:YES];
        HXSMyPayBillListEntity *nextEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex+1];
        [_nextDateButton setTitle:nextEntity.billServiceFeeDescStr forState:UIControlStateNormal];
    }
    else
    {
        [_nextButton setHidden:NO];
        [_nextDateButton setHidden:NO];
        [_prevDateButton setHidden:NO];
        [_prevButton setHidden:NO];
        HXSMyPayBillListEntity *prevEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex-1];
        HXSMyPayBillListEntity *nextEntity = [_totalBillArray objectAtIndex:_currentListEntityIndex+1];
        [_prevDateButton setTitle:prevEntity.billServiceFeeDescStr forState:UIControlStateNormal];
        [_nextDateButton setTitle:nextEntity.billServiceFeeDescStr forState:UIControlStateNormal];
    }
    
    if(currentEntity.billTypeNum == HXSMyBillConsumeTypeCurrent
       && currentEntity.installmentStatusNums == HXSMyBillConsumeInstallmentStatusNotDone)
    {
        /*暂时去除我要分期按钮
        //当金额大于200时才可以被分期
        if([currentEntity.billEntity.billAmountNum doubleValue] > nAmountCanBeInstallment)
        {
            [_wantoInstallmentButton setHidden:NO];
        }
        else
        {
            [_wantoInstallmentButton setHidden:YES];
        }
         */
    }
    else
    {
        [_wantoInstallmentButton setHidden:YES];
    }
    //如果当前账单为0
    if(!currentEntity.billEntity
       || [currentEntity.billEntity.billAmountNum doubleValue] == 0)
    {
        [self noBillsShowIsShow:YES];
        [_wantoInstallmentButton setHidden:YES];
    }
    else
    {
        [self noBillsShowIsShow:NO];
    }
}

/*
 *无账单则隐藏tableview显示相关信息或者显示
 */
- (void)noBillsShowIsShow:(BOOL)isShow
{
    [_mainPayBillTable setHidden:isShow];
    [_noBillLabel setHidden:!isShow];
    [_noBillsImageView setHidden:!isShow];
    //[_viewTopView setHidden:isShow];
}

#pragma mark getter setter

- (HXSMyPayBillTableHeaderView *)tableViewHeaderView
{
    if(!_tableViewHeaderView)
    {
        _tableViewHeaderView = [HXSMyPayBillTableHeaderView myPayBillTableHeaderView];
    }
    return _tableViewHeaderView;
}

- (HXSMyPayBillTableFooterView *)tableViewFooterView
{
    if(!_tableViewFooterView)
    {
        _tableViewFooterView = [HXSMyPayBillTableFooterView myNewPayBillTableFooterView];
    }
    return _tableViewFooterView;
}

@end
