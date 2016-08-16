//
//  HXSGPSLocationManager.h
//  store
//
//  Created by hudezhi on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSCity.h"

@protocol HXSGPSLocationManagerDelegate <NSObject>

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude;

@optional

- (void)locationdidFailWithError:(NSError *)error;

@end

@interface HXSGPSLocationManager : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (strong, nonatomic) HXSCity * positioningCity;

@property (nonatomic, assign) id<HXSGPSLocationManagerDelegate> delegate;

+ (HXSGPSLocationManager *)instance;
+ (void)clearInstance;

- (void) updateSiteInfo;
- (void) startPositioning;
- (BOOL) checkIsInPositioningCity;

@end
