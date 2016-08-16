//
//  HXSAdTableViewCell.h
//  store
//
//  Created by  黎明 on 16/7/25.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

/************************************************************
 *  店铺列表URL cell  具体功能和图片均有运营配置来执行
 ***********************************************************/

#import <UIKit/UIKit.h>

@class HXSStoreAppEntryEntity;

@protocol HXSAdTableViewCellDelegate <NSObject>

@required

- (void)AdTableViewCellImageTaped:(NSString *)linkStr;

@end


@interface HXSAdTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSAdTableViewCellDelegate> delegate;

- (void)setupItemImages:(NSArray<HXSStoreAppEntryEntity *> *)slideItemsArr;

+ (CGFloat)getCellHeightWithObject:(HXSStoreAppEntryEntity *)storeAppEntryEntity;

@end
