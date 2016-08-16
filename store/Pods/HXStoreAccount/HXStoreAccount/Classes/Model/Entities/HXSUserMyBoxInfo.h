//
//  HXSUserMyBoxInfo.h
//  store
//
//  Created by ArthurWang on 15/11/19.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HXSBoxEntry.h"
#import "HXSCity.h"
#import "HXSSite.h"
#import "HXSDormEntry.h"
#import "HXSBuildingEntry.h"
#import "HXMacrosEnum.h"

@interface HXSApplyBoxInfo : NSObject

@property (nonatomic, assign) HXSApplyBoxStatus status;
@property (nonatomic, strong) NSString *dormPhone;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface HXSUserMyBoxInfo : NSObject

@property (nonatomic, strong) HXSBoxEntry      *boxEntry;
@property (nonatomic, strong) HXSCity          *cityEntry;
@property (nonatomic, strong) HXSSite          *siteEntry;
@property (nonatomic, strong) HXSDormEntry     *dormEntry;
@property (nonatomic, strong) HXSBuildingEntry *buildingEntry;
@property (nonatomic, strong) HXSApplyBoxInfo  *applyInfo;


@end
