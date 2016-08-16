//
//  HXSBorrowBillViewController.m
//  store
//
//  Created by hudezhi on 15/7/28.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBorrowBillViewController.h"
#import "HXSelectionControl.h"
#import "HXSBorrowCashRecordCell.h"
#import "HXSBorrowRepaymentAmountCell.h"
#import "HXSBillBorrowCashRecordItem.h"
#import "HXSBillModel.h"
#import "HXSBillRepaymentInfo.h"
#import "HXSBorrowBillHeaderView.h"
#import "HXSRemarkFooterView.h"
#import "HXSBorrowEmptyRepaymentView.h"
#import "UIView+Utilities.h"
#import "HXSBorrowCashRecordViewController.h"

@interface HXSBorrowBillViewController () {
    HXSBorrowBillHeaderView *_header;
    HXSRemarkFooterView     *_remarkFooter;
    HXSBorrowEmptyRepaymentView     *_emptyListFooter;
    NSMutableArray          *_expandRows;
}

@property (nonatomic) HXSBillRepaymentInfo *repaymentInfo;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *installmentRecordButton;

- (void)setupView;

- (void)updateRemarkLabel;
- (void)updateTotalRepaymentValue;
- (void)getRepaymentList;  // 近期应还款

@end

@implementation HXSBorrowBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = (nil == self.itemTitleStr) ? @"近期应还款" : self.itemTitleStr;
    
    [self setupView];
    [self updateRemarkLabel];
    [self updateTotalRepaymentValue];
    [self getRepaymentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setupView
{
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
    _header = [[HXSBorrowBillHeaderView alloc] init];
    _expandRows = [NSMutableArray array];
    
    _remarkFooter = [[HXSRemarkFooterView alloc] init];
    _emptyListFooter = [HXSBorrowEmptyRepaymentView viewFromNib];
    
    self.installmentRecordButton.layer.borderColor = [UIColor colorWithRGBHex:0xE1E2E3].CGColor;
    self.installmentRecordButton.layer.borderWidth = 1;
}

- (void)updateTotalRepaymentValue
{
    _header.price = _repaymentInfo.recentBillAmountNum.doubleValue;
}

- (void)getRepaymentList
{
    WS(weakSelf);
    [HXSBillModel getRepaymentRecord:^(HXSErrorCode code, NSString *message, HXSBillRepaymentInfo *info) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        _repaymentInfo = info;
        [self.tableView reloadData];
        if (_repaymentInfo.billsArr.count == 0){
        }
        else
        {
            [_tableView  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_installmentRecordButton.mas_top);
            }];
        }
        [self updateRemarkLabel];
        [self updateTotalRepaymentValue];
    }];
}

// 备注
- (void)updateRemarkLabel
{
    NSString *cardNumber = [[HXSUserAccount currentAccount] userInfo].creditCardInfo.bankCardTailStr;
    NSString *totalText;
    
    // 绑定银行卡存在且不为空
    if (nil != cardNumber && cardNumber.length > 0) {
        totalText = [NSString stringWithFormat:@"1.以上为近30天需要还款的账单。\n2.还款方式是自动从绑定的银行卡中扣款，为避免逾期，请确保您绑定的银行卡（尾号为%@）资金充足，以免扣款失败。",cardNumber];
    }
    else {
        totalText = @"1.以上为近30天需要还款的账单。\n2.还款方式是自动从绑定的银行卡中扣款，为避免逾期，请确保您绑定的银行卡资金充足，以免扣款失败。";
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalText attributes:
                                                        @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x999999],
                                                          NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                                          NSParagraphStyleAttributeName: style}];
    
    if (nil != cardNumber && cardNumber.length > 0){
        NSRange range = [totalText rangeOfString:cardNumber];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0xF54642]} range:range];
    }
    
    _remarkFooter.attributeText = attributeStr;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repaymentInfo.billsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepaymentRecordCell" forIndexPath:indexPath];
    
    HXSBorrowRepaymentAmountCell *repaymentCell = (HXSBorrowRepaymentAmountCell*)cell;
    [repaymentCell.expandBtn addTarget:self action:@selector(cellExpandBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    repaymentCell.record = _repaymentInfo.billsArr[indexPath.row];

    cell.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 190;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_repaymentInfo.billsArr.count == 0) {
        return 340;
    }
    
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_repaymentInfo.billsArr.count == 0) {
        return _emptyListFooter;
    }
    
    return _remarkFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_expandRows containsObject:indexPath]) {
        return 148.0;
    }
    
    return 68.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - Target/Action

- (void)cellExpandBtnPressed:(UIButton *)btn
{
    UITableViewCell *cell = (UITableViewCell *)[btn superviewOfClassType:[UITableViewCell class]];
    
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *idxPath = [self.tableView indexPathForCell:cell];
        
        if ([_expandRows containsObject:idxPath]) {
            NSInteger idx = [_expandRows indexOfObject:idxPath];
            if ((idx >= 0) && (idx < _expandRows.count)) {
                [_expandRows removeObjectAtIndex:idx];
            }
        }
        else {
            [_expandRows addObject:idxPath];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (IBAction)cashRecordBarButtonPressed:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"HXSCreditPay" bundle:[NSBundle mainBundle]];
    HXSBorrowCashRecordViewController *borrowCashRecordViewController = [story instantiateViewControllerWithIdentifier:@"HXSBorrowCashRecordViewController"];
    [self.navigationController pushViewController:borrowCashRecordViewController animated:YES];
}

@end
