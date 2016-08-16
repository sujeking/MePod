//
//  HXSSubmitApplyCell.h
//  store
//
//  Created by 格格 on 16/6/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSSubmitApplyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *tagImage;
@property (nonatomic, weak) IBOutlet UILabel *keyLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueLabel;

+ (instancetype)submitApplyCell;

@end
