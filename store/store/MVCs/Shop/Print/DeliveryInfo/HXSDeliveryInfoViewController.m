//
//  HXSDeliveryInfoViewController.m
//  store
//
//  Created by 格格 on 16/3/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDeliveryInfoViewController.h"

// Model
#import "HXSDeliveryModel.h"

// Views
#import "HXSCustomPickerView.h"
#import "HXSPrintManagerDeliveryInfoCell.h"
#import "HXSMyTableViewCell.h"
#import "HXSPrintSelfDeliveryInfoCell.h"


static NSString *HXSPrintManagerDeliveryInfoCellIdentify = @"HXSPrintManagerDeliveryInfoCell";
static NSString *HXSMyTableViewCellIdentify              = @"HXSMyTableViewCell";
static NSString *HXSPrintSelfDeliveryInfoCellIdentify    = @"HXSPrintSelfDeliveryInfoCell";

@interface HXSDeliveryInfoViewController ()<UITableViewDataSource,
                                            UITableViewDelegate,
                                            HXSPrintManagerDeliveryInfoCellDelegate,
                                            HXSPrintSelfDeliveryInfoCellDelegate>

@property(weak,nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *deliveriesMutArr;
@property(nonatomic,strong) NSMutableArray *deliveryTimeStrArr;
@property(nonatomic,strong) HXSDeliveryEntity *selectDeliveryEntity;
@property(nonatomic,strong) HXSDeliveryTime *selectDeliveryTime;

@end

@implementation HXSDeliveryInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNavigation];
    [self initialAttribute];
    [self initialTableView];
    
    [self getDeliveries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setSelectDeliveryEntity:(HXSDeliveryEntity *)selectDeliveryEntity selectDeliveryTime:(HXSDeliveryTime *)selectDeliveryTime
{
        self.selectDeliveryEntity = selectDeliveryEntity;
        self.selectDeliveryTime = selectDeliveryTime;
        [self.tableView reloadData];
}


#pragma mark - initialMathod

-(void)initialNavigation
{
   self.navigationItem.title = @"配送信息";
    
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onClickSaveButton:)];
}

-(void)initialAttribute
{
    self.deliveriesMutArr = [NSMutableArray array];
}

-(void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:HXSPrintManagerDeliveryInfoCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintManagerDeliveryInfoCellIdentify];
    [self.tableView registerNib:[UINib nibWithNibName:HXSPrintSelfDeliveryInfoCellIdentify bundle:nil] forCellReuseIdentifier:HXSPrintSelfDeliveryInfoCellIdentify];
}

-(void)initialDeliveryTimeStrArr
{
    if(!self.deliveryTimeStrArr) {
        self.deliveryTimeStrArr = [NSMutableArray array];
    }
    [self.deliveryTimeStrArr removeAllObjects];
    if(self.selectDeliveryEntity && self.selectDeliveryEntity.deliveryTimesMutArr&&self.selectDeliveryEntity.deliveryTimesMutArr.count > 0){
        for(HXSDeliveryTime *temp in self.selectDeliveryEntity.deliveryTimesMutArr) {
            [self.deliveryTimeStrArr addObject:temp.nameStr];
        }
    }
}


#pragma mark - webServies

-(void)getDeliveries
{
    [MBProgressHUD showInView:self.view];
    __weak typeof(self) weakSelf = self;
    [HXSDeliveryModel getDeliveriesWithShopId:self.shopIdStr complete:^(HXSErrorCode status, NSString *message, NSArray *deliveries) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == status) {
            [weakSelf.deliveriesMutArr removeAllObjects];
            if(deliveries&&deliveries.count > 0) {
                
                [weakSelf.deliveriesMutArr addObjectsFromArray:deliveries];
                weakSelf.selectDeliveryEntity = weakSelf.deliveriesMutArr[0];
                
                if( HXSPrintDeliveryTypeShopOwner == weakSelf.selectDeliveryEntity.sendTypeIntNum.intValue) {
                    if(weakSelf.selectDeliveryEntity.deliveryTimesMutArr &&weakSelf.selectDeliveryEntity.deliveryTimesMutArr.count > 0) {
                        weakSelf.selectDeliveryTime = weakSelf.selectDeliveryEntity.deliveryTimesMutArr[0];
                    }
                }
                
                [weakSelf initialDeliveryTimeStrArr];
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
        }
    }];
}


#pragma mark - Target/Action

// 点击保存
- (void)onClickSaveButton:(id)sender
{
    [self.delegate selectHXSDeliveryEntity:self.selectDeliveryEntity deliveryTime:self.selectDeliveryTime];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.deliveriesMutArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < self.deliveriesMutArr.count&&self.selectDeliveryEntity) {
        HXSDeliveryEntity *temp = self.deliveriesMutArr[section];
        if(HXSPrintDeliveryTypeShopOwner == temp.sendTypeIntNum.intValue) {
            if(temp == self.selectDeliveryEntity)
                return 2;
            return 1;
            
        } else if(HXSPrintDeliveryTypeSelf == temp.sendTypeIntNum.intValue) {
            if(temp == self.selectDeliveryEntity)
                return 3;
            return 1;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.deliveriesMutArr.count&&self.selectDeliveryEntity) {
        HXSDeliveryEntity *temp = self.deliveriesMutArr[indexPath.section];
        if(HXSPrintDeliveryTypeShopOwner == temp.sendTypeIntNum.intValue){
            if( 0 == indexPath.row) {
                return 61;
            } else {
                return 44;
            }
        } else if(HXSPrintDeliveryTypeSelf == temp.sendTypeIntNum.intValue) {
            if(0 == indexPath.row) {
                return 75;
            } else {
                return 44;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.self.deliveriesMutArr.count &&self.selectDeliveryEntity){
        HXSDeliveryEntity *temp = self.deliveriesMutArr[indexPath.section];
        if(HXSPrintDeliveryTypeShopOwner == temp.sendTypeIntNum.intValue) {
            
            if(0 == indexPath.row) {
                
                HXSPrintManagerDeliveryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintManagerDeliveryInfoCellIdentify];
                [cell setupDeliveryEntity:temp indexPath:indexPath];
                cell.cellDelegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if(self.selectDeliveryEntity == temp&&self.selectDeliveryTime) {
                    cell.ifSelected = YES;
                    cell.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
                } else {
                    cell.ifSelected = NO;
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                
                return cell;
            } else {
                
                HXSMyTableViewCell *cell = [[HXSMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HXSMyTableViewCellIdentify];
                
                cell.textLabelRect = CGRectMake(45, 15, 100, 14);
                cell.textLabel.text = @"配送时间";
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
                
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x07A9FA];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                if(self.selectDeliveryTime){
                    cell.detailTextLabel.text = self.selectDeliveryTime.nameStr;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }
        
        } else if(HXSPrintDeliveryTypeSelf == temp.sendTypeIntNum.intValue) {
            if(0 == indexPath.row) {
                
                HXSPrintSelfDeliveryInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HXSPrintSelfDeliveryInfoCellIdentify];
                [cell setupDeliveryEntity:temp indexPath:indexPath];
                cell.cellDelegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                if(self.selectDeliveryEntity == temp) {
                    cell.ifSelected = YES;
                    cell.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
                } else {
                    cell.ifSelected = NO;
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                
                return cell;
            } else if(1 == indexPath.row) { // 自取时间
                HXSMyTableViewCell *cell = [[HXSMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HXSMyTableViewCellIdentify];
                
                cell.textLabelRect = CGRectMake(45, 15, 100, 14);
                cell.textLabel.text = @"自取时间";
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
                
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.text = temp.pickTimeStr ? temp.pickTimeStr : @"";
                
                if(self.selectDeliveryEntity == temp){
                    cell.separatorInset = UIEdgeInsetsMake(0, 45, 0, 0);
                }else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            
            } else if(2 == indexPath.row) { // 自取地址
                
                HXSMyTableViewCell *cell = [[HXSMyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HXSMyTableViewCellIdentify];
                
                cell.textLabelRect = CGRectMake(45, 15, 100, 14);
                cell.textLabel.text = @"自取地址";
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
                
                cell.detailTextLabel.textColor = [UIColor colorWithRGBHex:0x666666];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.text = temp.pickAddressStr ? temp.pickAddressStr : @"";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXSDeliveryEntity *temp = self.deliveriesMutArr[indexPath.section];
    if(HXSPrintDeliveryTypeShopOwner == temp.sendTypeIntNum.intValue && 1 == indexPath.row){
        [self cellSelectDeliveryTime:indexPath];
    }
}


#pragma mark - cellDelegate

- (void)selectButtonClicked:(NSIndexPath *)indexPath
{
    self.selectDeliveryEntity = [self.deliveriesMutArr objectAtIndex:indexPath.section];
    if(HXSPrintDeliveryTypeShopOwner == self.selectDeliveryEntity.sendTypeIntNum.intValue) {
        if(self.selectDeliveryEntity.deliveryTimesMutArr&&self.selectDeliveryEntity.deliveryTimesMutArr.count > 0) {
            self.selectDeliveryTime = self.selectDeliveryEntity.deliveryTimesMutArr[0];
        }
    } else {
        self.selectDeliveryTime = nil;
    }
    [self initialDeliveryTimeStrArr];
    [self.tableView reloadData];
}


#pragma mark - TableViewCellDidSelected

// 点击选择店长配送时间
- (void)cellSelectDeliveryTime:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    [HXSCustomPickerView showWithStringArray:self.deliveryTimeStrArr
                                defaultValue:self.selectDeliveryTime.nameStr
                                toolBarColor:[UIColor whiteColor]
                               completeBlock:^(int index, BOOL finished) {
                                   if (finished) {
                                       weakSelf.selectDeliveryTime = [weakSelf.selectDeliveryEntity.deliveryTimesMutArr objectAtIndex:index];
                                       
                                       [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                   }
                               }];
}

@end
