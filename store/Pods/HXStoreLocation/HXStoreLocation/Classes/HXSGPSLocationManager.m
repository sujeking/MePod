//
//  HXSGPSLocationManager.m
//  store
//
//  Created by hudezhi on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSGPSLocationManager.h"
#import "HXStoreLocation.h"

#import <CoreLocation/CoreLocation.h>
#import "HXSSiteListRequest.h"
#import "HXSSiteInfoRequest.h"
#import "HXLocationManager.h"
#import "HXSLocationManager.h"

#import "HXSSite.h"
#import "HXSMediator+AccountModule.h"
#import "HXMacrosUtils.h"
#import "ApplicationSettings.h"
#import "HXMacrosDefault.h"

static HXSGPSLocationManager * _gps_instance;

@interface HXSGPSLocationManager () <HXLocationManagerDelegate>

@property (nonatomic, strong) HXSSiteListRequest * positionRequest;
@property (nonatomic, strong) HXSSiteInfoRequest * siteInfoRequest;

@property (strong, nonatomic) HXSCity *currentCity;
@property (strong, nonatomic) HXSSite *currentSite;

@end

@implementation HXSGPSLocationManager

+ (HXSGPSLocationManager *)instance
{
    @synchronized(self) {
        if (!_gps_instance) {
            _gps_instance = [[HXSGPSLocationManager alloc] init];
            
            [[HXLocationManager shareInstance] setDelegate:_gps_instance];
        }
    }
    return _gps_instance;
}

+ (void)clearInstance
{
    @synchronized(self) {
        if (_gps_instance) {
            _gps_instance = nil;
        }
    }
}

- (void)updateSiteInfo
{
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    if(tokenStr && self.currentSite && self.currentSite.site_id && self.currentSite.site_id.intValue > 0) {
        self.siteInfoRequest = [[HXSSiteInfoRequest alloc] init];
        __weak HXSGPSLocationManager *weakSelf = self;
        [self.siteInfoRequest getSiteInfoWithToken:tokenStr siteId:self.currentSite.site_id complete:^(HXSErrorCode code, NSString *message, HXSSite *site) {
            if(code == kHXSNoError && site && site.site_id && site.site_id.intValue > 0) {
                BEGIN_MAIN_THREAD
                weakSelf.currentSite = site;
                
                END_MAIN_THREAD
            }
        }];
    }
}


#pragma mark - positioning

- (void)startPositioning
{
    [[HXLocationManager shareInstance] startPositioning];
}


#pragma mark - HXLocationManagerDelegate

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude
{
    self.latitude = latitude;
    self.longitude = longitude;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidUpdateLatitude:longitude:)]) {
        [self.delegate locationDidUpdateLatitude:self.latitude longitude:self.longitude];
    }
    
    if(self.positionRequest) {
        [self.positionRequest cancel];
    }
    
    __weak typeof (self) weakSelf = self;
    self.positionRequest = [[HXSSiteListRequest alloc] init];
    NSString *tokenStr = [[HXSMediator sharedInstance] HXSMediator_token];
    [self.positionRequest postionSiteListWithToken:tokenStr latitude:self.latitude longitude:self.longitude complete:^(HXSErrorCode code, NSString *message, NSArray *array) {
        
        if(code == kHXSNoError) {
            if(array && array.count > 0) {
                HXSCity * city = [[HXSCity alloc] init];
                for(HXSSite * site in array) {
                    if(site.cityName.length > 0 && site.cityId.intValue > 0) {
                        city.name = site.cityName;
                        city.city_id = site.cityId;
                        break;
                    }
                }
                
                weakSelf.positioningCity = city;
                if(!weakSelf.currentCity) {
                    weakSelf.currentCity = city;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCityChanged object:nil];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kPositioningCityChanged object:nil];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPositionCityFailed object:nil];
        }
    }];
}

- (void)locationdidFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(locationdidFailWithError:)]) {
        [self.delegate locationdidFailWithError:error];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPositionCityFailed object:nil];
}

- (BOOL)checkIsInPositioningCity
{
    return YES;
}


#pragma mark - getter/setter

- (HXSCity *)currentCity
{
    HXSLocationManager *dormLoMgr = [HXSLocationManager manager];
    
    return dormLoMgr.currentCity;;
}

- (void)setCurrentCity:(HXSCity *)currentCity
{
    HXSLocationManager *dormLoMgr = [HXSLocationManager manager];
    dormLoMgr.currentCity = currentCity;
}

- (HXSSite *)currentSite
{
    HXSLocationManager *dormLoMgr = [HXSLocationManager manager];
    return dormLoMgr.currentSite;
}

- (void)setCurrentSite:(HXSSite *)currentSite
{
    HXSLocationManager *dormLoMgr = [HXSLocationManager manager];
    dormLoMgr.currentSite = currentSite;
}

@end
