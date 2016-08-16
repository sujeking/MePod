//
//  HXSMyFilesPrintTableViewCell.h
//  store
//
//  Created by J006 on 16/5/19.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXSPrintDownloadsObjectEntity.h"

@class HXSMyFilesPopViewController;

@protocol HXSMyFilesPrintTableViewCellDelegate <NSObject>

@optional

/**
 *  加入或者删除购物车
 *
 *  @param entity 
 *  @param view
 */
- (void)addToCartOrRemovedWithEntity:(HXSPrintDownloadsObjectEntity *)entity
                  andWithContentView:(UIView *)view;
/**
 *  重新上传
 *
 *  @param entity
 */
- (void)reUploadTheDocumentWithEntity:(HXSPrintDownloadsObjectEntity *)entity;

@end

@interface HXSMyFilesPrintTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HXSMyFilesPrintTableViewCellDelegate> delegate;

- (void)initMyFilesPrintTableViewCellWithEntity:(HXSPrintDownloadsObjectEntity *)entity;

@end
