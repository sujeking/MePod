//
//  HXSGetCashViewController.m
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSGetCashViewController.h"
#import "HXSMyTableViewCell.h"
#import "HXSGetCashTableViewCell.h"
#import "HXSGetCrashTableFooterView.h"
#import "HXSCashModel.h"
#import "HXSBankListViewController.h"

#define MAX_LENTH 3
#define limited 2

static NSString *HXSGetCashTableViewCellId = @"HXSGetCashTableViewCell";

@interface HXSGetCashViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTable;

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) HXSGetCashTableViewCell *crashAmountCell; // 取现金额
@property (nonatomic, strong) HXSGetCashTableViewCell *bankCell; // 所属银行
@property (nonatomic, strong) HXSGetCashTableViewCell *cityCell; // 开户城市
@property (nonatomic, strong) HXSGetCashTableViewCell *netDotCell; // 开户网点
@property (nonatomic, strong) HXSGetCashTableViewCell *cardNumCell; // 银行卡号
@property (nonatomic, strong) HXSGetCashTableViewCell *nameCell; // 用户姓名

@property (nonatomic, strong) HXSGetCrashTableFooterView *footerView;

@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, strong) HXSKnightInfo *knightInfo;

@end

@implementation HXSGetCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialMyTable];
    [self initialPrama];
    [self getKnightInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setMaxCashAmount:(NSNumber *)totalAmount{
    _totalAmount = totalAmount;
}

#pragma mark - initial
- (void)initialNav{
    self.navigationItem.title = @"申请取现";
}

- (void)initialMyTable{
    
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
 
    [self.myTable setBackgroundColor:[UIColor colorWithRGBHex:0xf4f5f6]];
    
    _cellArray = [NSMutableArray arrayWithObjects:
                  self.crashAmountCell,
                  self.bankCell,
                  self.cityCell,
                  self.netDotCell,
                  self.cardNumCell,
                  self.nameCell,
                  nil];
    
    [self.myTable registerNib:[UINib nibWithNibName:HXSGetCashTableViewCellId bundle:nil] forCellReuseIdentifier:HXSGetCashTableViewCellId];
    
    [self.myTable setTableFooterView:self.footerView];
}

- (void)initialPrama{
   self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}


#pragma mark - webService
- (void)getKnightInfo{
    
    [MBProgressHUD showInView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [HXSCashModel getKnightInfo:^(HXSErrorCode code, NSString *message, HXSKnightInfo *knightInfo) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(kHXSNoError == code){
            weakSelf.knightInfo = knightInfo;
        }else{
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1];
        }
    }];

}

#pragma mark - TarGet/Action
// 点击申请取现按钮
- (void)getCrashButtonClicked{
    
    [MBProgressHUD showInView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [HXSCashModel knightWithdrawWithAmount:[NSNumber numberWithDouble:_crashAmountCell.textField.text.doubleValue]
                                bankCardNo:_cardNumCell.textField.text
                                  bankName:_bankCell.textField.text
                                  bankCity:_cityCell.textField.text
                              bankUserName:_nameCell.textField.text
                                  bankSite:_netDotCell.textField.text
                                  bankCode:self.knightInfo.bankCodeStr
                                  complete:^(HXSErrorCode code, NSString *message, NSDictionary *data) {
                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                                      if(kHXSNoError == code){
                                          
                                          [weakSelf.delegate getCashSuccessed];
                                          [MBProgressHUD showInView:weakSelf.view customView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_done"]] status:@"申请成功" afterDelay:1.5 completeBlock:^{
                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                          }];
                                          
                                      }else{
                                          [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5];
                                      }
    }];
    
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.crashAmountCell.textField){
        
        //第一个字符不能的小数点
        if(string.length > 0){
            unichar single = [string characterAtIndex:0];//当前输入的字符
            NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (aString.length > 10) {
                return NO;
            }
            
            if(textField.text.length <= 0){
                if(single == '.')
                    return NO;
            }
            //
            BOOL hasDot = NO;
            if ([textField.text rangeOfString:@"."].location == NSNotFound){
                hasDot = NO;
            }else{
                hasDot = YES;
            }
            
            if(hasDot){ // 小数点存在
                if(single == '.'){
                    return NO;
                }
                else{
                    NSRange dotRange = [aString rangeOfString:@"."];
                    if(aString.length - 1 - dotRange.location > 2)
                        return NO;
                }
            }
        }
        
    }
    return YES;
}


#pragma mark - UITableViewDelegate/UITablbeViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(0 == section)
        return 1;
    return [_cellArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section)
        return 40;
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0 == indexPath.section){
        static NSString *cellId = @"crashCell";
        HXSMyTableViewCell * cell = (HXSMyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
        if(nil == cell){
            cell = [[HXSMyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        [cell setBackgroundColor:[UIColor colorWithRGBHex:0xf6fdff]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = @"当前可取现金额：";
        [cell.textLabel setTextColor:[UIColor colorWithRGBHex:0x07a9fa]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell.textLabelRect = CGRectMake(15, 0, 110, 40);
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",self.totalAmount.doubleValue];
        cell.detialTextLabelRect = CGRectMake(115, 0, SCREEN_WIDTH - 130, 40);
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRGBHex:0xf54642]];
        return cell;
    }else{
        HXSGetCashTableViewCell *cell = [_cellArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(0 == indexPath.section){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    HXSGetCashTableViewCell *cell = [_cellArray objectAtIndex:indexPath.row];
    if(cell == self.bankCell){
        HXSBankListViewController *bankListViewController = [[HXSBankListViewController alloc]initWithNibName:nil bundle:nil];
        __weak typeof(self) weakSelf = self;
        bankListViewController.completion = ^(HXSBankEntity *item){
            [weakSelf selectBank:item];
        };
        [self.navigationController pushViewController:bankListViewController animated:YES];
    }
}

- (void)selectBank:(HXSBankEntity *)item{
    
    self.knightInfo.bankCodeStr = item.codeStr;
    self.knightInfo.bankNameStr = item.nameStr;
    self.bankCell.textField.text = item.nameStr;
    [self.myTable reloadData];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - Get Set Methods

- (BOOL)getCrashButtonEnable{
    
    /*
     取现金额,所属银行,开户城市,银行卡号,用户姓名 必须填写，开户网点可不写
     */
    
    if(self.crashAmountCell.textField.text.length <= 0)
        return NO;
    if(self.bankCell.textField.text.length <= 0)
        return NO;
    if(self.cityCell.textField.text.length <= 0)
        return NO;
    if(self.cardNumCell.textField.text.length <= 0)
        return NO;
    if(self.nameCell.textField.text.length <= 0)
        return NO;
    
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (HXSGetCashTableViewCell *)crashAmountCell{
    if(_crashAmountCell)
        return _crashAmountCell;
    _crashAmountCell = [HXSGetCashTableViewCell crashTableViewCell];
    _crashAmountCell.nameLabel.text = @"取现现金";
    _crashAmountCell.textField.placeholder = @"请填写";
    _crashAmountCell.textField.delegate = self;
    _crashAmountCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    return _crashAmountCell;
}

- (HXSGetCashTableViewCell *)bankCell{
    if(_bankCell)
        return _bankCell;
    _bankCell = [HXSGetCashTableViewCell crashTableViewCell];
    _bankCell.nameLabel.text = @"所属银行";
    _bankCell.textField.placeholder = @"请选择";
    _bankCell.textField.delegate = self;
    _bankCell.textField.enabled = NO;
    return _bankCell;
}

- (HXSGetCashTableViewCell *)cityCell{
    if(_cityCell)
        return _cityCell;
    _cityCell = [HXSGetCashTableViewCell crashTableViewCell];
    _cityCell.nameLabel.text = @"开户城市";
    _cityCell.textField.placeholder = @"请填写";
    _cityCell.textField.delegate = self;
    return _cityCell;
}

- (HXSGetCashTableViewCell *)netDotCell{
    if(_netDotCell)
        return _netDotCell;
    _netDotCell = [HXSGetCashTableViewCell crashTableViewCell];
    _netDotCell.nameLabel.text = @"开户网点";
    _netDotCell.textField.placeholder = @"请填写";
    _netDotCell.textField.delegate = self;
    return _netDotCell;
}

- (HXSGetCashTableViewCell *)cardNumCell{
    if(_cardNumCell)
        return _cardNumCell;
    _cardNumCell = [HXSGetCashTableViewCell crashTableViewCell];
    _cardNumCell.nameLabel.text = @"银行卡号";
    _cardNumCell.textField.placeholder = @"请填写";
    _cardNumCell.textField.delegate = self;
    _cardNumCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    return _cardNumCell;
}

- (HXSGetCashTableViewCell *)nameCell{
    if(_nameCell)
        return _nameCell;
    _nameCell = [HXSGetCashTableViewCell crashTableViewCell];
    _nameCell.nameLabel.text = @"户主姓名";
    _nameCell.textField.placeholder = @"请填写";
    _nameCell.textField.delegate = self;
    return _nameCell;
}

- (HXSGetCrashTableFooterView *)footerView{
    if(_footerView)
        return _footerView;
    
    _footerView = [HXSGetCrashTableFooterView footerView];
    [_footerView.getCrashButton setTitleColor:[UIColor colorWithR:255 G:255 B:255 A:0.5] forState:UIControlStateDisabled];
    [_footerView.getCrashButton addTarget:self
                                   action:@selector(getCrashButtonClicked)
                         forControlEvents:UIControlEventTouchUpInside];
    
    return _footerView;
}

- (void)setKnightInfo:(HXSKnightInfo *)knightInfo{
    
    _knightInfo = knightInfo;
    self.bankCell.textField.text = _knightInfo.bankNameStr;
    self.cityCell.textField.text = _knightInfo.bankCityStr;
    self.cardNumCell.textField.text = _knightInfo.bankCardNoStr;
    self.nameCell.textField.text = _knightInfo.bankUserNameStr;
    
    self.footerView.getCrashButton.enabled = [self getCrashButtonEnable];
}

@end
