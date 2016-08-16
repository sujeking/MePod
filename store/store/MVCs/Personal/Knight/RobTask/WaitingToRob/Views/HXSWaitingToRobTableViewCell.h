//
//  HXSWaitingToRobTableViewCell.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSTaskOrder.h"

@protocol HXSWaitingToRobTableViewCellDelegate <NSObject>

- (void)robTaskButtonClickedWithTaskOrder:(HXSTaskOrder *)taskOrder;

@end

@interface HXSWaitingToRobTableViewCell : UITableViewCell

@property (nonatomic, strong) HXSTaskOrder *taskOrder;
@property (nonatomic, weak) id<HXSWaitingToRobTableViewCellDelegate>delegate;

- (IBAction)taskButtonClicked:(id)sender;

@end
