//
//  HXSBuildingTableViewCell.h
//  store
//
//  Created by ArthurWang on 15/9/1.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSBuildingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopTypeLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopTypeMiddleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shopTypeRightImageView;


@property (nonatomic, assign) BOOL shouldHighlighted;

@end
