//
//  HXSEmergencyInforCell.h
//  59dorm
//
//  Created by J006 on 16/7/13.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSEmergencyInforCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)createEmergencyInforCell;

@end
