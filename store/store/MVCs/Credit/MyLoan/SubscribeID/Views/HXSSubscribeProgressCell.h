//
//  HXSSubscribeProgressCell.h
//  59dorm
//
//  Created by J006 on 16/7/8.
//  Copyright © 2016年 Huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat subscribeProgressCellHeight = 100;

@interface HXSSubscribeProgressCell : UITableViewCell

- (void)initSubscribeProgressCellWithCurrentStepIndex:(NSInteger)stepIndex;

@end
