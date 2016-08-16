//
//  HXSBankListViewController.m
//  store
//
//  Created by 格格 on 16/5/13.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBankListViewController.h"
#import "HXSBankListCell.h"

static NSString *HXSBankListCellId = @"HXSBankListCell";

@interface HXSBankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *bankList;

@end

@implementation HXSBankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialNav];
    [self initialParam];
    [self initialTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - intial
- (void)initialNav{
    self.navigationItem.title = @"选择所属银行";
}

- (void)initialParam{
    self.bankList = [NSMutableArray array];
}

- (void)initialTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self.tableView registerNib:[UINib nibWithNibName:HXSBankListCellId bundle:nil] forCellReuseIdentifier:HXSBankListCellId];
    
    [self getBankListService];
}


#pragma mark - webServiec

- (void)getBankListService
{
    [HXSLoadingView showLoadingInView:self.view];
    
    __weak typeof(self) weakSelf = self;
    [HXSBankModel getBankList:^(HXSErrorCode code, NSString *message, NSArray *bankList) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            [weakSelf.bankList addObjectsFromArray:bankList];
            [weakSelf.tableView reloadData];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bankList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HXSBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSBankListCellId];
    cell.bankEntity = [self.bankList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_completion) {
        HXSBankEntity *item = _bankList[indexPath.row];
        _completion(item);
        _completion = nil;
    }
    [self back];
}

@end
