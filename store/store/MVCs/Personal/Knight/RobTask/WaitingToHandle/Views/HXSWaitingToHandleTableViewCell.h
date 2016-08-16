//
//  HXSWaitingToHandleTableViewCell.h
//  store
//
//  Created by 格格 on 16/4/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HXSTaskOrder.h"

@protocol HXSWaitingToHandleTableViewCellDelegate <NSObject>

- (void)phoneButtonButtonClicked:(HXSTaskOrder *)taskOrder;
- (void)shopPhoneClicked:(HXSTaskOrder *)taskOrder;
- (void)qrCodeButtonClicked:(HXSTaskOrder *)taskOrder;

@end

@interface HXSWaitingToHandleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSWaitingToHandleTableViewCellDelegate> delegate;
@property (nonatomic, strong) HXSTaskOrder *taskOrder;

@end
