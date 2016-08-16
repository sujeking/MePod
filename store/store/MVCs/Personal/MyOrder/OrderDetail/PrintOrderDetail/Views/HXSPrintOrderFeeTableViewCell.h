//
//  HXSPrintOrderFeeTableViewCell.h
//  store
//
//  Created by 格格 on 16/4/7.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSPrintOrderFeeTableViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *keyLabel;
@property(nonatomic,weak) IBOutlet UILabel *valueLabel;

// dic key:keyLabel  value:valueLabel
- (void)setupPrintOrderFeeCellWith:(NSDictionary *)dic;

@end
