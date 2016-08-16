//
//  HXSBorrowCashRecordViewController.m
//  store
//
//  Created by hudezhi on 15/11/12.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowCashRecordViewController.h"
#import "HXSBillModel.h"
#import "HXSBorrowCashRecordCell.h"
#import "HXSEmptyTableBackgroundView.h"
#import "HXSBorrowRepaymentPlanViewController.h"
#import "UIView+Utilities.h"
#import "HXSCredit.h"

@interface HXSBorrowCashRecordViewController () {
    HXSEmptyTableBackgroundView *_emptyBackgroundView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *cashRecordList;

- (void)setupCashRecordTableView;
- (void)getCashRecordList;

@end

@implementation HXSBorrowCashRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupCashRecordTableView];

    [self getCashRecordList];
}

- (void)setupCashRecordTableView
{
    self.title = @"分期记录";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXAppPod" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    _emptyBackgroundView = [bundle loadNibNamed:@"HXSEmptyTableBackgroundView" owner:self options:nil].lastObject;
    _emptyBackgroundView.imageView.image = [UIImage imageNamed:@"img_empty_cash_record"];
    _emptyBackgroundView.textLabel.text = @"暂时没有分期哦";
    _emptyBackgroundView.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    _emptyBackgroundView.textLabel.font = [UIFont systemFontOfSize:13.0];
    _emptyBackgroundView.hidden = YES;
    _emptyBackgroundView.backgroundColor = [UIColor clearColor];
    [_emptyBackgroundView setTopPadding:80 spacing:15];
    
    self.tableView.backgroundView = _emptyBackgroundView;
}

- (void)getCashRecordList
{
    WS(weakSelf);
    
    [MBProgressHUD showInView:self.view status:@"获取分期记录..."];
    [HXSBillModel getBorrowCashRecord:^(HXSErrorCode code, NSString *message, NSArray *list) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        _cashRecordList = list;
        _emptyBackgroundView.hidden = (_cashRecordList.count > 0);
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cashRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSBorrowCashRecordCell *cell = (HXSBorrowCashRecordCell*)[tableView dequeueReusableCellWithIdentifier:@"HXSCashRecordCell" forIndexPath:indexPath];
    HXSBillBorrowCashRecordItem *item = _cashRecordList[indexPath.row];
    cell.cashRecord = item;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    cell.accessoryType  = (item.installmentStatusNum.intValue == 2) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [HXSUsageManager trackEvent:kUsageEventBorrowCashHistory parameter:nil];

    HXSBillBorrowCashRecordItem *item = _cashRecordList[indexPath.row];
    if (item.installmentStatusNum.intValue != 2) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:[NSBundle mainBundle]];
        HXSBorrowRepaymentPlanViewController *borrowRepaymentPlanViewController = [story instantiateViewControllerWithIdentifier:@"HXSBorrowRepaymentPlanViewController"];
        borrowRepaymentPlanViewController.installmentIdNum = item.installmentIdNum;
        borrowRepaymentPlanViewController.installmentTypeStr = item.installmentTypeStr;
        [self.navigationController pushViewController:borrowRepaymentPlanViewController animated:YES];
        
    }
}

@end
