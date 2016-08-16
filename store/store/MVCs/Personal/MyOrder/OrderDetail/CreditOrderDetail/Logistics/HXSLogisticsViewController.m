//
//  HXSLogisticsViewController.m
//  store
//
//  Created by ArthurWang on 16/3/3.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSLogisticsViewController.h"
#import "HXSLogisticDetailCell.h"
#import "HXSLogisticHeaderView.h"
#import "HXSLogisticModel.h"
#import "HXSLogisticEntity.h"

@interface HXSLogisticsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *logisticsTableView;

@property (nonatomic, strong) HXSLogisticEntity *logisticEntity;

@property (nonatomic, strong) HXSLogisticModel *logisticModel;

@end

@implementation HXSLogisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigationBar];
    
    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    self.navigationItem.title = @"追踪物流";
}

- (void)initialTableView
{
    self.logisticsTableView.delegate = self;
    self.logisticsTableView.dataSource = self;
    
    [self.logisticsTableView registerNib:[UINib nibWithNibName:@"HXSLogisticDetailCell" bundle:nil] forCellReuseIdentifier:@"HXSLogisticDetailCell"];
    
    __weak typeof(self) weakSelf = self;
    [self.logisticsTableView addRefreshHeaderWithCallback:^{
        [weakSelf requestData];
    }];
    
    [HXSLoadingView showLoadingInView:self.view];
    [self requestData];
}


#pragma mark --- setter getter methods

- (HXSLogisticModel *)logisticModel
{
    if (nil == _logisticModel) {
        _logisticModel = [[HXSLogisticModel alloc] init];
    }
    return _logisticModel;
}


#pragma mark --- request data

- (void)requestData
{
    __weak typeof(self) weakself = self;
    [self.logisticModel getLogisticWithOrderSn:self.orderInfo.order_sn
                               MessageComplete:^(HXSErrorCode code, NSString *message, HXSLogisticEntity *logisticEntity) {
                                   [weakself.logisticsTableView endRefreshing];
                                   [HXSLoadingView closeInView:weakself.view];
        
                                    if (kHXSNoError != code) {
                                        if (weakself.isFirstLoading) {
                                            [HXSLoadingView showLoadFailInView:weakself.view
                                                                         block:^{
                                                                             [weakself requestData];
                                                                         }];
                                        } else {
                                            [MBProgressHUD showInViewWithoutIndicator:weakself.view
                                                                               status:message
                                                                           afterDelay:2.0f];
                                        }
                                        
                                        return ;
                                    }
                                   
                                   weakself.firstLoading = NO;
                                    
                                    weakself.logisticEntity = logisticEntity;
                                   
                                   [weakself.logisticsTableView reloadData];
    }];
    
}


#pragma mark ---- tableView delegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logisticEntity.logisticRecordsMArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 76.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *logisticArr = [[NSBundle mainBundle] loadNibNamed:@"HXSLogisticHeaderView" owner:self options:nil];
    
    HXSLogisticHeaderView *logisticHeaderView = [logisticArr lastObject];
    
    logisticHeaderView.expressNumberLabel.text = self.logisticEntity.logisticNumberStr;
    
    return logisticHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSLogisticDetailCell *logisticCell = [tableView dequeueReusableCellWithIdentifier:@"HXSLogisticDetailCell"];
    
    HXSLogisticRecordsEntity *logisticRecordEntity = [self.logisticEntity.logisticRecordsMArr objectAtIndex:indexPath.row];
    
    //地址：【广州】xxxxxx \n时间： 00：37：02 2016-01-22
    logisticCell.timeLabel.text = (0 < [logisticRecordEntity.timeStr length]) ? logisticRecordEntity.timeStr : @"";
    logisticCell.descLabel.text = logisticRecordEntity.descStr;
    
    if (0 == indexPath.row) {
        [logisticCell.topLineView setHidden:YES];
        [logisticCell.bottomLineView setHidden:NO];
        [logisticCell.dotImageView setImage:[UIImage imageNamed:@"ic_dot_logistics"]];
        logisticCell.descLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
        logisticCell.timeLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
    } else if (indexPath.row == ([self.logisticEntity.logisticRecordsMArr count] - 1)) {
        [logisticCell.topLineView setHidden:NO];
        [logisticCell.bottomLineView setHidden:YES];
        [logisticCell.dotImageView setImage:nil];
        logisticCell.descLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        logisticCell.timeLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    } else {
        [logisticCell.topLineView setHidden:NO];
        [logisticCell.bottomLineView setHidden:NO];
        [logisticCell.dotImageView setImage:nil];
        logisticCell.descLabel.textColor = [UIColor colorWithRGBHex:0x999999];
        logisticCell.timeLabel.textColor = [UIColor colorWithRGBHex:0x999999];
    }
    
    return logisticCell;
}

@end
