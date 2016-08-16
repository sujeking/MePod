//
//  HXSStoreAppEntryTableViewCell.h
//  store
//
//  Created by ArthurWang on 16/4/15.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger const kHeightEntryCell = 105;

@class HXSStoreAppEntryTableViewCell;

@protocol HXSStoreAppEntryTableViewCellDelegate <NSObject>

@required
- (void)storeAppEntryTableViewCell:(HXSStoreAppEntryTableViewCell *)cell didSelectedLink:(NSString *)linkStr;

@end

@interface HXSStoreAppEntryTableViewCell : UITableViewCell

- (void)setupCellWithStoreAppEntriesArr:(NSArray *)entriesArr delegate:(id<HXSStoreAppEntryTableViewCellDelegate>)delegate;

@end
