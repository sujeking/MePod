//
//  HXSRobTaskNoDataView.h
//  store
//
//  Created by 格格 on 16/5/4.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSRobTaskNoDataView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *label;

+ (id)noDataView;

@end
