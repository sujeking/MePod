//
//  HXSMyPayBillInstallmentViewController.m
//  store
//
//  Created by J006 on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyPayBillInstallmentViewController.h"

// Controllers
#import "HXSPayBillConfirmInstallmentCell.h"
#import "HXSPayBillConfirmInstallmentSecondCell.h"
#import "HXSPayBillSelectInstallmentCell.h"
#import "HXSWebViewController.h"

// Model
#import "HXSMyPayBillInstallMentModel.h"
#import "HXSMyPayBillInstallMentEntity.h"
#import "HXSMyPayBillInstallMentSelectEntity.h"

// Views
#import "HXSMyNewPayBillInstallmentHeaderView.h"
#import "HXSMyNewPayBillInstallmentFooterView.h"
#import "HXSCustomPickerView.h"


@interface HXSMyPayBillInstallmentViewController ()<HXSMyNewPayBillInstallmentFooterViewDelegate>

/**主TableView */
@property (weak, nonatomic) IBOutlet UITableView                    *confirmInstallmentTableView;
/**cell 对象集合 */
@property (nonatomic, strong) NSMutableArray                        *contentArray;
@property (nonatomic, strong) HXSMyNewPayBillInstallmentHeaderView  *myNewPayBillInstallmentHeaderView;
@property (nonatomic, strong) HXSMyNewPayBillInstallmentFooterView  *myNewPayBillInstallmentFooterView;
/**已经确定分期 */
@property (nonatomic, readwrite) BOOL                               isConfirmTheInstallment;
@property (nonatomic, strong) HXSMyPayBillListEntity                *currentBillListEntity;
/**当前选择的月供集合的索引值 */
@property (nonatomic, readwrite) NSInteger                          selectMonthIndex;
/**确认分期后的确认界面的entity */
@property (nonatomic, strong) HXSMyPayBillInstallMentEntity         *currentConfirmEntity;
/**当前月供集合 */
@property (nonatomic, strong) NSArray                               *selectEntityArray;

@end

@implementation HXSMyPayBillInstallmentViewController


#pragma mark - life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self initialNavigationBar];
   [self initTheConfirmTable];
   [self initNetworking];
}

- (void)awakeFromNib
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    _myNewPayBillInstallmentFooterView.delegate = nil;
}


#pragma mark - init

- (void)initMyNewPayBillInstallmentViewControllerWithEntity:(HXSMyPayBillListEntity *)entity
{
    _currentBillListEntity = entity;
    _selectMonthIndex = 0;
}


/**
 *初始化导航栏，增加Segment控件
 */
- (void)initialNavigationBar
{
    self.title = @"账单分期";
}

- (void)initTheConfirmTable
{
    [_confirmInstallmentTableView registerNib:[UINib nibWithNibName:HXSPayBillConfirmInstallmentCellIdentify bundle:nil] forCellReuseIdentifier:HXSPayBillConfirmInstallmentCellIdentify];
    [_confirmInstallmentTableView registerNib:[UINib nibWithNibName:HXSPayBillConfirmInstallmentSecondCellIdentify bundle:nil] forCellReuseIdentifier:HXSPayBillConfirmInstallmentSecondCellIdentify];
    [_confirmInstallmentTableView registerNib:[UINib nibWithNibName:HXSPayBillSelectInstallmentCellIdentify bundle:nil] forCellReuseIdentifier:HXSPayBillSelectInstallmentCellIdentify];
}

/**
 *  初始化网络请求
 */
- (void)initNetworking
{
    [self selectTheInstallmentMonthNetWorking];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    if(_selectEntityArray && !_isConfirmTheInstallment)
        rows = 4;
    else if(_isConfirmTheInstallment && _currentConfirmEntity)
        rows = 4;
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    if(_selectEntityArray && !_isConfirmTheInstallment)
        section = 1;
    else if(_isConfirmTheInstallment && _currentConfirmEntity)
        section = 1;
    return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(!_isConfirmTheInstallment) {
        switch (indexPath.row)
        {
            case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:HXSPayBillConfirmInstallmentCellIdentify forIndexPath:indexPath];
                NSString *billAmount = [NSString stringWithFormat:@"¥%@",[_currentBillListEntity.billAmountNum stringValue]];
                [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:billAmount andTitle:@"本期账单一共" andType:HXSPayBillConfirmInstallmentCellTypePrice];
            }
                break;
            case 1:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:HXSPayBillConfirmInstallmentCellIdentify forIndexPath:indexPath];
                NSString *billAmount = [NSString stringWithFormat:@"¥%@",[_currentBillListEntity.billAmountNum stringValue]];
                [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:billAmount andTitle:@"可分期金额" andType:HXSPayBillConfirmInstallmentCellTypePrice];
            }
                break;
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:HXSPayBillSelectInstallmentCellIdentify forIndexPath:indexPath];
                HXSMyPayBillInstallMentSelectEntity *currentSelectEntity = [_selectEntityArray objectAtIndex:_selectMonthIndex];
                [(HXSPayBillSelectInstallmentCell*)cell initPayBillSelectInstallmentCellWithMonthNums:[[currentSelectEntity installmentNum] integerValue]];
            }
                break;
                
            default:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:HXSPayBillConfirmInstallmentSecondCellIdentify forIndexPath:indexPath];
                HXSMyPayBillInstallMentSelectEntity *currentSelectEntity = [_selectEntityArray objectAtIndex:_selectMonthIndex];
                [(HXSPayBillConfirmInstallmentSecondCell*)cell initPayBillConfirmInstallmentSecondCellWithInstallmentAmount:currentSelectEntity.monthlyPaymentsNum andMonthNums:[[currentSelectEntity installmentNum] integerValue]];
            }
                break;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:HXSPayBillConfirmInstallmentCellIdentify forIndexPath:indexPath];
        switch (indexPath.row)
        {
            case 0:
            {
                NSString *amountTotal = [NSString stringWithFormat:@"¥%@",[_currentConfirmEntity.billAmountNum stringValue]];
                [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:amountTotal andTitle:@"分期总额" andType:HXSPayBillConfirmInstallmentCellTypePrice];
            }
                break;
                
            case 1:
            {
                NSString *amountInstallment = [NSString stringWithFormat:@"¥%@",[_currentConfirmEntity.installmentAmount stringValue]];
                [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:amountInstallment andTitle:@"每月还款" andType:HXSPayBillConfirmInstallmentCellTypePrice];
            }
                break;
                
            case 2:
            {
                
                [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:_currentConfirmEntity.firstDateStr andTitle:@"第一笔还款日期" andType:HXSPayBillConfirmInstallmentCellTypeDate];
            }
                break;
                
            default:
            {
                 [(HXSPayBillConfirmInstallmentCell*)cell initPayBillConfirmInstallmentWith:_currentConfirmEntity.endDateStr andTitle:@"最后一笔还款日期" andType:HXSPayBillConfirmInstallmentCellTypeDate];
            }
                break;
        }
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height;
    if(0 == indexPath.row || 1 == indexPath.row || 2 == indexPath.row)
        height = 44;
    else if(!_isConfirmTheInstallment)
        height = 60;//确认分期付款界面的第四个特殊cell高度
    else
        height = 44;
    return height;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(!_isConfirmTheInstallment && 2 == indexPath.row) { //点击分期期数
        if(!_selectEntityArray)
            return;
        NSMutableArray *totalMonthArray = [[NSMutableArray alloc]init];
        for (HXSMyPayBillInstallMentSelectEntity *selectEntity in _selectEntityArray) {
            NSString *monthStr = [NSString stringWithFormat:@"%@个月",[selectEntity.installmentNum stringValue]];
            [totalMonthArray addObject:monthStr];
        }
        __weak typeof(self) weakSelf = self;
        [HXSCustomPickerView showWithStringArray:totalMonthArray defaultValue:totalMonthArray[0] toolBarColor:[UIColor whiteColor] completeBlock:^(int index, BOOL finished) {
            if(finished)
                weakSelf.selectMonthIndex = index;
            [weakSelf.confirmInstallmentTableView reloadData];
        }];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - HXSMyNewPayBillInstallmentFooterViewDelegate

- (void)confirmInstallment
{
    if(!_isConfirmTheInstallment)
        [self confirmInstallmentNetworking];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToInstallmentWebView
{
    HXSWebViewController *webVCtrl = [HXSWebViewController controllerFromXib];
    NSString *urlText = [[ApplicationSettings instance] currentBillStageAgreementURL];
    webVCtrl.url = [NSURL URLWithString:urlText];
    [self.navigationController pushViewController:webVCtrl animated:YES];
}



#pragma mark - networking

/**
 *  获取分期的月供和月数网络连接
 */
- (void)selectTheInstallmentMonthNetWorking
{
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    [[HXSMyPayBillInstallMentModel sharedManager] myPayBillInstallMentSelectWithInstallmentAmount:_currentBillListEntity.billAmountNum Complete:^(HXSErrorCode status, NSString *message, NSArray *entityArray)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.selectEntityArray = entityArray;
        [weakSelf.confirmInstallmentTableView setTableFooterView:self.myNewPayBillInstallmentFooterView];
        [weakSelf.confirmInstallmentTableView reloadData];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (weakSelf.view)
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
        [weakSelf.confirmInstallmentTableView setHidden:YES];
    }];
}

/**
 *  确认分期网络连接
 */
- (void)confirmInstallmentNetworking
{
    [MBProgressHUD showInView:self.view];
    __weak __typeof(self)weakSelf = self;
    HXSMyPayBillInstallMentSelectEntity *currentSelectEntity = [_selectEntityArray objectAtIndex:_selectMonthIndex];
    [[HXSMyPayBillInstallMentModel sharedManager] confirmMyPayBillInstallmentWithInstallmentAmount:currentSelectEntity.monthlyPaymentsNum andWithInstallmentNumber:currentSelectEntity.installmentNum withBillID:_currentBillListEntity.billIDNum Complete:^(HXSErrorCode status, NSString *message, HXSMyPayBillInstallMentEntity *entity)
    {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.currentConfirmEntity = entity;
        [weakSelf changgeThefooterView];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (weakSelf.view)
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
    }];
}


#pragma mark - private methods

- (void)changgeThefooterView
{
    [_myNewPayBillInstallmentFooterView.confirmButton setTitle:@"返回我的账单" forState:UIControlStateNormal];
    [_myNewPayBillInstallmentFooterView.iconImageView     removeFromSuperview];
    [_myNewPayBillInstallmentFooterView.contractTextView  removeFromSuperview];
    [_myNewPayBillInstallmentFooterView.confirmButton  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(20);//离该footer页面顶部20个像素
    }];
    _isConfirmTheInstallment = YES;
    [_confirmInstallmentTableView setTableHeaderView:self.myNewPayBillInstallmentHeaderView];
    [_myNewPayBillInstallmentHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmInstallmentTableView);
        make.top.equalTo(_confirmInstallmentTableView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(153);//顶部headerview的高度
    }];
    
    [_myNewPayBillInstallmentFooterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4*44+153);//确认分期付款后，底部footerview紧贴着4个cell与顶部headerview
        make.height.mas_equalTo(_confirmInstallmentTableView.frame.size.height-4*44-153);
        //make.bottom.equalTo(self);
    }];
    
    [_confirmInstallmentTableView reloadData];
}


#pragma mark - getter setter

- (HXSMyNewPayBillInstallmentHeaderView*)myNewPayBillInstallmentHeaderView
{
    if(!_myNewPayBillInstallmentHeaderView) {
        _myNewPayBillInstallmentHeaderView  = [HXSMyNewPayBillInstallmentHeaderView   myNewPayBillInstallmentHeaderView];
    }
    return _myNewPayBillInstallmentHeaderView;
}

- (HXSMyNewPayBillInstallmentFooterView*)myNewPayBillInstallmentFooterView
{
    if(!_myNewPayBillInstallmentFooterView) {
        _myNewPayBillInstallmentFooterView  = [HXSMyNewPayBillInstallmentFooterView   myNewPayBillInstallmentFooterView];
        _myNewPayBillInstallmentFooterView.delegate = self;
    }
    return _myNewPayBillInstallmentFooterView;
}

@end
