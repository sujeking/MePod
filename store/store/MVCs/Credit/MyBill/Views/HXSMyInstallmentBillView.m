//
//  HXSMyInstallmentBill.m
//  store
//
//  Created by J006 on 16/2/16.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSMyInstallmentBillView.h"
#import "HXSRemarkFooterView.h"
#import "HXSBorrowEmptyRepaymentView.h"
#import "HXSBillRepaymentInfo.h"
#import "HXSBillModel.h"
#import "HXSBorrowRepaymentAmountCell.h"
#import "HXSBorrowBillHeaderView.h"
#import "UIView+Utilities.h"

//static NSInteger installmentMainTableViewHeaderViewHeight = 88;
//static NSInteger installmentMainTableViewFooterViewHeight = 180;

@interface HXSMyInstallmentBillView ()

@property (weak, nonatomic) IBOutlet UIButton                       *installmentRecordButton;
@property (weak, nonatomic) IBOutlet UITableView                    *tableView;
@property (nonatomic)                HXSBillRepaymentInfo           *repaymentInfo;
@property (strong, nonatomic)        HXSBorrowBillHeaderView        *header;
@property (strong, nonatomic)        HXSRemarkFooterView            *remarkFooter;
@property (strong, nonatomic)        HXSBorrowEmptyRepaymentView    *emptyListFooter;
@property (strong, nonatomic)        NSMutableArray                 *expandRows;

@end

@implementation HXSMyInstallmentBillView

- (void)awakeFromNib
{
    [self   initTheTableView];
    [self   setupView];
    [self   updateRemarkLabel];
    [self   updateTotalRepaymentValue];
    [self   getRepaymentList];
}

+(id)myInstallmentBill
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
}

/**
 *  初始化订单列表部分相关设置
 */
- (void)initTheTableView
{
    _tableView.separatorInset    =   UIEdgeInsetsMake(0, 55, 0, 0);//分割线缩进
    _tableView.separatorColor    =   UIColorFromRGB(0xE1E2E3);//分割线颜色
//    [_installmentMainTableView   setTableFooterView:self.tableViewFooterView];
//    [_tableViewFooterView    mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_installmentMainTableView);
//        make.bottom.mas_equalTo(_installmentMainTableView.contentSize.height);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.height.mas_equalTo(installmentMainTableViewFooterViewHeight);
//    }];
}

- (void)setupView
{
    _header = [[HXSBorrowBillHeaderView alloc] init];
    _expandRows = [NSMutableArray array];
    _remarkFooter = [[HXSRemarkFooterView alloc] init];
    _emptyListFooter = [HXSBorrowEmptyRepaymentView viewFromNib];
}

- (void)updateTotalRepaymentValue
{
//    CGFloat totalPrice = 0.00;
//    for (int i = 0 ; i < _repaymentInfo.records.count ; i++) {
//        HXSBillRepaymentItem *item = _repaymentInfo.records[i];
//        totalPrice += item.amount;
//    }
    
    _header.price = _repaymentInfo.recentBillAmountNum.doubleValue;
    
}

- (void)getRepaymentList
{
    [HXSBillModel getRepaymentRecord:^(HXSErrorCode code, NSString *message, HXSBillRepaymentInfo *info) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        
        _repaymentInfo = info;
        [_tableView reloadData];
        [self updateRemarkLabel];
        [self updateTotalRepaymentValue];
    }];
}

- (void)updateRemarkLabel
{
    NSString *cardNumber = @""; //(_repaymentInfo.tailNumber.length > 0) ? _repaymentInfo.tailNumber : @"";
    NSString *totalText;
    
    if (cardNumber.length > 0) {
        totalText = [NSString stringWithFormat:@"1.以上为近30天需要还款的账单。\n2.还款方式是自动从绑定的银行卡中扣款，为避免逾期，请确保您绑定的银行卡（尾号为%@）资金充足，以免扣款失败。",cardNumber];
    }
    else {
        totalText = @"1.以上为近30天需要还款的账单。\n2.还款方式是自动从绑定的银行卡中扣款，为避免逾期，请确保您绑定的银行卡资金充足，以免扣款失败。";
    }
    
    NSRange range = [totalText rangeOfString:cardNumber];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:totalText attributes:
                                               @{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0x999999],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:13.0],
                                                 NSParagraphStyleAttributeName: style}];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRGBHex:0xFE6F38]} range:range];
    
    _remarkFooter.attributeText = attributeStr;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _repaymentInfo.billsArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

#pragma mark UITableViewDelegate

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

#pragma mark getter setter


@end
