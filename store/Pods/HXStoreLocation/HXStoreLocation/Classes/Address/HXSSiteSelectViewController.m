//
//  HXSSiteSelectViewController.m
//  store
//
//  Created by chsasaw on 14/10/17.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSSiteSelectViewController.h"

// Controllers
#import "HXSBuildingSelectViewController.h"

// Model

// Views
#import "HXSLocationSearchBar.h"
#import "HXSSitePostioningHeaderView.h"
#import "HXSLoadingView.h"
#import "HXSEmptyTableBackgroundView.h"

// Others
#import "HXSSiteListRequest.h"
#import "HXSSiteInfoRequest.h"
#import "HXSGPSLocationManager.h"
#import "UIScrollView+HXSPullRefresh.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXSMediator+AccountModule.h"
#import "UIColor+Extensions.h"
#import "Masonry.h"
#import "MBProgressHUD+HXS.h"
#import "HXSUsageManager.h"
#import "HXStoreLocation.h"

#define kRedColor 0xF54945

@interface HXSSiteSelectViewController ()<UITableViewDataSource,
                                          UITableViewDelegate,
                                          HXSGPSLocationManagerDelegate,
                                          UIActionSheetDelegate> {
    HXSEmptyTableBackgroundView *_emptyTableBackgroundview;
}

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * zones;

@property (nonatomic, strong) HXSSiteListRequest * request;
@property (nonatomic, strong) HXSSiteListRequest * searchRequest;
@property (nonatomic, strong) HXSSiteListRequest * positionRequest;

@property (nonatomic, strong) HXSSiteInfoRequest * siteInfoRequest;

@property (nonatomic, strong) UILabel *positioningLabel;

@property (nonatomic) BOOL loading;
@property (nonatomic, assign) BOOL isPositioning;

@property (nonatomic, strong) NSMutableArray * sites;
@property (nonatomic, strong) NSMutableArray * positionSites;

@end

@implementation HXSSiteSelectViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.isPositioning = NO;
        self.loading = NO;
    }
    
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.isPositioning = NO;
        self.loading = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.zones = [NSMutableArray array];
    self.positionSites = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 17, 0, 0);
    self.tableView.sectionIndexColor = UIColorFromRGB(0xf6f6f6);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HXSSiteCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"tableheader"];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"HXStoreLocation" ofType:@"bundle"];
    if (bundlePath) {
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    NSArray *viewsArr = [bundle loadNibNamed:@"HXSSitePostioningHeaderView"
                                       owner:nil
                                     options:nil];

    [self findLocation:nil];
}


#pragma mark - positioning

- (void)findLocation:(id)sender
{
    if(self.positionSites.count >= 1) {
        
        return;
    }
    
    if(self.isPositioning) {
        return;
    }
    self.isPositioning = YES;
    
    [HXSGPSLocationManager instance].delegate = self;
    [[HXSGPSLocationManager instance] startPositioning];

    self.positioningLabel.hidden = YES;
}

- (void)tokenRefreshed
{
    [HXSLoadingView showLoadingInView:self.view];
    
    [self refresh];
}

- (void)loadZones:(NSArray *)array
{
    [self.zones removeAllObjects];
    [self.zones addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

- (void)refresh
{
    NSString *token = [[HXSMediator sharedInstance] HXSMediator_token];
    if(token) {
        if(!self.loading && self.curCity && self.curCity.city_id) {
            self.loading = YES;
            
            __weak typeof(self) weakSelf = self;
            self.request = [[HXSSiteListRequest alloc] init];
            BOOL isStoreOnly = NO;
            [self.request getSiteListWithToken:token onlyStore:isStoreOnly cityId:self.curCity.city_id complete:^(HXSErrorCode code, NSString *message, NSArray *zones) {
                
                [HXSLoadingView closeInView:weakSelf.view];
                
                if(code == kHXSNoError && zones != nil) {
                    weakSelf.firstLoading = NO;
                    
                    BEGIN_MAIN_THREAD
                    [weakSelf loadZones:zones];
                    END_MAIN_THREAD
                } else {
                    if (weakSelf.isFirstLoading) {
                        [HXSLoadingView showLoadFailInView:weakSelf.view
                                                     block:^{
                                                         [weakSelf refresh];
                                                     }];
                    } else {
                        [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                           status:message
                                                       afterDelay:1.5f];
                    }
                }
                
                weakSelf.loading = NO;
                weakSelf.request = nil;
                [weakSelf.tableView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
            }];
        }
    } else {
        [[HXSMediator sharedInstance] HXSMediator_updateToken];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.tableView       = nil;
    self.loading         = NO;
    self.curCity         = nil;
    self.request         = nil;
    self.searchRequest   = nil;
    self.positionRequest = nil;
    self.siteInfoRequest = nil;
    self.sites           = nil;
    self.positionSites   = nil;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

// section 0 is used for Location

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.zones != nil) {
        return [self.zones count] + 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section == 0) {
        if(self.positionSites.count < 1) {
            return 1;
        } else {
            return self.positionSites.count;
        }
    } else {
        HXSZone * zone = [self.zones objectAtIndex:section - 1];
        return [zone.sites count];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;
        header.textLabel.font = [UIFont systemFontOfSize:15.0];
        header.textLabel.textColor = UIColorFromRGB(0x999999);
        header.contentView.backgroundColor = [UIColor colorWithRGBHex:0xF5F6FB];
        header.layer.masksToBounds = YES;
        header.layer.borderWidth = 0.5;
        header.layer.borderColor = [UIColor colorWithRGBHex:0xd1d2d2].CGColor;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"附近学校";
    } else {
        HXSZone * zone = [self.zones objectAtIndex:section - 1];
        return zone.name;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HXSSiteCell"];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel * textLabel = cell.textLabel;
    textLabel.textColor = HXS_TABBAR_ITEM_TEXT_COLOR_NORMAL;
    textLabel.font = [UIFont systemFontOfSize:15.0];
    if(indexPath.section == 0) {
        if(self.positionSites.count < 1) {
            cell.accessoryView = nil;
            textLabel.text = self.positioningLabel.text;
            textLabel.textColor = self.positioningLabel.textColor;
        } else {
            HXSSite * site = [self.positionSites objectAtIndex:indexPath.row];
            textLabel.text = site.name;
            
            if(self.selectedSite && [self.selectedSite.site_id isEqualToNumber:site.site_id]) {
                cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
            } else {
                cell.accessoryView = nil;
            }
        }
    } else {
        
        HXSZone * zone = [self.zones objectAtIndex:indexPath.section - 1];
        HXSSite * site = [zone.sites objectAtIndex:indexPath.row];
        textLabel.text = site.name;
        
        if(self.selectedSite && [self.selectedSite.site_id isEqualToNumber:site.site_id]){
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_paysuccess"]];
        } else {
            cell.accessoryView = nil;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.view.superview.userInteractionEnabled = NO;
    [self performSelector:@selector(tablewEnable) withObject:self afterDelay:0.5];
    
    [HXSUsageManager trackEvent:HXS_SELECT_SCHOOL parameter:nil];
    
    HXSSite * site = nil;
    if(indexPath.section == 0) {
        if(self.positionSites.count > indexPath.row) {
            site = [self.positionSites objectAtIndex:indexPath.row];
        } else {
            [self findLocation:nil];
        }
    } else {
        HXSZone * zone = [self.zones objectAtIndex:indexPath.section - 1];
        site = [zone.sites objectAtIndex:indexPath.row];
    }
    [self selectSite:site];
}


#pragma mark - HXSLocationManagerDelegate

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude
{
    [HXSGPSLocationManager instance].delegate = nil;
    
    if(self.positionRequest) {
        [self.positionRequest cancel];
    }
    
    self.positionRequest = [[HXSSiteListRequest alloc] init];
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.positionRequest postionSiteListWithToken:tokenStr latitude:latitude longitude:longitude complete:^(HXSErrorCode code, NSString *message, NSArray *array) {
        [self.positionSites removeAllObjects];
        
        self.positioningLabel.hidden = NO;
        
        if(code == kHXSNoError) {
            if(array && array.count > 0) {
                [self.positionSites addObjectsFromArray:array];
                _positioningLabel.text = @"定位的学校";
                _positioningLabel.hidden = YES;
                _positioningLabel.textColor = HXS_INFO_NOMARL_COLOR;
            } else {
                _positioningLabel.text = @"附近没有找到学校";
                _positioningLabel.textColor = HXS_INFO_NOMARL_COLOR;
            }
        } else if(code == kHXSNormalError) {
            _positioningLabel.text = message;
            _positioningLabel.textColor = [UIColor colorWithRGBHex:kRedColor];
        } else {
            _positioningLabel.text = @"定位失败";
            _positioningLabel.textColor = [UIColor colorWithRGBHex:kRedColor];
        }
    
        self.isPositioning = NO;
        
        [self.tableView reloadData];
    }];
}

- (void)locationdidFailWithError:(NSError *)error
{
    [HXSGPSLocationManager instance].delegate = nil;
    
    self.isPositioning = NO;
    _positioningLabel.text = @"定位失败";
    _positioningLabel.hidden = NO;
    _positioningLabel.textColor = [UIColor colorWithRGBHex:kRedColor];
}


#pragma mark - setter

- (void)setSelectedSite:(HXSSite *)selectedSite
{
    _selectedSite = selectedSite;
    
    if(selectedSite && selectedSite.site_id.intValue > 0)
        [self refresh];
}

- (UILabel *)positioningLabel
{
    if(!_positioningLabel){
        _positioningLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _positioningLabel.text = @"定位中...";
        _positioningLabel.hidden = NO;
        _positioningLabel.textColor = HXS_INFO_NOMARL_COLOR;
    }
    return _positioningLabel;
}


#pragma mark - private method

- (void)tablewEnable
{
    self.view.superview.userInteractionEnabled = YES;
}


#pragma mark - cllocation

- (void)selectSite:(HXSSite *)site
{
    if(site == nil) {
        return;
    }
    
    self.siteInfoRequest = [[HXSSiteInfoRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [HXSLoadingView showLoadingInView:self.view];
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.siteInfoRequest seletSite:site.site_id withToken:tokenStr complete:^(HXSErrorCode code, NSString *message, HXSSite *site) {
        
        [HXSLoadingView closeInView:weakSelf.view];
        
        if(code == kHXSNoError && site != nil) {
            weakSelf.selectedSite = site;
            [weakSelf.tableView reloadData];
            
            if ([_delegate respondsToSelector:@selector(addressSelectSite:)]) {
                [_delegate addressSelectSite:site];
            }
        } else {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                               status:message
                                           afterDelay:1.5f];
        }
    }];
}

- (void)selectEntryInSite:(HXSSite *)site
{
    
    self.selectedSite = site;
    [self.tableView reloadData];
    if ([_delegate respondsToSelector:@selector(addressSelectSite:)]) {
        [_delegate addressSelectSite:site];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > 0 && self.positionSites.count >= buttonIndex) {
        [self selectSite:[self.positionSites objectAtIndex:buttonIndex - 1]];
    }
}


#pragma mark - Public Method

- (void)updateAddressList
{
    [HXSLoadingView closeInView:self.view];
    [self refresh];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
