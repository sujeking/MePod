//
//  HXSDigitalMobileHotViewController.m
//  store
//
//  Created by ArthurWang on 16/3/10.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSDigitalMobileHotViewController.h"

// Controllers
#import "HXSDigitalMobileDetailViewController.h"
// Model
#import "HXSDigitalMobileModel.h"
// Views
#import "HXSDigitalMobileCollectionViewCell.h"

#define TAG_BASIC  1000

@interface HXSDigitalMobileHotViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) HXSDigitalMobileModel *digitalMobileModel;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) CGFloat beginningOffsetY;

@end

@implementation HXSDigitalMobileHotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initialCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.updateSelectionTitle(self.index);
    
    if (0 >= [self.dataSource count]) {
        [HXSLoadingView showLoadingInView:self.view];
        
        [self fetchItemData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.collectionView endRefreshing];
    [HXSLoadingView closeInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.updateSelectionTitle = nil;
    self.scrollviewScrolled   = nil;
}


#pragma mark - Initial Methods

- (void)initialCollectionView
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSDigitalMobileCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([HXSDigitalMobileCollectionViewCell class])];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addRefreshHeaderWithCallback:^{
        [weakSelf fetchItemData];
    }];
}


#pragma mark - Setter Getter Methods

- (HXSDigitalMobileModel *)digitalMobileModel
{
    if (nil == _digitalMobileModel) {
        _digitalMobileModel = [[HXSDigitalMobileModel alloc] init];
    }
    
    return _digitalMobileModel;
}


#pragma mark - Fetch Data

- (void)fetchItemData
{
    __weak typeof(self) weakSelf = self;
    [self.digitalMobileModel fetchHotItems:^(HXSErrorCode status, NSString *message, NSArray *itemsArr) {
        [weakSelf.collectionView endRefreshing];
        [HXSLoadingView closeInView:weakSelf.view];
        
        if (kHXSNoError != status) {
            if (weakSelf.isFirstLoading) {
                [HXSLoadingView showLoadFailInView:weakSelf.view
                                             block:^{
                                                 [weakSelf fetchItemData];
                                             }];
            } else {
                [MBProgressHUD showInViewWithoutIndicator:weakSelf.view
                                                   status:message
                                               afterDelay:1.5f];
            }
            
            return ;
        }
        
        weakSelf.firstLoading = NO;
        
        weakSelf.dataSource = itemsArr;
        
        [weakSelf.collectionView reloadData];
    }];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 3 * 10) / 2; // 10 is padding, 2 is number of item in one line
    CGFloat height = width * 260.0 / 180;  // 180 * 260
    
    return CGSizeMake(width, height);
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HXSDigitalMobileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HXSDigitalMobileCollectionViewCell class]) forIndexPath:indexPath];
    
    HXSDigitalMobileItemListEntity *listEntity = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell setupCellWithEntity:listEntity];
    
    // add target
    cell.buyBtn.tag = TAG_BASIC + indexPath.row;
    [cell.buyBtn addTarget:self
                    action:@selector(onClickBuyBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HXSDigitalMobileItemListEntity *listEntity = [self.dataSource objectAtIndex:indexPath.row];
    
    [self jumpToDetailVCWithItemID:listEntity.itemIDIntNum];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginningOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (0 < scrollView.contentSize.height) {
        if (nil != self.scrollviewScrolled) {
            self.scrollviewScrolled(CGPointMake(0, scrollView.contentOffset.y - self.beginningOffsetY));
        }
    }
}


#pragma mark - Target Methods

- (void)onClickBuyBtn:(UIButton *)button
{
    NSInteger tag = button.tag - TAG_BASIC;
    
    HXSDigitalMobileItemListEntity *listEntity = [self.dataSource objectAtIndex:tag];
    
    [self jumpToDetailVCWithItemID:listEntity.itemIDIntNum];
}

- (void)jumpToDetailVCWithItemID:(NSNumber *)itemIDIntNum
{
    HXSDigitalMobileDetailViewController *detailVC = [HXSDigitalMobileDetailViewController controllerFromXib];
    
    detailVC.itemIDIntNum = itemIDIntNum;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
