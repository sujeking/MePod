//
//  HXSCustomTakePhotoViewController.h
//  store
//
//  Created by  黎明 on 16/7/20.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <HXSBaseViewController.h>

/**
 *  拍摄类型
 */
typedef NS_ENUM(NSInteger, HXSTakePhotoType)
{
    kHXSTakePhotoTypeCardUp     = 0,       // 证件照正面拍摄
    kHXSTakePhotoTypeCardDown   = 1,       // 证件照反面拍摄
    kHXSTakePhotoTypeCardHandle = 2,       // 手持证件照拍摄
};




@protocol HXSCustomTakePhotoViewControllerDelegate <NSObject>
/**
 *  拍照结束之后得到照片
 *
 *  @param image
 */
- (void)takePhotoDoneFinishAndGetImage:(UIImage *)image;

@end

@interface HXSCustomTakePhotoViewController : UIViewController
@property (nonatomic, assign) HXSTakePhotoType takePhotoType;
@property (nonatomic, weak) id<HXSCustomTakePhotoViewControllerDelegate> delegate;


@end
