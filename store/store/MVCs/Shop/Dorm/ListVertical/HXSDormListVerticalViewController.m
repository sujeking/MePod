//
//  HXSDormListVerticalViewController.m
//  store
//
//  Created by ArthurWang on 15/11/10.
//  Copyright © 2015年 huanxiao. All rights reserved.
//

#import "HXSDormListVerticalViewController.h"

// Controllers
#import "HXSWebViewController.h"

// Model
#import "HXSShop.h"
#import "HXSDormCategory.h"
#import "HXSDormItemList.h"
#import "HXSDormCartManager.h"
#import "HXSDormListVerticalCellEntity.h"
#import "HXSDormCartItem.h"
#import "HXSShopEntity.h"
#import "HXSShopManager.h"

// Views
#import "HXSDormListVerticalCollectionViewCell.h"
#import "HXSDormItemMaskView.h"


static NSString *DormItemCollectionViewCell           = @"HXSDormListVerticalCollectionViewCell";
static NSString *DormItemCollectionViewCellIdentifier = @"HXSDormListVerticalCollectionViewCell";

@interface HXSDormListVerticalViewController () <UICollectionViewDelegate,
                                                 UICollectionViewDataSource,
                                                 HXSDormListVerticalCollectionViewCellDelegate,
                                                 HXSFoodieItemPopViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) BOOL    autoScrolling;

@end

@implementation HXSDormListVerticalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lastPosition  = 0;
    self.autoScrolling = NO;
    
    [self initialCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.itemList     = nil;
    self.listDelegate = nil;
    self.dataSource   = nil;
}


#pragma mark - Initial Methods

- (void)initialCollectionView
{
    [self.dormItemCollectionView registerNib:[UINib nibWithNibName:DormItemCollectionViewCell bundle:[NSBundle mainBundle]]
             forCellWithReuseIdentifier:DormItemCollectionViewCellIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.dormItemCollectionView addRefreshHeaderWithCallback:^{
        [weakSelf.listDelegate reloadItemList];
    }];
    
    [self.dormItemCollectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreItems];
    }];
    
    self.dormItemCollectionView.backgroundColor = HXS_VIEWCONTROLLER_BG_COLOR;
    
}


#pragma mark - Public Methods

- (void)reloadDataShouldAnimation:(BOOL)animation
{
    if (animation) {
        [HXSLoadingView showLoadingInView:self.view];
        
        [self.listDelegate reloadItemList];
    } else {
        [self.dormItemCollectionView endRefreshing];
        [HXSLoadingView closeInView:self.view];
        
        [self.dormItemCollectionView reloadData];
    }
}

- (void)stopReloadData
{
    [self.dormItemCollectionView endRefreshing];
    [HXSLoadingView closeInView:self.view];
}

- (void)scrollToAssignRowWhenClickIndex:(int)index
{
    // Can't out of data source
    if (index >= [self.itemList.itemCategoryList count]) {
        return;
    }
    
    NSInteger count = [self countOfItemsInIndex:index];
    
    count++; // the first one of postion section
    
    // Can't out of data source
    if (count >= [self.dataSource count]) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
    self.autoScrolling = YES;
    [self.dormItemCollectionView scrollToItemAtIndexPath:indexPath
                                        atScrollPosition:UICollectionViewScrollPositionTop
                                                animated:YES];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.autoScrolling = NO;
    });
}


#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.dormItemCollectionView) {
        
        CGFloat currentPostion = scrollView.contentOffset.y;
        
        if (currentPostion - _lastPosition > 25 ) {
            _lastPosition = currentPostion;
            
            if (0 < currentPostion) {
                [self.listDelegate hideView];
            }
            
        } else if (_lastPosition - currentPostion > 45) {
            _lastPosition = currentPostion;
            
            if (0 > currentPostion) {
                [self.listDelegate showView];
            }
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.dormItemCollectionView) {
        _lastPosition = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
}

/**
 *  加载更多
 */
- (void)loadMoreItems
{
    if (self.loadMoreAction) {
        self.loadMoreAction();
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCREEN_WIDTH / 3;
    CGFloat height = width * 160 / 100; // UI Designer set width 100, height 150
    
    return CGSizeMake(width, height);
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDormListVerticalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DormItemCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if ([self.dataSource count] > indexPath.row) {
        HXSDormItem *item = [self.dataSource objectAtIndex:indexPath.row];
        
        HXSDormCartItem * cartItem = [[HXSDormCartManager sharedManager] getCartItemOfDormItem:item];
        HXSDormListVerticalCellEntity *entity = [[HXSDormListVerticalCellEntity alloc] init];
        entity.itemId   = cartItem.itemId;
        entity.quantity = cartItem.quantity;
        cell.delegate = self;
        
        [cell setItem:item item:entity dormStatus:[[HXSShopManager shareManager].currentEntry.shopEntity.statusIntNum intValue]];
    }
    
    return cell;
}


#pragma mark - HXSDormListVerticalCollectionViewCellDelegate

- (void)dormItemTableViewCellDidShowDetail:(HXSDormListVerticalCollectionViewCell *)cell
{
    NSIndexPath * indexPath = [self.dormItemCollectionView indexPathForCell:cell];
    if(indexPath.row >= [self.dataSource count]) { // index out of bounds
        return;
    }
    
    [HXSUsageManager trackEvent:kUsageEventFoodDetailInfo parameter:@{@"business_type":@"夜猫店"}];
    
    CGRect frame = cell.imageImageVeiw.frame;
    frame = [cell convertRect:frame toView:[AppDelegate sharedDelegate].window];

    HXSDormItem * item = [self.dataSource objectAtIndex:indexPath.row];
    UIImage *image = cell.imageImageVeiw.image;
    
    HXSDormItemMaskDatasource *datasource = [[HXSDormItemMaskDatasource alloc] init];
    datasource.image = image;
    datasource.initialImageFrame = frame;
    datasource.item = item;
    datasource.shopEntity = self.shopEntity;
    
    HXSDormItemMaskView *itemMaskView = [[HXSDormItemMaskView alloc] initWithDataSource:datasource delegate:self];
    
    [[AppDelegate sharedDelegate].window addSubview:itemMaskView];
    [itemMaskView show];
}

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event
{
    [self onStartEvent:event];
}

- (void)listConllectionViewCell:(HXSDormListVerticalCollectionViewCell *)cell udpateItem:(NSNumber *)cartItemIDNum quantity:(NSNumber *)quantityNum
{
    [[HXSDormCartManager sharedManager] updateItem:cartItemIDNum quantity:[quantityNum intValue]];
}

- (void)listConllectionViewCell:(HXSDormListVerticalCollectionViewCell *)cell addRid:(NSNumber *)ridNum quantity:(NSNumber *)quantityNum
{    
    [[HXSDormCartManager sharedManager] addItem:ridNum quantity:[quantityNum intValue]];
}


#pragma mark - IndexPath Of DataSource

- (NSInteger)countOfItemsInIndex:(NSInteger)index
{
    NSInteger count = 0;
    
    for (int i = 0; i < index; i++) {
        HXSDormCategory *cate = [self.itemList.itemCategoryList objectAtIndex:i];
        count += [cate.sortedItems count];
    }
    
    return count;
}

- (NSInteger)sectionOfCategoryInRow:(NSInteger)row
{
    NSInteger section = 0;
    NSInteger count = 0;
    
    for (int i = 0; i < [self.itemList.itemCategoryList count]; i++) {
        HXSDormCategory *cate = [self.itemList.itemCategoryList objectAtIndex:i];
        count += [cate.sortedItems count];
        
        if (row < count) {
            section = i;
            break;
        }
    }
    
    return section;
}


#pragma mark - clickevent delegate

- (void)onStartEvent:(HXSClickEvent *)event
{
    if(event.eventUrl && event.eventUrl.length > 0){
        [MobClick event:@"dorm_click_event" attributes:@{@"url":event.eventUrl}];
        
        HXSWebViewController * webViewController = [HXSWebViewController controllerFromXib];
        [webViewController setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",event.eventUrl]]];
        webViewController.title = event.title;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}


#pragma mark - Setter Getter Methods

- (void)setItemList:(HXSDormItemList *)itemList
{
    _itemList = itemList;
    
    self.dataSource = nil;
    
    NSMutableArray *tempMArr = [[NSMutableArray alloc] initWithCapacity:5];
    
    [tempMArr addObjectsFromArray:self.itemList.itemList];
    
    self.dataSource = tempMArr;
}

@end
