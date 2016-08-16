//
//  HXSDigitalMobileCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSDigitalMobileItemListEntity;

@interface HXSDigitalMobileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

- (void)setupCellWithEntity:(HXSDigitalMobileItemListEntity *)entity;

@end
