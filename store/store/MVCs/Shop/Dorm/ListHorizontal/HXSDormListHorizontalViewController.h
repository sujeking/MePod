//
//  HXSDormListHorizontalViewController.h
//  store
//
//  Created by ArthurWang on 15/11/3.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseTableViewController.h"

@class HXSDormItemList, HXSShopEntity;

@protocol HXSDormListHorizontalViewControllerDelegate <NSObject>

@required

- (void)showView;
- (void)hideView;

- (void)reloadItemList;

@end

@interface HXSDormListHorizontalViewController : HXSBaseTableViewController

@property (nonatomic, strong) HXSShopEntity *shopEntity;
@property (nonatomic, strong) HXSDormItemList *itemList;
@property (nonatomic, assign) id<HXSDormListHorizontalViewControllerDelegate> listDelegate;
/**加载更多回调*/
@property (nonatomic, copy) void (^loadMoreAction)();

- (void)reloadDataShouldAnimation:(BOOL)animation;
- (void)stopReloadData;

- (void)scrollToAssignRowWhenClickIndex:(int)index;

@end
