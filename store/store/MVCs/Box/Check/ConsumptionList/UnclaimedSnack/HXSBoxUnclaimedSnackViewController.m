//
//  HXSBoxUnclaimedSnackViewController.m
//  store
//
//  Created by 格格 on 16/5/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxUnclaimedSnackViewController.h"

// Views
#import "HXSBoxCheckCell.h"
#import "HXSBoxModel.h"

static NSString *HXSBoxCheckCellId = @"HXSBoxCheckCell";

@interface HXSBoxUnclaimedSnackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak  ) IBOutlet UITableView    *myTable;

@property (nonatomic, strong) NSNumber       *quantityNum;
@property (nonatomic, strong) NSMutableArray *snacksArr;

@property (nonatomic, strong) NSNumber       *boxIdNum;// 盒子ID
@property (nonatomic, strong) NSNumber       *batchIdNum;// 批次号

@end

@implementation HXSBoxUnclaimedSnackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    
    [self initialPrama];
    
    [self initialTable];
    
    [self fetBoxConsumUntakeList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

+ (instancetype)controllerWithBoxId:(NSNumber *)boxId bactchId:(NSNumber *)bactchId;
{
    HXSBoxUnclaimedSnackViewController *controller = [HXSBoxUnclaimedSnackViewController controllerFromXib];
    
    controller.boxIdNum = boxId;
    controller.batchIdNum = bactchId;
    return controller;
}

#pragma mark - initial
- (void)initialNav
{
    self.navigationItem.title = @"已支付未领取零食";
}

- (void)initialPrama
{
    self.snacksArr = [NSMutableArray array];
    self.quantityNum = @(0);
}

- (void)initialTable
{
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.allowsSelection = NO;
    [self.myTable registerNib:[UINib nibWithNibName:HXSBoxCheckCellId bundle:nil] forCellReuseIdentifier:HXSBoxCheckCellId];
}

#pragma mark - webService

- (void)fetBoxConsumUntakeList
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [HXSBoxModel fetBoxConsumUnTakeListWithBoxId:self.boxIdNum  batchNo:self.batchIdNum complete:^(HXSErrorCode code, NSString *message, NSArray *items, NSNumber *quantity) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code){
            [weakSelf.snacksArr removeAllObjects];
            [weakSelf.snacksArr addObjectsFromArray:items];
            weakSelf.quantityNum = quantity;
            [weakSelf.myTable reloadData];
        }else{
            [MBProgressHUD showInView:weakSelf.view
                           customView:nil
                               status:message
                           afterDelay:1.0f];
        }
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSourec

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.snacksArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.snacksArr.count){
        HXSBoxCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSBoxCheckCellId];
        HXSDormItem *temp = [self.snacksArr objectAtIndex:indexPath.row];
        cell.boxItem = temp;
        return cell;
    }else{
        static NSString *cellId = @"unclaimedSnackCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(nil == cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setTextColor:HXS_TITLE_NOMARL_COLOR];
            
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14]];
            [cell.detailTextLabel setTextColor:HXS_SPECIAL_COLOR];
        }
        cell.textLabel.text = @"数量总计";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d件",self.quantityNum.intValue];
        return  cell;
    }
}

#pragma mark - setter

- (void)setBoxIdNum:(NSNumber *)boxIdNum
{
    _boxIdNum = nil;
    _boxIdNum = [boxIdNum copy];
}

@end
