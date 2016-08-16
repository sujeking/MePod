//
//  HXSSubscribeSelectCell.h
//  59dorm
//
//  Created by J006 on 16/7/12.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat cellSelectHeight  = 44;

@interface HXSSubscribeSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)createSubscribeSelectCell;

@end
