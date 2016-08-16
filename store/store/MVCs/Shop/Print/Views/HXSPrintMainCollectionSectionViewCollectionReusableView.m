//
//  HXSPrintMainCollectionSectionViewCollectionReusableView.m
//  store
//
//  Created by J006 on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSPrintMainCollectionSectionViewCollectionReusableView.h"
#import "HXSShopViewModel.h"

@interface HXSPrintMainCollectionSectionViewCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel            *titleLabel;
@property (weak, nonatomic) IBOutlet UIView             *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelBottomConstraint;

@end

@implementation HXSPrintMainCollectionSectionViewCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_topView addSubview:self.headerBannerView];
    [_headerBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topView);
    }];
    
    [self fetchBannerSlide];
}

- (void)fetchBannerSlide
{
    WS(weakSelf);
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    HXSSite *site = locationMgr.currentSite;
    NSNumber *siteIdIntNum = (0 < [site.site_id integerValue]) ? site.site_id : [[ApplicationSettings instance] defaultSiteID];
    HXSShopViewModel *shopModel = [[HXSShopViewModel alloc] init];
    
    [shopModel fetchStoreAppEntriesWithSiteId:siteIdIntNum
                                         type:@(kHXSPrintInletTop)
                                     complete:^(HXSErrorCode status, NSString *message, NSArray<HXSStoreAppEntryEntity *> *entriesArr) {
                                         if (0 < [entriesArr count]) {
                                             HXSStoreAppEntryEntity *item = [entriesArr objectAtIndex:0];
                                             CGSize size = CGSizeMake(item.imageWidthIntNum.floatValue, item.imageHeightIntNum.floatValue);
                                             CGFloat scaleOfSize = size.height / size.width;
                                             if (isnan(scaleOfSize)
                                                 || isinf(scaleOfSize)) {
                                                 scaleOfSize = 1.0;
                                             }
                                             weakSelf.heightOfBannerFloat = scaleOfSize * SCREEN_WIDTH;
                                             
                                             [weakSelf.headerBannerView setSlideItemsArray:entriesArr];
                                             if (weakSelf.delegate
                                                 && [weakSelf.delegate respondsToSelector:@selector(refreshTheCollectionViewHasBanner:)]) {
                                                 [weakSelf.delegate refreshTheCollectionViewHasBanner:YES];
                                             }
                                         } else {
                                             if (weakSelf.delegate
                                                 && [weakSelf.delegate respondsToSelector:@selector(refreshTheCollectionViewHasBanner:)]) {
                                                 [_topView removeFromSuperview];
                                                 _titleLabelBottomConstraint.constant = 21;
                                                 [weakSelf.delegate refreshTheCollectionViewHasBanner:NO];
                                             }
                                         }
                                     }];
}

- (HXSBannerLinkHeaderView *)headerBannerView
{
    if(!_headerBannerView) {
        _headerBannerView = [[HXSBannerLinkHeaderView alloc] init];
    }
    return _headerBannerView;
}

@end
