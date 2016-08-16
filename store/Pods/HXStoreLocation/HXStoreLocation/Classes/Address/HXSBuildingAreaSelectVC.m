//
//  HXSBuildingAreaSelectVC.m
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSBuildingAreaSelectVC.h"
#import "HXStoreLocation.h"
#import "HXSAddressModel.h"
#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSBuildingArea.h"
#import "HXSUsageManager.h"

@interface HXSBuildingAreaSelectVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray       *buildingAreaArray;

@property (nonatomic, strong) HXSAddressModel *buildingModel;
@property (nonatomic, strong) UIView *buildingAreaNoDataFooterView;

@end

@implementation HXSBuildingAreaSelectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialPrama];
    [self initialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.buildingAreaArray = nil;
}


#pragma mark - webservice

- (void)fetchBuildingGroup
{
    
    __weak typeof(self) weakSelf = self;
    [self.buildingModel fetchAllBuilding:self.site.site_id WithComplete:^(HXSErrorCode code, NSString *message, NSArray *zoneList){
        [weakSelf.tableView endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if (kHXSNoError != code) {
            if (weakSelf.isFirstLoading) {
                [HXSLoadingView showLoadFailInView:weakSelf.view
                                             block:^{
                                                 [HXSLoadingView closeInView:weakSelf.view];
                                                 [weakSelf updateAddressList];
                                             }];
            } else {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
            return ;
        }
        
        weakSelf.firstLoading = NO;
        [weakSelf.buildingAreaArray removeAllObjects];
        [weakSelf.buildingAreaArray addObjectsFromArray:zoneList];
        
        if(weakSelf.buildingAreaArray.count <= 0){
            [weakSelf.tableView setTableFooterView:weakSelf.buildingAreaNoDataFooterView];
        }else{
            [weakSelf.tableView setTableFooterView:nil];
        }
        
        [weakSelf.tableView reloadData];
    }];

}

- (void)updateAddressList{
    [MBProgressHUD showInView:self.view];
    [self fetchBuildingGroup];
}


#pragma mark - UITableViewDelegate/UITableDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.buildingAreaArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"buildingAreaCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buildingAreaCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel * textLabel = cell.textLabel;
    textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    textLabel.font = [UIFont systemFontOfSize:15.0];
    
    HXSBuildingArea *temp = [self.buildingAreaArray objectAtIndex:indexPath.row];
    textLabel.text = temp.name;
    
    if(self.selectedBuildingArea&&[self.selectedBuildingArea.name isEqualToString:temp.name]){
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
        
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [HXSUsageManager trackEvent:HXS_ADDRESS_SELECT_BUILDING_GROUP parameter:nil];
    
    HXSBuildingArea * buildingArea = [self.buildingAreaArray objectAtIndex:indexPath.row];
    _selectedBuildingArea = buildingArea;
    [tableView reloadData];
    
    // 为了防止楼区内buildingsArr为空
    if(buildingArea.buildingsArr == nil) {
        buildingArea.buildingsArr = @[];
    }
    
    if ([_delegate respondsToSelector:@selector(addressSelectBuildArea:)]) {
        [_delegate addressSelectBuildArea:buildingArea];
    }
}


#pragma mark - initial

- (void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf fetchBuildingGroup];
    }];
}

- (void)initialPrama
{
    self.buildingAreaArray = [NSMutableArray array];
}


#pragma mark - Getter/Setter

- (void)setSite:(HXSSite *)site
{
    _site = site;
    if(_site && _site.site_id.intValue > 0)
        [self fetchBuildingGroup];
}

- (HXSAddressModel *)buildingModel
{
    if (nil == _buildingModel) {
        _buildingModel = [[HXSAddressModel alloc] init];
    }
    
    return _buildingModel;
}

- (void)setSelectedBuildingArea:(HXSBuildingArea *)selectedBuildingArea
{
    _selectedBuildingArea = selectedBuildingArea;
    [self.tableView reloadData];
}

- (UIView *)buildingAreaNoDataFooterView
{
    if(!_buildingAreaNoDataFooterView) {
        _buildingAreaNoDataFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 265)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 75, 180,140)];
        [imageView setImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
        [_buildingAreaNoDataFooterView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 21)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"您选择的学校暂无数据";
        lable.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        [lable setFont:[UIFont systemFontOfSize:14]];
        [_buildingAreaNoDataFooterView addSubview:lable];
    }
    return _buildingAreaNoDataFooterView;
}


@end
