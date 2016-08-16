//
//  HXSSelectCityViewController.m
//  store
//
//  Created by ranliang on 15/5/11.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSSelectCityViewController.h"

// Controllers
#import "HXSSiteSelectViewController.h"
#import "HXSSiteSelectViewController.h"

// Model
#import "HXSCity.h"
#import "HXSSite.h"

// Views
#import "HXSLoadingView.h"
#import "UIRenderingButton.h"

// Others
#import "HXSSiteListRequest.h"
#import "HXSGPSLocationManager.h"
#import "HXStoreLocation.h"
#import "HXSUsageManager.h"


#define HXS_ADDRESS_SELECT_CITY @"address_select_city"

#define kBorderAndSeparatorColor ([UIColor colorWithR:242 G:236 B:231 A:1.0])
#define kLocationRedColor 0xF54945

static const CGFloat kButtonsLeftSpace         = 15.0;
static const CGFloat kButtonsRightSpace        = 30.0;
static const CGFloat kButtonsHorizontalSpacing = 10.0;
static const CGFloat kButtonsVerticalSpacing   = 10.0;
static const NSInteger kCityButtonStartTag     = 2000;

@interface HXSSelectCityViewController ()<UITableViewDelegate,
                                          UITableViewDataSource,
                                          UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;//显示所有城市

@property (nonatomic, strong) NSMutableArray * postionCities;//定位的城市
@property (nonatomic, strong) NSMutableArray *plainCitiesArray;//不包含热门城市和定位城市的所有城市无序数组
//所有城市,第一个section是定位城市，第二个section是热门城市，第三个section开始是首字母相同的城市在一个子数组，子数组已经按照字母顺序排序
@property (nonatomic, strong) NSMutableArray *citiesArray;

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) HXSSiteListRequest *request;//请求所有城市和推荐城市列表

@property (nonatomic, strong) NSMutableArray *sectionIndexTitles;

@property (nonatomic, assign) CGFloat locationButtonHeight;

@property (nonatomic, assign) BOOL displayStatusBarLightContent;

@property (nonatomic, assign) BOOL positionFailed;

@end

@implementation HXSSelectCityViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.loading = NO;
        self.displayStatusBarLightContent = YES;
    }
    
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.loading = NO;
        self.displayStatusBarLightContent = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.plainCitiesArray = [NSMutableArray array];
    self.citiesArray = [NSMutableArray array];
    self.sectionIndexTitles = [NSMutableArray array];
    self.postionCities = [NSMutableArray array];
    
    [[HXSGPSLocationManager instance] startPositioning];

    if([HXSGPSLocationManager instance].positioningCity) {
        [self.postionCities addObject:[HXSGPSLocationManager instance].positioningCity];
    }else {
        [self.postionCities addObject:[[HXSCity alloc] init]];
    }
    
    //配置tableView
    self.tableView.sectionIndexColor = [UIColor colorWithRGBHex:0x18A9FA];
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithRGBHex:0xF1F2F2];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    __weak typeof (self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf loadCities];
    }];
    
    //请求城市数据
    [self initializeCities];
    
    self.locationButtonHeight = (SCREEN_WIDTH - kButtonsLeftSpace - kButtonsRightSpace - 2 * kButtonsHorizontalSpacing) / 3.0 * 0.4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(positionCityChanged) name:kPositioningCityChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(positionCityFailed) name:kPositionCityFailed object:nil];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositioningCityChanged object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPositionCityFailed object:nil];
    
    [self.postionCities removeAllObjects];
    self.postionCities = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Notification
// 定位成功
- (void)positionCityChanged
{
    self.positionFailed = NO;
    if ([[HXSGPSLocationManager instance].positioningCity.city_id intValue]> 0) {
        [self.postionCities removeAllObjects];
        [self.postionCities addObject:[HXSGPSLocationManager instance].positioningCity];
        
        [self.tableView reloadData];
    }
}

// 定位失败
- (void)positionCityFailed
{
    self.positionFailed = YES;
    [self.tableView reloadData];
    
    if(!self.selectCity){
        HXSCustomAlertView *alert = [[HXSCustomAlertView alloc]initWithTitle:@"无法获取你的位置信息" message:@"请在iPhone的[设置]-[隐私]-[定位服务]中打开定位服务,并允许[59app]使用定位服务" leftButtonTitle:@"知道了" rightButtonTitles:nil];
        [alert show];
    }

}


#pragma mark - Override Methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.displayStatusBarLightContent) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}


#pragma mark - Initial Methods

- (void)initializeCities
{
    NSString * token = [[HXSMediator sharedInstance] HXSMediator_token];
    if(token) {
        if(!self.loading) {
            self.loading = YES;
            __weak typeof(self) weakSelf = self;
            self.request = [[HXSSiteListRequest alloc] init];
            
            [HXSLoadingView showLoadingInView:self.view];
            [self.request getCityListWithToken:token complete:^(HXSErrorCode code, NSString *message, NSArray *cities) {
                if(code == kHXSNoError && cities != nil) {
                    [self parseCities:cities];
                    [self.tableView reloadData];
                    [HXSLoadingView closeInView:self.view];
                } else {
                    [HXSLoadingView showLoadFailInView:self.view block:nil];
                    [HXSLoadingView closeInView:self.view after:1];
                }
                weakSelf.loading = NO;
            }];
        }
    } else {
        [[HXSMediator sharedInstance] HXSMediator_updateToken];
    }
}

- (void)parseCities:(NSArray *)cities
{
    NSArray * citiesArray = cities[1];
    NSArray * recommendedCitiesArray = cities[0];
    [self.sectionIndexTitles removeAllObjects];
    [self.sectionIndexTitles addObjectsFromArray:@[@"定位",@"热门"]];
    [self.citiesArray removeAllObjects];
    [self.citiesArray addObject:self.postionCities];//定位
    [self.citiesArray addObject:[NSMutableArray arrayWithArray:recommendedCitiesArray]];//热门
    [self.plainCitiesArray removeAllObjects];
    for(NSArray * array in citiesArray) {
        [self.plainCitiesArray addObjectsFromArray:array];
        HXSCity * city = array[0];
        [self.sectionIndexTitles addObject:city.sectionTitle];
        [self.citiesArray addObject:array];
    }
}

- (void)loadCities
{
    NSString * token = [[HXSMediator sharedInstance] HXSMediator_token];
    if(token) {
        if(!self.loading) {
            self.loading = YES;
            __weak typeof(self) weakSelf = self;
            self.request = [[HXSSiteListRequest alloc] init];
            [self.request getCityListWithToken:token complete:^(HXSErrorCode code, NSString *message, NSArray *cities) {
                [weakSelf.tableView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
                if(code == kHXSNoError && cities != nil) {
                    [self parseCities:cities];
                    [self.tableView reloadData];
                } else {
                    [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                       status:message
                                                   afterDelay:1.5f];
                }
                weakSelf.loading = NO;
            }];
        }
    } else {
        [[HXSMediator sharedInstance] HXSMediator_updateToken];
    }
}

- (void)tokenRefreshed
{
    [self loadCities];
}

- (UIView *)createPositioningView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.locationButtonHeight + 50)];
    headerView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_location"]];
    locationIcon.frame = CGRectMake(15, 14, 22, 22);
    [headerView addSubview:locationIcon];
    
    UILabel *locatedCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 100, 30)];
    locatedCityLabel.text = @"当前城市";
    locatedCityLabel.textColor = UIColorFromRGB(0x999999);
    locatedCityLabel.font = [UIFont systemFontOfSize:15.0];
    [headerView addSubview:locatedCityLabel];
    
    NSString *tip =  [self.postionCities[0] name].length > 0 ? [self.postionCities[0] name] : @"定位中...";
    
    NSString * cityName = self.positionFailed ? @"定位失败" : tip;
    
    UIRenderingButton *locatedCityButton = [self createLocationButtonWithCityName:cityName origin:CGPointMake(15, 47)];
    if(self.positionFailed) {
        [locatedCityButton setTitleColor:[UIColor colorWithRGBHex:kLocationRedColor] forState:UIControlStateNormal];
        locatedCityButton.highlightedBorderColor = [UIColor colorWithRGBHex:kLocationRedColor];
        locatedCityButton.highlightedTitleColor = [UIColor colorWithRGBHex:kLocationRedColor];
    }
    [headerView addSubview:locatedCityButton];
   
    [locatedCityButton addTarget:self action:@selector(findLocation:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

- (UIView *)createHotCitiesView
{
    CGFloat buttonWidth = (SCREEN_WIDTH - kButtonsLeftSpace - kButtonsRightSpace - 2 * kButtonsHorizontalSpacing) / 3.0;
    CGFloat buttonHeight = buttonWidth * 0.4;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];//[UIColor colorWithR:252 G:252 B:246 A:1.0];
    
    UILabel *frequentCitiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 30)];
    frequentCitiesLabel.text = @"热门城市";
    frequentCitiesLabel.textColor = UIColorFromRGB(0x999999);;//UIColorFromRGB(0xc59b6d);
    frequentCitiesLabel.font = [UIFont systemFontOfSize:15.0];
    [headerView addSubview:frequentCitiesLabel];
    
    NSArray * recommendedCitiesArray = self.citiesArray[1];
    for (int i = 0; i < recommendedCitiesArray.count; i++) {
        CGFloat x = i % 3 * (kButtonsHorizontalSpacing + buttonWidth) + kButtonsLeftSpace;
        CGFloat y = i / 3 * (kButtonsVerticalSpacing + buttonHeight) + CGRectGetMaxY(frequentCitiesLabel.frame) + 5;
        HXSCity *city = recommendedCitiesArray[i];
        UIRenderingButton *button = [self createLocationButtonWithCityName:city.name origin:CGPointMake(x, y)];
        button.tag = i + kCityButtonStartTag;
        
        if(self.selectCity&&[self.selectCity.city_id isEqualToNumber:city.city_id])
            button.highlighted = YES;
        
        [headerView addSubview:button];
        
        [button addTarget:self action:@selector(cityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (([self.citiesArray[1] count] - 1)/3 + 1) * self.locationButtonHeight + 45 + kButtonsVerticalSpacing * ([self.citiesArray[1] count] - 1) / 3);
    return headerView;
}

- (void)cityButtonClicked:(UIButton *)button
{
    self.view.superview.userInteractionEnabled = NO;
    [self performSelector:@selector(tablewEnable) withObject:self afterDelay:0.5];
    
    NSArray * recommendedCitiesArray = self.citiesArray[1];
    NSInteger index = button.tag - kCityButtonStartTag;
    HXSCity *city = recommendedCitiesArray[index];
    // 选择热门城市埋点
    [HXSUsageManager trackEvent:HXS_CHOOSE_HOT_CITY parameter:nil];
    [self selectCity:city];
}

- (UIButton *)createLocationButtonWithCityName:(NSString *)cityName origin:(CGPoint)origin
{
    CGFloat buttonWidth = (SCREEN_WIDTH - kButtonsLeftSpace - kButtonsRightSpace - 2 * kButtonsHorizontalSpacing) / 3.0;
    CGFloat buttonHeight = buttonWidth * 0.4;
    
    UIRenderingButton *cityButton = [UIRenderingButton buttonWithType:UIButtonTypeCustom];
    cityButton.frame = CGRectMake(origin.x, origin.y, buttonWidth, buttonHeight);
    [cityButton setBackgroundColor:[UIColor whiteColor]];
    [cityButton setTitle:cityName forState:UIControlStateNormal];
    [cityButton setTitleColor:[UIColor colorWithRGBHex:0x5B5857] forState:UIControlStateNormal];
    cityButton.borderColor = [UIColor colorWithRGBHex:0xD3D4D4];
    cityButton.highlightedBorderColor = HXS_COLOR_MASTER;
    cityButton.highlightedTitleColor = HXS_COLOR_MASTER;
    cityButton.borderWidth = 0.5;
    cityButton.cornerRadius = 4.0;
    cityButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    return cityButton;
}

- (void)selectCity:(HXSCity *)city
{
    // 选择列表城市埋点
    [HXSUsageManager trackEvent:HXS_CHOOSE_LIST_CITY parameter:nil];
    
    self.selectCity = city;
    if ([_delegate respondsToSelector:@selector(addressSelectCity:)]) {
        [_delegate addressSelectCity:city];
    }
}

- (void)tablewEnable
{
    self.view.superview.userInteractionEnabled = YES;
}


#pragma mark - positioning

- (void)findLocation:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.layer.borderColor = [[UIColor redColor] CGColor];
    
    if(self.postionCities.count == 1 && [[self.postionCities[0] name] length] > 0) {
        //已经定位到一个城市
        [self selectCity:self.postionCities[0]];
        
        return;
    }
    
    [[HXSGPSLocationManager instance] startPositioning]; 
}


#pragma mark - Table View

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.citiesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return 1;
    } else {
        NSArray * cityArray = [self.citiesArray objectAtIndex:section];
        
        return cityArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(![self tableView:tableView titleForHeaderInSection:section]) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];// UIColorFromRGB(0xf6f6f6);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 20)];
    label.textColor = [UIColor colorWithRGBHex:0x999999];//UIColorFromRGB(0xc59b6d);
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView titleForHeaderInSection:section] ? 30:0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return nil;
    } else if(section == 1) {
        return nil;
    }
    BOOL showSection = [[self.citiesArray objectAtIndex:section] count] != 0;
    return (showSection) ? self.sectionIndexTitles[section] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        return self.locationButtonHeight + 50;
    } else if(indexPath.section == 1) {
        return (([self.citiesArray[1] count] - 1)/3 + 1) * self.locationButtonHeight + 40 + kButtonsVerticalSpacing * ([self.citiesArray[1] count] - 1) / 3;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cityCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    NSArray *arr = cell.contentView.subviews;
    for(UIView *view in arr){
        [view removeFromSuperview];
    }
    
    if(indexPath.section == 0) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell.contentView addSubview:[self createPositioningView]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //隐藏separator
        cell.separatorInset = UIEdgeInsetsMake(0.0, SCREEN_WIDTH, 0.0, 0.0);
        return cell;
    } else if(indexPath.section == 1) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        [cell.contentView addSubview:[self createHotCitiesView]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.0, SCREEN_WIDTH, 0.0, 0.0);
        return cell;
    } else {
        HXSCity *city = self.citiesArray[indexPath.section][indexPath.row];
        cell.textLabel.text = city.name;
        
        if(self.selectCity&&[self.selectCity.city_id isEqualToNumber:city.city_id]){
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
        
        } else {
            cell.accessoryView = nil;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        return;
    } else if(indexPath.section == 1) {
        return;
    } else {
        
        self.view.superview.userInteractionEnabled = NO;
        [self performSelector:@selector(tablewEnable) withObject:self afterDelay:0.5];
        
        HXSCity *city = self.citiesArray[indexPath.section][indexPath.row];
        [self selectCity:city];
    }

}


#pragma mark - 

- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector
{
    NSInteger sectionCount = [self.sectionIndexTitles count];
    NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //create an array to hold the data for each section
    for(int i = 0; i < sectionCount; i++) {
        [unsortedSections addObject:[NSMutableArray array]];
    }
    
    //put each object into a section
    for (id object in array) {
        NSInteger index = [self.sectionIndexTitles indexOfObject:[object sectionTitle]];
        [[unsortedSections objectAtIndex:index] addObject:object];
    }
    
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    
    //sort each section
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    for (NSMutableArray *section in unsortedSections) {
        [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
    }
    
    return sections;
}


#pragma mark - public method

- (void)reloadData
{
    [self.tableView reloadData];
}


#pragma - setter

- (void)setSelectCity:(HXSCity *)selectCity
{
    _selectCity = selectCity;
    [self.tableView reloadData];
}

@end
