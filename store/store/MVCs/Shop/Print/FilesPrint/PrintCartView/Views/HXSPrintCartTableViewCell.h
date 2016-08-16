//
//  HXSPrintCartTableViewCell.h
//  store
//
//  Created by J006 on 16/3/31.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSMyPrintOrderItem.h"

typedef NS_ENUM(NSInteger, HXSPrintCartCellSettingType){
    kHXSPrintCartCellSettingTypeDoc  = 0,//文档
    kHXSPrintCartCellSettingTypePic  = 1,//图片
};

@interface HXSPrintCartTableViewCell : UITableViewCell

- (void)initPrintCartTableViewCellWithEntity:(HXSMyPrintOrderItem *)entity
                                     andType:(HXSPrintCartCellSettingType)type;

@end
