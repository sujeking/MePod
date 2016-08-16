//
//  HXSBannerLinkHeaderView.h
//  store
//
//  Created by ArthurWang on 16/4/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSStoreAppEntryEntity;

@protocol HXSBannerLinkHeaderViewDelegate <NSObject>

@required
- (void)didSelectedLink:(NSString *)linkStr;

@end

@interface HXSBannerLinkHeaderView : UIView

@property (nonatomic, weak) id<HXSBannerLinkHeaderViewDelegate> eventDelegate;

- (instancetype)initHeaderViewWithDelegate:(id<HXSBannerLinkHeaderViewDelegate>)delegate;

- (void)setSlideItemsArray:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr;

@end
