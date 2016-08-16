//
//  HXSCommunityPhotosViewController.h
//  store
//
//  Created by J006 on 16/4/11.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSCommunitUploadImageEntity.h"

@protocol HXSCommunityPhotosViewControllerDelegate <NSObject>

@optional

/**
 *  通知图片浏览器背景颜色变透明
 */
- (void)noticeTheViewBrowserBGColorTurnClear;

/**
 *  移除图片浏览器
 */
- (void)removeAndBackToMainView;
/**
 *  举报图片
 */
- (void)reportThePhoto;

@end

typedef NS_ENUM(NSInteger, CommunitPhotoBrowserSingleViewType)
{
    kCommunitPhotoBrowserSingleViewTypePostUploadImage     = 0,//帖子发布上传图片
    kCommunitPhotoBrowserSingleViewTypeViewImage           = 1,//普通图片浏览
};

@interface HXSCommunityPhotosViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSCommunityPhotosViewControllerDelegate> delegate;

- (void)initHXSCommunityPhotosViewControllerWithEntity:(HXSCommunitUploadImageEntity *)entity
                                           andWithType:(CommunitPhotoBrowserSingleViewType)type;

- (void)setTheOriginImageView:(UIImageView *)imageView;

@end
