//
//  HXLocationManager.h
//  store
//
//  Created by ArthurWang on 16/6/22.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HXLocationManagerDelegate <NSObject>

- (void)locationDidUpdateLatitude:(double)latitude longitude:(double)longitude;

@optional

- (void)locationdidFailWithError:(NSError *)error;

@end

@interface HXLocationManager : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) id<HXLocationManagerDelegate> delegate;


+ (instancetype)shareInstance;

- (void)startPositioning;

@end
