//
//  HXSInfoSubmitCompleteViewController.m
//  store
//
//  Created by  黎明 on 16/7/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSEditDormAddress.h"

#import "HXSInputTableViewCell.h"
#import "HXSEditDormAddressFooterView.h"
#import "HXSEditDormAddressViewModel.h"


static NSString * const InputTableViewCell = @"HXSInputTableViewCell";


@interface HXSEditDormAddress ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSString *addressString;
@property (nonatomic, strong) HXSEditDormAddressFooterView *editDormAddressFooterView;
@end

@implementation HXSEditDormAddress

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialNavigationBar];
    [self tableViewRegisterCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init

- (void)initialNavigationBar
{
    self.navigationItem.title = @"宿舍信息";
}


- (void)tableViewRegisterCell
{

    UINib *nib = [UINib nibWithNibName:InputTableViewCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:InputTableViewCell];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    [footerView addSubview:self.editDormAddressFooterView];
    
    [self.editDormAddressFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(footerView);
    }];
    
    [self.tableview setTableFooterView:footerView];
}


#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InputTableViewCell forIndexPath:indexPath];
    [cell.addressTextField addTarget:self action:@selector(addressTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)addressTextFieldChange:(UITextField *)textField
{
    [self.editDormAddressFooterView.commitButton setEnabled:(textField.text.length == 0) ? NO : YES];
    self.addressString = textField.text;
}

- (void)commitAddreInfoToServer
{
    WS(weakSelf);
    
    HXSEditDormAddressViewModel *viewModel = [[HXSEditDormAddressViewModel alloc] init];
    
    [viewModel commitDormAddress:self.addressString complete:^(HXSErrorCode status, NSString *message) {
        
        [MBProgressHUD showInView:self.view customView:nil status:message afterDelay:2];
        
        if (status == kHXSNoError) {
            
            [weakSelf performSelector:@selector(back) withObject:nil afterDelay:2.5];
        }
    }];
}

- (HXSEditDormAddressFooterView *)editDormAddressFooterView
{
    WS(weakSelf);
    
    if (!_editDormAddressFooterView) {
        _editDormAddressFooterView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([HXSEditDormAddressFooterView class])
                                                                   owner:nil options:nil].firstObject;
        [_editDormAddressFooterView setSubmitButtonClickBlock:^{
            [weakSelf commitAddreInfoToServer];
        }];

    }
    return _editDormAddressFooterView;
}

@end
