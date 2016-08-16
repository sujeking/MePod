//
//  HXSDormListVerticalViewController.h
//  store
//
//  Created by ArthurWang on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSBaseViewController.h"

@class HXSDormItemList, HXSShopEntity;

@protocol HXSDormListVerticalViewControllerDelegate <NSObject>

@required

- (void)showView;
- (void)hideView;
- (void)reloadItemList;

@end

@interface HXSDormListVerticalViewController : HXSBaseViewController

@property (nonatomic, strong) HXSShopEntity *shopEntity;
@property (nonatomic, strong) HXSDormItemList *itemList;
@property (nonatomic, assign) id<HXSDormListVerticalViewControllerDelegate> listDelegate;
@property (weak, nonatomic) IBOutlet UICollectionView *dormItemCollectionView;
/**加载更多回调*/
@property (nonatomic, copy) void (^loadMoreAction)();

- (void)reloadDataShouldAnimation:(BOOL)animation;
- (void)stopReloadData;

- (void)scrollToAssignRowWhenClickIndex:(int)index;

@end
