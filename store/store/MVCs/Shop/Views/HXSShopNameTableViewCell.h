//
//  HXSShopNameTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/1/14.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSShopEntity;

@interface HXSShopNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shopTypeImageView;

- (void)setupCellWithEntity:(HXSShopEntity *)entity;

@end
