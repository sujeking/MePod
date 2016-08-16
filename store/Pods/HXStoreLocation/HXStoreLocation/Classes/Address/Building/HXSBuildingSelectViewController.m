//
//  HXSBuildingSelectViewController.m
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSBuildingSelectViewController.h"

// Controllers
#import "HXSEntrySelectViewController.h"
#import "HXSSiteSelectViewController.h"

// Model
#import "HXSAddressModel.h"
#import "HXSBuildingArea.h"
#import "HXSBuildingEntity.h"

// Views
#import "HXSLoadingView.h"
#import "HXSAddressDecorationView.h"

// Others
#import "HXSLocationManager.h"
#import "UIColor+Extensions.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "MBProgressHUD+HXS.h"
#import "HXMacrosUtils.h"
#import "HXSUsageManager.h"
#import "ApplicationSettings.h"
#import "HXSMediator+HXWebviewModule.h"
#import "UIView+Extension.h"
#import "HXStoreLocation.h"


#define HEIGHT_CELL           50

@interface HXSBuildingSelectViewController () <UITableViewDataSource,
                                               UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic, strong) NSArray *rightTableViewDataSource;
@property (nonatomic, strong) HXSAddressModel *buildingModel;


@end

@implementation HXSBuildingSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.buildingModel            = nil;
    self.rightTableViewDataSource = nil;
    self.buildingArea             = nil;
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    self.rightTableView.backgroundColor = [UIColor whiteColor];
    self.rightTableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - Override Methods

- (void)tokenRefreshed
{

    [self.rightTableView reloadData];
}


#pragma mark - Setter Getter Methods

- (HXSAddressModel *)buildingModel
{
    if (nil == _buildingModel) {
        _buildingModel = [[HXSAddressModel alloc] init];
    }
    
    return _buildingModel;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.buildingArea.buildingsArr != nil)
        return self.buildingArea.buildingsArr.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"buildingCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"buildingCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    UILabel * textLabel = cell.textLabel;
    textLabel.textColor = [UIColor colorWithRGBHex:0x333333];
    textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSBuildingNameEntity *nameEntity = [self.buildingArea.buildingsArr objectAtIndex:indexPath.row];
    cell.textLabel.text = nameEntity.buildingNameStr;
    
    if(self.selectedBuilding &&[self.selectedBuilding.buildingNameStr isEqualToString:nameEntity.buildingNameStr]&&[self.selectedBuilding.dormentryIDNum isEqualToNumber:nameEntity.dormentryIDIntNum]) {
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
    } else {
        cell.accessoryView = nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [HXSUsageManager trackEvent:HXS_SELECT_BUDING_NUMBER parameter:nil];
    HXSBuildingNameEntity *entity = [self.buildingArea.buildingsArr objectAtIndex:indexPath.row];
    
    // save building values to user default
    HXSBuildingEntry *buildingEntry = [[HXSBuildingEntry alloc] init];
    buildingEntry.nameStr         = self.buildingArea.name;
    buildingEntry.buildingNameStr = entity.buildingNameStr;
    buildingEntry.dormentryIDNum  = entity.dormentryIDIntNum;
    buildingEntry.hasOpened       = (0 < [entity.shopsArr count]) ? YES : NO;
    
    self.selectedBuilding = buildingEntry;
    if ([_delegate respondsToSelector:@selector(addressSelectBuilding:)]) {
        [_delegate addressSelectBuilding:buildingEntry];
    }

}


#pragma mark - setter
- (void)setSelectedBuilding:(HXSBuildingEntry *)selectedBuilding
{
    _selectedBuilding = selectedBuilding;
    [self.rightTableView reloadData];
}


#pragma mark - public method
- (void)updateAddressList
{
    [self.rightTableView reloadData];
}

@end
