//
//  HXSAmountTableViewCell.h
//  store
//
//  Created by  黎明 on 16/5/6.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXSAmountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
//总价
@property (nonatomic, strong) NSNumber *amountNum;
@end
