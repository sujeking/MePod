//
//  HXSPayMentTypeTableViewCell.h
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSActionSheetEntity.h"

@interface HXSPayMentTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UIView *accessView;

@property (nonatomic, strong) HXSActionSheetEntity *actionSheetEntity;

- (void)getStoreCreditPayInfoWithPayAmount:(NSNumber *)payAmount;

@end
