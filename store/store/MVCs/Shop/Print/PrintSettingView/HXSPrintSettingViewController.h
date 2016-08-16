//
//  HXSPrintSettingViewController.h
//  store
//
//  Created by J006 on 16/3/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSMyPrintOrderItem.h"
#import "HXSShopEntity.h"
#import "HXSPrintDownloadsObjectEntity.h"

typedef NS_ENUM(NSInteger, HXSPrintCartSettingType){
    HXSPrintCartSettingTypeDoc  = 0,//文档
    HXSPrintCartSettingTypePic  = 1,//图片
};

@protocol HXSPrintSettingViewControllerDelegate <NSObject>

@optional

/**
 *  编辑确定
 */
- (void)confirmCartWithOrderItem:(HXSMyPrintOrderItem *)entity
andWithPrintDownloadsObjectEntity:(HXSPrintDownloadsObjectEntity *)objectEntity;

@end

@interface HXSPrintSettingViewController : HXSBaseViewController
/**文档类型图标*/
@property (weak, nonatomic) IBOutlet UIImageView *printDocumentLogoImageView;

@property (nonatomic, weak) id<HXSPrintSettingViewControllerDelegate> delegate;

- (void)initPrintSettingViewControllerWithEntity:(HXSMyPrintOrderItem *)entity
                                     andWithShop:(HXSShopEntity *)shopEntity
                                andWithCartArray:(NSMutableArray *)array
               andWithPrintDownloadsObjectEntity:(HXSPrintDownloadsObjectEntity *)downloadObjectEntity
                                         andType:(HXSPrintCartSettingType)type;

@end
