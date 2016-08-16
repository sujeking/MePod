//
//  HXSFinishTakePhotoView.h
//  store
//
//  Created by  黎明 on 16/7/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSFinishTakePhotoView : UIView

@property (nonatomic, copy) void (^reTakePhotoBlock)(HXSFinishTakePhotoView *view);
@property (nonatomic, copy) void (^takePhotoDoneBlock)(UIImage *image);

- (instancetype)initWithImage:(UIImage *)image;

@end
