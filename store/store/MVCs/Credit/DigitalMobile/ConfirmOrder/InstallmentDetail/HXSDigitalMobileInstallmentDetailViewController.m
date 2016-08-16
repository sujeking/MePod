//
//  HXSDigitalMobileInstallmentDetailViewController.m
//  store
//
//  Created by ArthurWang on 16/3/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileInstallmentDetailViewController.h"
#import "HXSInstallmentDetailCell.h"
#import "HXSInstallmentDetailHeaderView.h"
#import "HXSPickView.h"
#import "HXSCustomPickerView.h"
#import "HXSInstallmentDetailModel.h"

@interface HXSDigitalMobileInstallmentDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *downPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *installmentLabel;
@property (strong, nonatomic) HXSInstallmentDetailHeaderView *headerView;

@property (strong, nonatomic) NSArray *downPaymentList;
@property (strong, nonatomic) NSArray *installmentList;

@property (nonatomic) NSInteger selectedIndexOfInstallment;
@property (strong, nonatomic) HXSInstallmentDetailModel *installmentDetailModel;
@property (nonatomic, strong) HXSDigitalMobileInstallmentDetailEntity *digitalMobileInstallmentDetail;
@end

@implementation HXSDigitalMobileInstallmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"分期详情";
    
    HXSUserInfo * userInfo = [[HXSUserAccount currentAccount] userInfo];
    self.digitalMobileInstallmentDetail.installmentLimit = userInfo.creditCardInfo.availableInstallmentDoubleNum;
    
    [self initHeaderView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HXSInstallmentDetailCell" bundle:nil] forCellReuseIdentifier:@"HXSInstallmentDetailCellIdentify"];
    
    [self getDownpaymentEntityList];
}

- (void)initDigitalMobileInstallmentDetailEntity:(HXSConfirmOrderEntity *)confirmOrderEntity
{
    self.digitalMobileInstallmentDetail = [[HXSDigitalMobileInstallmentDetailEntity alloc] init];
    self.digitalMobileInstallmentDetail.installmentLimit = confirmOrderEntity.installmentInfo.installmentLimit;
    self.digitalMobileInstallmentDetail.spend = confirmOrderEntity.total;
    self.digitalMobileInstallmentDetail.downpayment = confirmOrderEntity.installmentInfo.downpayment;
    self.digitalMobileInstallmentDetail.installment = confirmOrderEntity.installmentInfo.installment;
}

- (void)initHeaderView
{
    self.headerView = [[[NSBundle mainBundle] loadNibNamed:@"HXSInstallmentDetailHeaderView" owner:nil options:nil] firstObject];
    self.headerView.controller = self;
    [self.headerView initInstallHeaderView:self.digitalMobileInstallmentDetail];
}

- (void)getDownpaymentEntityList
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.installmentDetailModel fetchDownpaymentListWithPrice:self.digitalMobileInstallmentDetail.spend Complete:^(HXSErrorCode code, NSString *message, NSArray *downpaymentEntityList) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.downPaymentList = downpaymentEntityList;
        
        if (weakSelf.downPaymentList.count > 0) {
            NSInteger index = [weakSelf getIndexOfDownPayment:downpaymentEntityList];
            [weakSelf selectDownPaymentPercent:index];
        }
    }];
    
}

- (void)selectDownPaymentPercent:(NSInteger)index
{
    self.digitalMobileInstallmentDetail.downpayment = self.downPaymentList[index];
    [self.headerView updateInstallHeaderView:self.digitalMobileInstallmentDetail];
    
    self.downPaymentLabel.text = self.headerView.paymentAmountLabel.text;
    
    [self getInstallmentListWithPrice:self.digitalMobileInstallmentDetail.spend percent:self.digitalMobileInstallmentDetail.downpayment.percent];
}

- (void)getInstallmentListWithPrice:(NSNumber *)price percent:(NSNumber *)percent
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.installmentDetailModel fetchInstallmentInfoWithPrice:price percent:percent complete:^(HXSErrorCode code, NSString *message, HXSInstallmentEntity *installmentEntity) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        weakSelf.installmentList = installmentEntity.installmentList;
        
        if (weakSelf.installmentList.count >0) {
            
            NSInteger index = [self getIndexOfInstallment:weakSelf.installmentList];
            weakSelf.digitalMobileInstallmentDetail.installment = weakSelf.installmentList[index];
            weakSelf.selectedIndexOfInstallment = index;
        }
        
        [weakSelf.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.installmentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSInstallmentDetailCell *installmentDetailCell = [tableView dequeueReusableCellWithIdentifier:@"HXSInstallmentDetailCellIdentify"];
    installmentDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    installmentDetailCell.controller = self;
    
    if (self.selectedIndexOfInstallment == indexPath.row) {
        installmentDetailCell.iconImageView.image = [UIImage imageNamed:@"ic_choose_selected"];
        [self updateBottomInstallmentInfo];
    }else {
        installmentDetailCell.iconImageView.image = [UIImage imageNamed:@"ic_choose_normal"];
    }
    
    [installmentDetailCell initCellLabel:self.installmentList[indexPath.row]];
    
    return installmentDetailCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexOfInstallment = indexPath.row;
    self.digitalMobileInstallmentDetail.installment = self.installmentList[indexPath.row];
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 209.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}


#pragma mark - selectDownPayment

- (void)selectDownPayment
{
    __weak typeof(self) weakSelf = self;
    [HXSCustomPickerView showWithStringArray:[self getPercentList] defaultValue:self.digitalMobileInstallmentDetail.downpayment.percentDesc toolBarColor:[UIColor whiteColor] completeBlock:^(int index, BOOL finished) {
        if (finished) {
            weakSelf.digitalMobileInstallmentDetail.downpayment = weakSelf.downPaymentList[index];
            
            [weakSelf selectDownPaymentPercent:index];
        }
    }];
}

- (NSArray *)getPercentList
{
    NSMutableArray *percentDescList = [[NSMutableArray alloc] init];
    for (HXSDownpaymentEntity *downpaymentEntity in self.downPaymentList) {
        [percentDescList addObject:downpaymentEntity.percentDesc];
    }
    
    return percentDescList;
}

- (NSInteger)getIndexOfDownPayment:(NSArray *)downPaymentList
{
    NSInteger index = 0;
    for (int i = 0; i < downPaymentList.count; i++) {
        HXSDownpaymentEntity *downPayment = downPaymentList[i];
        
        if ([self.digitalMobileInstallmentDetail.downpayment.percentDesc isEqualToString:downPayment.percentDesc]) {
            index = i;
            break;
        }
    }
    
    return index;
}

- (NSInteger)getIndexOfInstallment:(NSArray *)installmentList
{
    NSInteger index = 0;
    for (int i = 0; i < installmentList.count; i++) {
        HXSInstallmentItemEntity *installment = installmentList[i];
        
        if (self.digitalMobileInstallmentDetail.installment.installmentMoney.integerValue == installment.installmentMoney.integerValue) {
            index = i;
            break;
        }
    }
    
    return index;
}


#pragma mark - update installment info at bottom view

- (void)updateBottomInstallmentInfo
{
    HXSInstallmentItemEntity *installmentItemEntity = self.digitalMobileInstallmentDetail.installment;
    self.installmentLabel.text = [NSString stringWithFormat:@"￥%0.2f×%i期",installmentItemEntity.installmentMoney.floatValue,installmentItemEntity.installmentNum.intValue];
}


#pragma mark - Setter Getter Methods

- (HXSInstallmentDetailModel *)installmentDetailModel
{
    if (nil == _installmentDetailModel) {
        _installmentDetailModel = [[HXSInstallmentDetailModel alloc] init];
    }
    
    return _installmentDetailModel;
}


#pragma mark - finish

- (IBAction)finish:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectInstallmentDetail:)]) {
        [self.delegate performSelector:@selector(didSelectInstallmentDetail:) withObject:self.digitalMobileInstallmentDetail];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
