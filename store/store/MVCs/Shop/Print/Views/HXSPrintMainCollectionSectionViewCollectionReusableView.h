//
//  HXSPrintMainCollectionSectionViewCollectionReusableView.h
//  store
//
//  Created by J006 on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSBannerLinkHeaderView.h"

//static CGFloat BANNER_HEIGHT = 180.0;

static CGFloat const SINGLE_LABEL_HEIGHT = 50.0;

@protocol HXSPrintMainCollectionSectionViewCollectionReusableViewDelegate <NSObject>

@optional

/**
 *  通知刷新界面
 */
- (void)refreshTheCollectionViewHasBanner:(BOOL)hasBanner;

@end


@interface HXSPrintMainCollectionSectionViewCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) id<HXSPrintMainCollectionSectionViewCollectionReusableViewDelegate> delegate;

@property (nonatomic, strong) HXSBannerLinkHeaderView *headerBannerView;

@property (nonatomic, assign) CGFloat heightOfBannerFloat;

@end
