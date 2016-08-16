//
//  HXSCommunityPhotosBrowserViewController.h
//  store
//  社区发帖查看图片界面
//  Created by J006 on 16/4/12.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"
#import "HXSCommunitUploadImageEntity.h"
#import "HXSPost.h"

typedef NS_ENUM(NSInteger, CommunitPhotoBrowserType)
{
    kCommunitPhotoBrowserTypePostUploadImage     = 0,// 帖子发布上传图片
    kCommunitPhotoBrowserTypeViewImage           = 1,// 普通图片浏览
};


@protocol HXSCommunityPhotosBrowserViewControllerDelegate <NSObject>

@optional

/**
 *  举报图片
 */
- (void)reportThePhotoWithEntity:(HXSPost *)entity;

@end

@interface HXSCommunityPhotosBrowserViewController : HXSBaseViewController

@property (nonatomic, weak) id<HXSCommunityPhotosBrowserViewControllerDelegate> delegate;

/**
 *  初始化图片浏览界面
 *
 *  @param uploadImageParamArray 需要访问的图片集群
 *  @param index                 需要访问的特定图片的索引
 *  @param type                  类型:是上传帖子时还是普通图片浏览
 */
- (void)initCommunityPhotosBrowserWithImageParamArray:(NSMutableArray<HXSCommunitUploadImageEntity *> *)uploadImageParamArray
                                             andIndex:(NSInteger)index
                                              andType:(CommunitPhotoBrowserType)type;
/**
 *  获取原始图片
 *
 *  @param imageView
 */
- (void)setTheOriginImageView:(UIImageView *)imageView;
/**
 *  如果是普通浏览图片则需要传递post
 *
 *  @param post
 */
- (void)setThePostEntity:(HXSPost *)post;

@end
