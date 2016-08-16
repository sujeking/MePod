//
//  HXSCreditCollectionViewCell.h
//  store
//
//  Created by ArthurWang on 16/2/18.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSStoreAppEntryEntity;

@interface HXSCreditCollectionViewCell : UICollectionViewCell

- (void)setupCollectionCellWithSlideItem:(HXSStoreAppEntryEntity *)slideItem;

@end
