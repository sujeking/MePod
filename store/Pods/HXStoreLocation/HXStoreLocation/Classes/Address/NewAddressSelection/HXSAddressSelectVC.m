//
//  HXSAddressSelectVC.m
//  Pods
//
//  Created by 格格 on 16/7/15.
//
//

#import "HXSAddressSelectVC.h"

// Controllers
#import "HXSAddressSelectionControl.h"

// Views
#import "HXSAddressDecorationView.h"

// Others
#import "HXStoreLocation.h"
#import "HXSSiteInfoRequest.h"
#import "HXSSiteListRequest.h"

@interface HXSAddressSelectVC ()<HXSAddressSelectionDelegate,
                                 UITableViewDelegate,
                                 UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *searchBarTopLayoutConstraint;

@property (nonatomic, strong) HXSAddressSelectionControl *selectionController;
@property (nonatomic, strong) NSMutableArray     *selectionControllerTitles;

@property (nonatomic, strong) HXSAddressDecorationView *addressSelectView;

@property (nonatomic, strong) NSMutableArray * zones;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) HXSSiteListRequest * searchRequest;
@property (nonatomic, strong) NSMutableArray * sites;
@property (nonatomic, strong) HXSSiteInfoRequest * siteInfoRequest;
@property (nonatomic, assign) BOOL searchDisplayControllerActive;
@property (nonatomic, readonly) HXSLocationPosition currentPosition;
@property (nonatomic, readonly) HXSAddressSelectionType addressSelectionDestination;

@property (nonatomic, strong) NSString *searchBarTextStr;
@property (nonatomic, strong) UIView *searchNoDataFooterView;

@end

@implementation HXSAddressSelectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialNav];
    [self initialSearchBar];
    [self initialTableView];
    self.searchDisplayControllerActive = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.searchDisplayController.isActive) {
        return UIStatusBarStyleDefault;
    }
    
    return UIStatusBarStyleLightContent;
}

+ (id)controllerFromXib
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXSStoreLocation" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:bundle];
}


#pragma mark - HXSAddressSelectionDelegate

- (void)addressSelectCity:(HXSCity *)city
{
        self.city = city;
        self.site = nil;
        self.buildingArea = nil;
        self.building = nil;
        
        [self updateSelectionControllerTitle];
        [self refreshAddressSelectionViewInfo];
        
        if ([HXSLocationManager manager].destination <= PositionCity) {
            
            [[HXSLocationManager manager] setCurrentCity:_city];
            [[HXSLocationManager manager] setCurrentSite:nil];
            [[HXSLocationManager manager] setCurrentBuildingArea:nil];
            [[HXSLocationManager manager] setBuildingEntry:nil];
            
            self.selectionController.selectedIdx = HXSAddressSelectionCity;
            self.selectionController.availableIdx = HXSAddressSelectionCity;
            
            [self dismissViewControllerAnimated:YES completion:^{
                if([HXSLocationManager manager].completion) {
                    [HXSLocationManager manager].completion();
                    
                    [HXSLocationManager manager].completion = nil;
                    [HXSLocationManager manager].destination = PositionNone;
                }
            }];
        } else {
            self.addressSelectView.selectionDestination = HXSAddressSelectionSite;
            self.selectionController.selectedIdx = HXSAddressSelectionSite;
            self.selectionController.availableIdx = HXSAddressSelectionSite;
            [self.addressSelectView showAddressSelectionType:HXSAddressSelectionSite];
        }
}

- (void)addressSelectSite:(HXSSite*)site
{
    
    if([site.cityId isEqualToNumber:self.city.city_id]) {
        self.site = site;
        self.buildingArea = nil;
        self.building = nil;
        
        [self updateSelectionControllerTitle];
        [self refreshAddressSelectionViewInfo];
        
        if ([HXSLocationManager manager].destination <= PositionSite) {
            
            [[HXSLocationManager manager] setCurrentCity:_city];
            [[HXSLocationManager manager] setCurrentSite:site];
            [[HXSLocationManager manager] setCurrentBuildingArea:nil];
            [[HXSLocationManager manager] setBuildingEntry:nil];
            
            self.selectionController.selectedIdx = HXSAddressSelectionSite;
            self.selectionController.availableIdx = HXSAddressSelectionSite;
            
            [self dismissViewControllerAnimated:YES completion:^{
                if([HXSLocationManager manager].completion) {
                    [HXSLocationManager manager].completion();
                    
                    [HXSLocationManager manager].completion = nil;
                    [HXSLocationManager manager].destination = PositionNone;
                }
            }];
        } else {
            self.addressSelectView.selectionDestination = HXSAddressSelectionBuildingArea;
            self.selectionController.selectedIdx = HXSAddressSelectionBuildingArea;
            self.selectionController.availableIdx = HXSAddressSelectionBuildingArea;
            [self.addressSelectView showAddressSelectionType:HXSAddressSelectionBuildingArea];
        }
    } else {
        [self fetCityDetialInfoOfSite:site];
    }
    
}

- (void) addressSelectBuildArea:(HXSBuildingArea *)buildingArea
{
        self.buildingArea = buildingArea;
        self.building = nil;
        
        [self updateSelectionControllerTitle];
        [self refreshAddressSelectionViewInfo];
        
        if ([HXSLocationManager manager].destination <= PositionBuildingArea) {
            
            [[HXSLocationManager manager] setCurrentCity:_city];
            [[HXSLocationManager manager] setCurrentSite:_site];
            [[HXSLocationManager manager] setCurrentBuildingArea:buildingArea];
            [[HXSLocationManager manager] setBuildingEntry:nil];
            
            self.selectionController.selectedIdx = HXSAddressSelectionBuildingArea;
            self.selectionController.availableIdx = HXSAddressSelectionBuildingArea;

            [self dismissViewControllerAnimated:YES completion:^{
                if([HXSLocationManager manager].completion) {
                    [HXSLocationManager manager].completion();
                    
                    [HXSLocationManager manager].completion = nil;
                    [HXSLocationManager manager].destination = PositionNone;
                }
            }];
        } else {
            self.addressSelectView.selectionDestination = HXSAddressSelectionBuilding;
            self.selectionController.selectedIdx = HXSAddressSelectionBuilding;
            self.selectionController.availableIdx = HXSAddressSelectionBuilding;
            [self.addressSelectView showAddressSelectionType:HXSAddressSelectionBuilding];
            
        }
}

- (void)addressSelectBuilding:(HXSBuildingEntry *)building
{
    self.building = building;
    
    [self updateSelectionControllerTitle];
    [self refreshAddressSelectionViewInfo];
    
    if ([HXSLocationManager manager].destination <= PositionBuilding) {
        
        [[HXSLocationManager manager] setCurrentCity:_city];
        [[HXSLocationManager manager] setCurrentSite:_site];
        [[HXSLocationManager manager] setCurrentBuildingArea:_buildingArea];
        [[HXSLocationManager manager] setBuildingEntry:building];
        
        self.selectionController.availableIdx = HXSAddressSelectionBuilding;
        self.selectionController.selectedIdx = HXSAddressSelectionBuilding;
        
        [self dismissViewControllerAnimated:YES completion:^{
            if([HXSLocationManager manager].completion) {
                [HXSLocationManager manager].completion();
                
                [HXSLocationManager manager].completion = nil;
                [HXSLocationManager manager].destination = PositionNone;
            }
        }];
    } else {
        self.addressSelectView.selectionDestination = HXSAddressSelectionBuilding;
        self.selectionController.selectedIdx = HXSAddressSelectionBuilding;
        self.selectionController.availableIdx = HXSAddressSelectionBuilding;
    }
}

- (void)addressDecorationViewCurrentSelectionChange:(HXSAddressSelectionType)selectionType
{
    self.selectionController.selectedIdx = selectionType;
}


#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        if (self.searchDisplayController.searchBar.text.length > 0) {
            if([self.sites count] <= 0)
                return 1;
            return [self.sites count];
        }
        return [[ApplicationSettings instance] addressSearchHistoryList].count;
        
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.searchBar.text.length > 0) {
        if([self.sites count] <= 0)
            return 0.1;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.1;
    } else {
        return 44;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return self.selectionController;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.1;
    } else {
        return [UIScreen mainScreen].bounds.size.height - 64 - 44;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return self.addressSelectView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell ;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        
        if (self.searchDisplayController.searchBar.text.length > 0) {
            if([self.sites count] <= 0){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clearCell"];
                return cell;
            }
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"HXSSiteSearchResultCell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        if (self.searchDisplayController.searchBar.text.length > 0) {
            // Search Result
            cell.textLabel.textColor = [UIColor colorWithRGBHex:0x666666];
            
            HXSSite * site = [self.sites objectAtIndex:indexPath.row];
            cell.textLabel.text = site.name;
            cell.imageView.image = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        } else {
            // Search History
            NSArray *searchHistoryList = [[ApplicationSettings instance] addressSearchHistoryList];
            
            cell.textLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            cell.textLabel.text = searchHistoryList[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"ic_schedule"];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = HXS_VIEWCONTROLLER_BG_COLOR;
            cell.contentView.backgroundColor = HXS_VIEWCONTROLLER_BG_COLOR;
        }
        return cell;
        
    } else {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // 从搜索结果中选择
        if (self.searchDisplayController.searchBar.text.length > 0){
            
            if([self.sites count] <= 0) {
                return;
            }
            
            self.searchBarTextStr = self.searchDisplayController.searchBar.text;
            
            HXSSite * site = nil;
            if (self.sites.count < indexPath.row) {
                return;
            }
            
            site = [self.sites objectAtIndex:indexPath.row];
            [HXSUsageManager trackEvent:HXS_CHOOSE_SCHOOL_SEARCHED parameter:nil];
            [self searchSchool:site];
        } else {
            NSArray *searchHistoryList = [[ApplicationSettings instance] addressSearchHistoryList];
            if (searchHistoryList.count < indexPath.row) {
                return;
            }
            self.searchDisplayController.searchBar.text = searchHistoryList[indexPath.row];
            [self search];
        }
    }
}


#pragma mark - Search School

- (void)search {
    if(self.loading) {
        [self.searchRequest cancel];
    }
    
    self.loading = YES;
    
    if(!self.sites) {
        self.sites = [NSMutableArray array];
    }
    
    if(self.searchDisplayController.searchBar.text.length == 0) {
        [self.sites removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    
    self.searchRequest = [[HXSSiteListRequest alloc] init];
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.searchRequest searchSiteListWithToken:tokenStr keywords:self.searchDisplayController.searchBar.text complete:^(HXSErrorCode code, NSString *message, NSArray *array) {
        self.loading = NO;
        
        if(code == kHXSNoError) {
            [self.sites removeAllObjects];
            if(array && array.count > 0) {
                for(id object in array) {
                    if([object isKindOfClass:[HXSSite class]]) {
                        [self.sites addObject:object];
                    }
                }
            }
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        } else {
            [self.sites removeAllObjects];
            
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        
        if(self.searchDisplayController.searchBar.text.length > 0 && self.sites.count <= 0) {
            [self.searchDisplayController.searchResultsTableView setTableFooterView:self.searchNoDataFooterView];
        } else {
            [self.searchDisplayController.searchResultsTableView setTableFooterView:nil];
        }
        
    }];
}

- (void)searchSchool:(HXSSite *)site
{
    self.searchDisplayControllerActive = NO;
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.siteInfoRequest seletSite:site.site_id withToken:tokenStr complete:^(HXSErrorCode code, NSString *message, HXSSite *site) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if(code == kHXSNoError && site != nil) {
            [weakSelf fetCityDetialInfoOfSite:site];
        } else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
        }
    }];
    [[ApplicationSettings instance] addAddressSearchHistory:[self.searchBarTextStr trim]];
}

- (void)fetCityDetialInfoOfSite:(HXSSite *)site
{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [self.siteInfoRequest fetchCityDetialInfoOfSite:site.site_id complete:^(HXSErrorCode code, NSString *message, HXSCity *city) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if(kHXSNoError == code){
            [weakSelf finishFetchCityInfo:city ofSite:site];
        } else {
            HXSCustomAlertView *alertView = [[HXSCustomAlertView alloc] initWithTitle:@"提示"
                                                                              message:message
                                                                      leftButtonTitle:@"确定"
                                                                    rightButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)finishFetchCityInfo:(HXSCity *)city ofSite:(HXSSite *)site
{
    /*
     刷新城市列表 
     选择只到城市？ 是：返回 否：刷新学校
     选择知道学校？ 是：返回 否：到选择楼区
     */
    // 1.刷新城市
    self.city = city;
    [[HXSLocationManager manager] setCurrentCity:city];
    // 2. 选择只到城市？
    if([HXSLocationManager manager].destination <= PositionCity) {
        // 2.1 只选择到城市
        self.site = nil;
        self.buildingArea = nil;
        self.building = nil;
        
        [[HXSLocationManager manager] setCurrentSite:nil];
        [[HXSLocationManager manager] setCurrentBuildingArea:nil];
        [[HXSLocationManager manager] setBuildingEntry:nil];
        
        [self updateSelectionControllerTitle];
        [self refreshAddressSelectionViewInfo];
        
        self.selectionController.selectedIdx = HXSAddressSelectionCity;
        self.selectionController.availableIdx = HXSAddressSelectionCity;
        
        [self dismissViewControllerAnimated:YES completion:^{
            if([HXSLocationManager manager].completion) {
                [HXSLocationManager manager].completion();
                
                [HXSLocationManager manager].completion = nil;
                [HXSLocationManager manager].destination = PositionNone;
            }
        }];
    
    } else { // 2.2
        // 刷新学校信息
        self.site = site;
        self.buildingArea = nil;
        self.building = nil;
        
        [self updateSelectionControllerTitle];
        [self refreshAddressSelectionViewInfo];
        
        // 2.3 选择只到学校？
        if ([HXSLocationManager manager].destination <= PositionSite) {
            // 2.3.1 选择只到学校
            
            [[HXSLocationManager manager] setCurrentSite:site];
            [[HXSLocationManager manager] setCurrentBuildingArea:nil];
            [[HXSLocationManager manager] setBuildingEntry:nil];
            
            self.selectionController.selectedIdx = HXSAddressSelectionSite;
            self.selectionController.availableIdx = HXSAddressSelectionSite;
            
            [self dismissViewControllerAnimated:YES completion:^{
                if([HXSLocationManager manager].completion) {
                    [HXSLocationManager manager].completion();
                    
                    [HXSLocationManager manager].completion = nil;
                    [HXSLocationManager manager].destination = PositionNone;
                }
            }];
            
        } else {
            // 2.3.2 选择到学校以上
            self.addressSelectView.selectionDestination = HXSAddressSelectionBuildingArea;
            self.selectionController.selectedIdx = HXSAddressSelectionBuildingArea;
            self.selectionController.availableIdx = HXSAddressSelectionBuildingArea;
            [self.addressSelectView showAddressSelectionType:HXSAddressSelectionBuildingArea];
        }
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchDisplayControllerActive = NO;
}


#pragma mark - UISearchDisplayDelegate

-(void)bringSearchResultToFront
{
    if (self.searchDisplayController.active == YES) {
        UITableView *table = self.searchDisplayController.searchResultsTableView;
        table.alpha = 1.0;
        table.hidden = NO;
        
        UIView *superView = table.superview;
        [superView bringSubviewToFront:table];
        [table reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self search];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self search];
    return YES;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    [self bringSearchResultToFront];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self bringSearchResultToFront];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    [self bringSearchResultToFront];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    for (UIView *subView in controller.searchResultsTableView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UILabel")]) {
            UILabel *label =(UILabel *)subView;
            label.text = @"";
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}


#pragma mark - Target/Action

- (void)searchButtonClicked{
    [HXSUsageManager trackEvent:HXS_SEARCH_SCHOOL parameter:nil];
    self.searchDisplayControllerActive = YES;
}

- (void)selectItemAction:(HXSAddressSelectionControl *)sender
{
    [self.addressSelectView showAddressSelectionType:sender.selectedIdx];
}


#pragma mark - private methods

- (void)updateSelectionControllerTitle
{
    self.selectionController.titles = self.selectionControllerTitles;
}

- (void)refreshAddressSelectionViewInfo
{
    self.addressSelectView.city = self.city;
    self.addressSelectView.site = self.site;
    self.addressSelectView.buildingArea = self.buildingArea;
    self.addressSelectView.building = self.building;
}

- (HXSAddressSelectionType)addressSelectionTypeForPosition:(HXSLocationPosition) position
{
    switch (position) {
        case PositionNone:              return HXSAddressSelectionCity;
        case PositionCity:              return HXSAddressSelectionSite;
        case PositionSite:              return HXSAddressSelectionBuildingArea;
        case PositionBuildingArea:      return HXSAddressSelectionBuilding;
            break;
        default:
            break;
    }
    
    return HXSAddressSelectionSite;
}


#pragma mark - initial

- (void)initialNav
{
    self.navigationItem.title = @"选择地址";
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClicked)];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]forState:UIControlStateNormal];
}

- (void)initialTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

- (void)initialSearchBar
{
    UIColor *barColor = [UIColor colorWithRGBHex:0x08A9FA];
    self.navigationController.navigationBar.barTintColor = barColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:barColor] forBarMetrics:UIBarMetricsDefault];
    
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HXSSiteSearchResultCell"];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:HXS_VIEWCONTROLLER_BG_COLOR];
    
    [self.searchDisplayController.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGBHex:0xE1E2E3]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.searchDisplayController.searchBar.placeholder = @"搜索学校";
    UITextField*searchField = [self.searchDisplayController.searchBar valueForKey:@"_searchField"];
    [searchField setValue:[UIColor colorWithRGBHex:0xD2D2D2] forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - getter

- (HXSLocationPosition)currentPosition
{
    if(_city == nil || _city.city_id.intValue < 1) {
        return PositionNone;
    } else if(_site == nil || _site.site_id.intValue < 1) {
        return PositionCity;
    } else if (_buildingArea == nil || _buildingArea.name.length < 1) {
        return PositionSite;
    } else if(_building == nil || _building.nameStr.length < 1){
        return PositionBuildingArea;
    }
    return PositionBuilding;
}

- (HXSAddressSelectionType)addressSelectionDestination
{
    switch ([HXSLocationManager manager].destination) {
        case PositionNone:
            return HXSAddressSelectionBuilding;
            break;
        case PositionCity:
            return HXSAddressSelectionCity;
            break;
        case PositionSite:
            return HXSAddressSelectionSite;
            break;
        case PositionBuildingArea:
            return HXSAddressSelectionBuildingArea;
            break;
        case PositionBuilding:
            return HXSAddressSelectionBuilding;
            break;
        default:
            return HXSAddressSelectionBuilding;
            break;
    }
}

- (HXSAddressSelectionControl *)selectionController
{
    if(!_selectionController) {
        _selectionController = [[HXSAddressSelectionControl alloc]init];
        _selectionController.titles = self.selectionControllerTitles;
         [_selectionController addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventValueChanged];
        
        if ([HXSLocationManager manager].destination <= self.currentPosition) {
            _selectionController.availableIdx = [HXSLocationManager manager].destination - 1;
            _selectionController.selectedIdx = [HXSLocationManager manager].destination - 1;
        } else {
            _selectionController.availableIdx = self.currentPosition;
            _selectionController.selectedIdx = self.currentPosition;
        }
    }
    return _selectionController;
}

- (NSMutableArray *)selectionControllerTitles
{
        switch ([HXSLocationManager manager].destination) {
            case PositionNone:
            {
                _selectionControllerTitles = [NSMutableArray array];
            }
                break;
            case PositionCity:
            {
                NSString *cityStr = (_city == nil || _city.city_id.intValue < 1)? @"城市" : _city.name;
                _selectionControllerTitles = [NSMutableArray arrayWithObjects:cityStr,nil];
            }
                break;
            case PositionSite:
            {
                NSString *cityStr = (_city == nil || _city.city_id.intValue < 1)? @"城市" : _city.name;
                NSString *siteStr = (_site == nil || _site.site_id.intValue < 1)? @"学校" : _site.name;
                _selectionControllerTitles = [NSMutableArray arrayWithObjects:cityStr,siteStr,nil];
            }
                break;
            case PositionBuildingArea:
            {
                NSString *cityStr = (_city == nil || _city.city_id.intValue < 1)? @"城市" : _city.name;
                NSString *siteStr = (_site == nil || _site.site_id.intValue < 1)? @"学校" : _site.name;
                NSString *buildingAreaStr = (_buildingArea == nil)? @"楼区" : _buildingArea.name;
                _selectionControllerTitles = [NSMutableArray arrayWithObjects:cityStr,siteStr,buildingAreaStr,nil];
            }
                break;
            case PositionBuilding:
            {
                NSString *cityStr = (_city == nil || _city.city_id.intValue < 1)? @"城市" : _city.name;
                NSString *siteStr = (_site == nil || _site.site_id.intValue < 1)? @"学校" : _site.name;
                NSString *buildingAreaStr = (_buildingArea == nil)? @"楼区" : _buildingArea.name;
                NSString *buildStr = (_building == nil || _building.dormentryIDNum.intValue < 1)? @"楼号" : _building.buildingNameStr;
                _selectionControllerTitles = [NSMutableArray arrayWithObjects:cityStr,siteStr,buildingAreaStr,buildStr,nil];
            }
                break;
            default:
                _selectionControllerTitles = [NSMutableArray array];
                break;
        }
    
    if([HXSLocationManager manager].destination > self.currentPosition) {
        NSString *str = @"请选择";
        [_selectionControllerTitles replaceObjectAtIndex:self.currentPosition withObject:str];
    }
    return _selectionControllerTitles;
}

- (HXSAddressDecorationView *)addressSelectView
{
    if(!_addressSelectView) {
        _addressSelectView = [[HXSAddressDecorationView alloc] initWithDelegate:self containerController:self];
        _addressSelectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 108);
        _addressSelectView.city = self.city;
        _addressSelectView.site = self.site;
        _addressSelectView.buildingArea = self.buildingArea;
        _addressSelectView.building = self.building;
        
        if ([HXSLocationManager manager].destination <= self.currentPosition) {
            _addressSelectView.selectionDestination = [HXSLocationManager manager].destination - 1;
            [_addressSelectView showAddressSelectionType:[HXSLocationManager manager].destination - 1];
        } else {
            _addressSelectView.selectionDestination = [self addressSelectionTypeForPosition:self.currentPosition];
            [_addressSelectView showAddressSelectionType:self.currentPosition];
        }
    }
    return _addressSelectView;
}

- (HXSSiteInfoRequest *)siteInfoRequest
{
    if(!_siteInfoRequest) {
        _siteInfoRequest = [[HXSSiteInfoRequest alloc]init];
    }
    return _siteInfoRequest;
}

- (UIView *)searchNoDataFooterView
{
    if(!_searchNoDataFooterView) {
        _searchNoDataFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 265)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 180)/2, 75, 180,140)];
        [imageView setImage:[UIImage imageNamed:@"img_kong_wodehuifu"]];
        [_searchNoDataFooterView addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 234, SCREEN_WIDTH, 21)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = @"您搜索的地址暂时找不到哦";
        lable.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        [lable setFont:[UIFont systemFontOfSize:14]];
        [_searchNoDataFooterView addSubview:lable];
    }
    return _searchNoDataFooterView;
}


#pragma mark - setter

- (void)setSearchDisplayControllerActive:(BOOL)searchDisplayControllerActive
{
    _searchDisplayControllerActive = searchDisplayControllerActive;
    if(_searchDisplayControllerActive) { // 展示
        self.searchBarTopLayoutConstraint.constant = 0;
        [self.view setNeedsLayout];
        [self.searchDisplayController setActive:YES animated:YES];
        [self.searchDisplayController.searchResultsTableView setTableFooterView:nil];
    } else {
        self.searchBarTopLayoutConstraint.constant = -44;
        [self.view setNeedsLayout];
        [self.searchDisplayController setActive:NO animated:YES];
        [self.searchDisplayController.searchResultsTableView setTableFooterView:nil];
    }
}

- (void)setCity:(HXSCity *)city
{
    if (city != _city) {
        if(city == nil || _city == nil || ![_city.city_id isEqual:city.city_id]) {
            _site     = nil;
        }
        
        _city = city;
    }
}

- (void)setSite:(HXSSite *)site
{
    if (site != _site) {
        if(site == nil || _site == nil || ![_site.site_id isEqual:site.site_id]) {
            _building   = nil;
        }
        
        _site = site;
    }
}

- (void)setBuildingArea:(HXSBuildingArea *)buildingArea{
    if (buildingArea != _buildingArea) {
        if(_buildingArea == nil ) {
            _buildingArea   = nil;
        }
        _buildingArea = buildingArea;
    }
    _buildingArea = buildingArea;
}


- (void)setBuilding:(HXSBuildingEntry *)building
{
    if (building != _building) {
        _building = building;
    }
}



@end
