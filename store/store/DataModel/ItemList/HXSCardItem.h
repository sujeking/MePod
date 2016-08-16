//
//  HXSCardItem.h
//  store
//
//  Created by chsasaw on 14/10/29.
//  Copyright (c) 2014年 huanxiao. All rights reserved.
//

#import "HXSItemBase.h"

typedef enum {
    HXSCardLayoutTypeFull = 0,
    HXSCardLayoutTypeTwoPart,
    HXSCardLayoutTypeThreeLeft,
    HXSCardLayoutTypeThreeRight,
}HXSCardLayoutType;

@interface HXSCardItemLayoutStyle : NSObject

@property (nonatomic, assign) HXSCardLayoutType type;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, assign) BOOL show_accessory;
@property (nonatomic, assign) int bottomMargin;

@end

@interface HXSCardItem : HXSItemBase

@property (nonatomic, copy)     NSString * accessoryText;
@property (nonatomic, strong)   NSMutableArray * itemList;
@property (nonatomic, strong)   HXSCardItemLayoutStyle * layoutStyle;
@property (nonatomic, strong)   NSDate * startDate;
@property (nonatomic, strong)   NSDate * endDate;

@end