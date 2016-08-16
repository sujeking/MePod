//
//  UDPhotoView.h
//  UdeskSDK
//
//  Created by xuchen on 16/1/18.
//  Copyright © 2016年 xuchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDOneScrollView.h"
#import "UDMessage.h"

@interface UDPhotoView : UIView<UDOneScrollViewDelegate>

//获取数据
-(void)setPhotoData:(UIImageView *)photoImageView withImageMessage:(UDMessage *)message;

@end
