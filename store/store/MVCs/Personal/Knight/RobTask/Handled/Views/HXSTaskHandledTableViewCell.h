//
//  HXSTaskHandledTableViewCell.h
//  store
//
//  Created by 格格 on 16/4/27.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSTaskOrder.h"

@protocol HXSTaskHandledTableViewCellDelegate <NSObject>

- (void)phoneButtonButtonClicked:(HXSTaskOrder *)taskOrder;
- (void)shopPhoneClicked:(HXSTaskOrder *)taskOrder;

@end

@interface HXSTaskHandledTableViewCell : UITableViewCell

@property (nonatomic, strong) HXSTaskOrder *taskOrder;
@property (nonatomic, weak) id<HXSTaskHandledTableViewCellDelegate> delegate;

@end
