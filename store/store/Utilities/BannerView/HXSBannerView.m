//
//  HXSBannerView.m
//  store
//
//  Created by ArthurWang on 16/1/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBannerView.h"

#import "HXSBannerTableViewCell.h"
#import "HXSShopViewModel.h"

static NSString *BannerTableViewCell           = @"HXSBannerTableViewCell";
static NSString *BannerTableViewCellIdentifier = @"HXSBannerTableViewCell";

#define PADDING 10

@interface HXSBannerView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSNumber *shopIDNum;
@property (nonatomic, strong) NSNumber *dormentryIDNum;
@property (nonatomic, assign) CGFloat  width;

@property (nonatomic, strong) NSArray *bannerDataSource;
@property (nonatomic, strong) HXSShopViewModel *shopModel;

@end

@implementation HXSBannerView

- (instancetype)initWithShopID:(NSNumber *)shopIDNum
                   dormentryID:(NSNumber *)dormentryIDNum
                         width:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.shopIDNum      = shopIDNum;
        self.dormentryIDNum = dormentryIDNum;
        self.width          = width;
        
        [self initialTableView];
        
        [self initialbannerDataSource];
    }
    return self;
}


#pragma mark - Initial Methods

- (void)initialTableView
{
    self.dataSource = self;
    self.delegate   = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator   = NO;
    self.scrollEnabled                  = NO;
    self.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    
    [self registerNib:[UINib nibWithNibName:BannerTableViewCell bundle:nil] forCellReuseIdentifier:BannerTableViewCellIdentifier];
    
}

- (void)initialbannerDataSource
{
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    
    [self.shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                              type:@(kHXSStoreInletBalanceResultBottom)
                                          complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                              
                                              if (kHXSNoError != status
                                                  || (0 >= [entriesArr count])) {
                                                  return ;
                                              }
                                              
                                              weakSelf.bannerDataSource = entriesArr;
                                              
                                              BEGIN_MAIN_THREAD
                                              [weakSelf setupTableViewFrame];
                                              
                                              [weakSelf reloadData];
                                              END_MAIN_THREAD
                                              
                                          }];

}


#pragma mark - Setup TableView

- (void)setupTableViewFrame
{
    CGFloat tableViewHeight = 0.0;
    
    for (HXSStoreAppEntryEntity *entity in self.bannerDataSource) {
        CGFloat localImageHeight = [self heightOfCellWithEntity:entity];
        
        tableViewHeight += localImageHeight;
    }
    
    [self setFrame:CGRectMake(0, 0, self.width, tableViewHeight)];
    
    if (nil != self.loadBannerComplete) {
        self.loadBannerComplete();
    }
}

- (CGFloat)heightOfCellWithEntity:(HXSStoreAppEntryEntity *)entity
{
    CGFloat width = self.width - 2 * PADDING;
    CGFloat imageWidth = [entity.imageWidthIntNum floatValue];
    CGFloat imageHeight = [entity.imageHeightIntNum floatValue];
    
    CGFloat scale;
    if ((0 == imageWidth)
        || (0 == imageHeight)) {
        scale = 200 / 710; // 根据设计稿的默认比例
    } else {
        scale = imageHeight / imageWidth;
    }
    
    
    CGFloat height =  scale * width;
    
    return height + PADDING;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bannerDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSStoreAppEntryEntity *entity = [self.bannerDataSource objectAtIndex:indexPath.row];
    
    return [self heightOfCellWithEntity:entity];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BannerTableViewCellIdentifier forIndexPath:indexPath];
    
    HXSStoreAppEntryEntity *entity = [self.bannerDataSource objectAtIndex:indexPath.row];
    
    [cell.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[entity.imageURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (nil != self.didSelectedBanner) {
        HXSStoreAppEntryEntity *entity = [self.bannerDataSource objectAtIndex:indexPath.row];
        
        self.didSelectedBanner(entity);
    }
}


#pragma mark - Setter Getter

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}


@end
