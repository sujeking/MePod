//
//  HXSBorrowRepaymentPlanViewController.m
//  store
//
//  Created by hudezhi on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowRepaymentPlanViewController.h"
#import "HXSBorrowRepaymentPlanCell.h"
#import "HXSBillRepaymentSchedule.h"
#import "HXSBillModel.h"
#import "HXSCredit.h"

@interface HXSBorrowRepaymentPlanViewController ()

@property (nonatomic) HXSBillRepaymentSchedule *repaymentScheduleEntity;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

- (void)getRepaymentScheduleList;

@end

@implementation HXSBorrowRepaymentPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = (nil == self.itemTitleStr) ? @"还款进度" : self.itemTitleStr;
    self.repaymentScheduleEntity = nil;
    _amountLabel.text = @"";
    _periodLabel.text = @"";

    [self getRepaymentScheduleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)getRepaymentScheduleList
{
    [HXSUsageManager trackEvent:kUsageEventBorrowRefundProcess parameter:nil];
    WS(weakSelf);
    [MBProgressHUD showInView:self.view status:@"获取还款进度..."];
    [HXSBillModel getRepaymentSchedule:self.installmentIdNum installmentType:[NSNumber numberWithInt:self.installmentTypeStr.intValue] completion:^(HXSErrorCode code, NSString *message, HXSBillRepaymentSchedule *billRepaymentScheduleEntity) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (code == kHXSNoError) {
            if (nil != billRepaymentScheduleEntity) {
                self.repaymentScheduleEntity = billRepaymentScheduleEntity;
                [self.tableView reloadData];
                
                _amountLabel.text = [NSString stringWithFormat:@"%0.2f", [self.repaymentScheduleEntity.installmentAmountNum doubleValue]];
                _periodLabel.text = [NSString stringWithFormat:@"期数:  %d/%d", self.repaymentScheduleEntity.repaymentNumberNum.intValue, self.repaymentScheduleEntity.installmentNumberdNum.intValue];
            }
            else {
                _amountLabel.text = @"0.00";
                _periodLabel.text = @"期数:";
            }
        }
        else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repaymentScheduleEntity.repaymentsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSBorrowRepaymentPlanCell *cell = (HXSBorrowRepaymentPlanCell*)[tableView dequeueReusableCellWithIdentifier:@"RepaymentPlanCell" forIndexPath:indexPath];
    cell.scheduleItem = self.repaymentScheduleEntity.repaymentsArr[indexPath.row];

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
    return 56.5;
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//}


@end
