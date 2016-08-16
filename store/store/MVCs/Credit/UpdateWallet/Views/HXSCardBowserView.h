//
//  HXS的顶顶顶顶顶.h
//  store
//
//  Created by  黎明 on 16/7/21.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  身份证图片查看View
 */

@interface HXSCardBowserView : UIView
{
    CGRect oldframe;
}

@property (nonatomic, copy) void (^reTakePhotoBlock)();

- (void)showImage:(UIImageView *)avatarImageView;

@end
