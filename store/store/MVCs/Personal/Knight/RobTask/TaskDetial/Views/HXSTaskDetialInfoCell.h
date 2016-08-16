//
//  HXSTaskDetialInfoCell.h
//  store
//
//  Created by 格格 on 16/4/29.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSTaskOrderDetial.h"

@protocol HXSTaskDetialInfoCellDelegate <NSObject>

- (void)buyerPhoneClicked:(HXSTaskOrderDetial *)taskOrderDetial;
- (void)shopPhoneClicked:(HXSTaskOrderDetial *)taskOrderDetial;

@end

@interface HXSTaskDetialInfoCell : UITableViewCell

@property (nonatomic, strong) HXSTaskOrderDetial *taskOrderDetial;
@property (nonatomic, weak) id<HXSTaskDetialInfoCellDelegate> delete;

@end
