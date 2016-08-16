//
//  HXSShopInfoNameTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSShopEntity;

@interface HXSShopInfoNameTableViewCell : UITableViewCell

- (void)setupCellWithEntity:(HXSShopEntity *)entity;

+ (CGFloat)rowHeight:(HXSShopEntity *)entity;

@end
