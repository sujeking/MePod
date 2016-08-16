//
//  HXSActionSheetCell.h
//  store
//
//  Created by ArthurWang on 15/12/8.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXSActionSheetEntity;

@interface HXSActionSheetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *payTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payDetailLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payNameLabelCenterConstraint;

- (void)setupWithEntity:(HXSActionSheetEntity *)entity;


@end
