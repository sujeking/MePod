//
//  HXSPrintSettingPagesModifyCell.h
//  store
//
//  Created by J006 on 16/3/26.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPrintDownloadsObjectEntity.h"

static NSInteger const DEFAULT_PRINTNUMS = 1; // 默认打印份数为1

@protocol HXSPrintSettingPagesModifyCellDelegate <NSObject>

@optional

/**
 *  确认打印份数
 *
 *  @param nums
 */
- (void)confirmPrintNumsWithNums:(NSInteger)nums;

@end

@interface HXSPrintSettingPagesModifyCell : UICollectionViewCell

@property (nonatomic, weak) id<HXSPrintSettingPagesModifyCellDelegate> delegate;

- (void)initPrintSettingPagesModifyCellWithHXSMyPrintOrderItem:(HXSMyPrintOrderItem *)orderItem
                                         andWithQuantityIntNum:(NSNumber *)quantityIntNum;

@end
