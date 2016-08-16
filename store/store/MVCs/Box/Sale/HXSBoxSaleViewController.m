//
//  HXSBoxSaleViewController.m
//  store
//
//  Created by ArthurWang on 16/5/24.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

#import "HXSBoxSaleViewController.h"
#import "HXSBoxMacro.h"
// Controllers
#import "HXSBoxCheckOutViewController.h"

// Model
#import "HXSBoxCarManager.h"
#import "HXSBoxInfoEntity.h"
#import "HXSBoxModel.h"
#import "HXSBoxOrderModel.h"
#import "HXSFloatingCartEntity.h"

// Views
#import "HXSBoxOwnerInfoView.h"
#import "HXSBoxSnacksTableViewCell.h"
#import "HXSnacksCarView.h"
#import "HXSDormItemMaskView.h"
#import "HXSFloatingCartView.h"

static NSString * const BoxSnacksTableViewCell = @"HXSBoxSnacksTableViewCell";
static CGFloat const SnacksCarViewHeight = 44.0f;
static CGFloat const CellHeight = 100.0f;



@interface HXSBoxSaleViewController ()< UITableViewDelegate,
                                        UITableViewDataSource,
                                        HXSFoodieItemPopViewDelegate,
                                        HXSFloatingCartViewDelegate>


@property (nonatomic, strong) HXSBoxCarManager    *boxCarManager;
@property (nonatomic, strong) MASConstraint       *bottomConstraint;
@property (nonatomic, strong) HXSBoxInfoEntity    *boxInfoEntity;
@property (nonatomic, strong) HXSFloatingCartView *floatingCartView;//购物车清单
@property (nonatomic, strong) NSMutableArray      *boxModelList;

@property (nonatomic, copy) void (^refreshBoxInfo)(void);

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet HXSnacksCarView    *snacksCarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *snacksCarViewBottomContraint;
@property (nonatomic, strong) HXSBoxOwnerInfoView *boxOwnerInfoView;

@end

@implementation HXSBoxSaleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initialNav];
    [self initTableView];
    [self initSubViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self fetBoxItemsList];
    
    if (![self.boxCarManager isEmpty])
    {
        [self showSnackBoxCarView];
    }
    else
    {
        [self hiddenSnackBoxCarView];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self hiddenSnackBoxCarView];
}


- (void)dealloc
{
    self.snacksCarView = nil;
    self.boxCarManager = nil;
    self.boxModelList  = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initialNav{
    self.navigationItem.title = @"零食盒";
    self.parentViewController.navigationItem.title = @"零食盒";
}

#pragma mark - Net

- (void)fetBoxInfo{
    [HXSLoadingView showLoadingInView:self.view];
    WS(weakSelf);
    [HXSBoxModel fetchBoxInfo:^(HXSErrorCode code, NSString *message, HXSBoxInfoEntity *boxInfoEntity) {
        [HXSLoadingView closeInView:weakSelf.view];
        if(kHXSNoError == code){
            weakSelf.boxInfoEntity = boxInfoEntity;
            [weakSelf.boxOwnerInfoView initialBoxInfo:boxInfoEntity];
            [weakSelf fetBoxItemsList];
        }else{
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:message afterDelay:1.5];
        }
    }];

}

/**
 *  获取商品信息
 */
- (void)fetBoxItemsList
{
    WS(weakSelf);
    
    [HXSLoadingView showLoadingInView:self.view];
    [HXSBoxModel fetBoxItemListWithBoxId:self.boxInfoEntity.boxIdNum
                                 batchNo:self.boxInfoEntity.batchNoNum
                                complete:^(HXSErrorCode code, NSString *message, NSArray *itemList) {
                                    [HXSLoadingView closeInView:weakSelf.view];
        if (code == kHXSNoError)
        {
            if (weakSelf.boxModelList.count > 0)
            {
                [weakSelf.boxModelList removeAllObjects];
            }
            
            [weakSelf.boxModelList addObjectsFromArray:itemList];
            [weakSelf.tableView reloadData];
        }
        else
        {
           [MBProgressHUD showInView:weakSelf.view
                          customView:nil
                              status:message
                          afterDelay:0.3f];
        }
    }];

}


#pragma mark - Public Methods

+ (instancetype)createBoxSaleVCWithBoxInfo:(HXSBoxInfoEntity *)boxInfoEntity refresh:(void (^)(void))refreshBoxInfo
{
    HXSBoxSaleViewController *boxSaleVC = [HXSBoxSaleViewController controllerFromXib];
    
    boxSaleVC.boxInfoEntity  = boxInfoEntity;
    boxSaleVC.refreshBoxInfo = refreshBoxInfo;
    
    return boxSaleVC;
}

- (void)refresh
{
    [self fetBoxInfo];
}


- (void)initTableView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.boxOwnerInfoView];
    
    self.boxOwnerInfoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    UINib *cellNib = [UINib nibWithNibName:BoxSnacksTableViewCell bundle:nil];
    self.tableView.backgroundView = [UIView new];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:BoxSnacksTableViewCell];
    [self.tableView setTableHeaderView:headerView];
    [self.tableView setTableFooterView:[UIView new]];

    [self.boxOwnerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
}

- (void)initSubViews
{
    WS(weakSelf);
    
    [self.snacksCarView setCarButtonClickBlock:^
     {
         [HXSUsageManager trackEvent:kUsageEventBoxBottomCar parameter:nil];
         [weakSelf showSnackBoxList];
     }];
    
    [self.snacksCarView setCheckButtonClickBlock:^{
        [weakSelf.floatingCartView hide:YES];
        [weakSelf chekoutAction];
    }];
    
    [self.view addSubview:self.floatingCartView];
}

- (void)updateCarManager
{
    NSMutableArray *floatingCartEntityArray = [NSMutableArray array];
    
    for (HXSBoxOrderItemModel *boxItemModel in [self.boxCarManager getBoxAllItems])
    {
        HXSFloatingCartEntity *floatingCartEntity = [[HXSFloatingCartEntity alloc] initWithBoxItem:boxItemModel];
        [floatingCartEntityArray addObject:floatingCartEntity];
    }
    
    [self.floatingCartView setItemsArray:floatingCartEntityArray];
    [[NSNotificationCenter defaultCenter] postNotificationName:kStoreCartDidUpdated object:@(YES)];
}


#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.boxModelList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    
    NSInteger row = [indexPath row];
    HXSBoxOrderItemModel *boxItemModel = self.boxModelList[row];
    
    HXSBoxSnacksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BoxSnacksTableViewCell
                                                                      forIndexPath:indexPath];
    [cell initSubViews];
    [cell setBoxItemModel:boxItemModel];
    cell.boxCarManager = self.boxCarManager;
    [cell setUpdateSnackBoxCarBlock:^
    {
        [weakSelf updateSnackBoxCar];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSBoxSnacksTableViewCell *boxSnacksTableViewCell = (HXSBoxSnacksTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    HXSBoxOrderItemModel *item = self.boxModelList[indexPath.row];
    [HXSUsageManager trackEvent:kUsageEventBoxShowGoodsDetails parameter:@{@"goods_name":item.nameStr,
                                                                                   @"goods_image":item.imageMediumStr}];
    
    CGRect frame = boxSnacksTableViewCell.goodsImageView.frame;
    frame = [boxSnacksTableViewCell convertRect:frame toView:[AppDelegate sharedDelegate].window];
    
    HXSDormItemMaskDatasource *dataSource = [[HXSDormItemMaskDatasource alloc] init];
    dataSource.image = boxSnacksTableViewCell.goodsImageView.image;
    dataSource.initialImageFrame = frame;
    dataSource.boxItemModel = item;
    
    HXSDormItemMaskView *itemMaskView = [[HXSDormItemMaskView alloc] initWithDataSource:dataSource delegate:self];
    [[AppDelegate sharedDelegate].window addSubview:itemMaskView];
    [itemMaskView show];
}

#pragma mark UpdateCart

/**
 *  更新购物车
 */
- (void)updateSnackBoxCar
{
    [self.snacksCarView setBoxCarManager:self.boxCarManager];
    
    if (![self.boxCarManager isEmpty])
    {
        [self showSnackBoxCarView];
    }
    else
    {
        [self hiddenSnackBoxCarView];
    }
    [self.tableView reloadData];
}


/**
 *  显示购物车
 */
- (void)showSnackBoxCarView
{
    self.snacksCarViewBottomContraint.constant = 0;
    
    [UIView animateWithDuration:0.5 animations:^
    {
        [self.view layoutIfNeeded];
    }];
}

/**
 *  隐藏购物车
 */

- (void)hiddenSnackBoxCarView
{
    self.snacksCarViewBottomContraint.constant = - SnacksCarViewHeight;
    
    [UIView animateWithDuration:0.5 animations:^
    {
        [self.view layoutIfNeeded];
    }];
}


/**
 *  显示购物车零食清单
 */
- (void)showSnackBoxList
{
    if (!self.floatingCartView || !self.floatingCartView.superview)
    {
        self.floatingCartView = [HXSFloatingCartView viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.snacksCarView.height)];
        self.floatingCartView.cartViewDelegate = self;
        [self setupCartViewItems];
        
        NSMutableArray *floatingCartEntityArray = [NSMutableArray array];
        
        for (HXSBoxOrderItemModel *boxItemModel in [self.boxCarManager getBoxAllItems])
        {
            HXSFloatingCartEntity *floatingCartEntity = [[HXSFloatingCartEntity alloc] initWithBoxItem:boxItemModel];
            [floatingCartEntityArray addObject:floatingCartEntity];
        } 
        
        [self.floatingCartView setItemsArray:floatingCartEntityArray];
        
        [self.floatingCartView show];
    }
}

/**
 *  结算
 */
- (void)chekoutAction
{
    [HXSUsageManager trackEvent:kUsageEventBoxCheckButton parameter:nil];
    
    HXSBoxRelatedEntity *boxOwnerModel = self.boxInfoEntity.boxerInfo;
    HXSBoxCheckOutViewController *boxCheckOutViewController = [[HXSBoxCheckOutViewController alloc]
                                                               initViewControllerWithBoxId:self.boxInfoEntity.boxIdNum
                                                               boxOwnerName:boxOwnerModel.userNameStr];
    [self.navigationController pushViewController:boxCheckOutViewController animated:YES];
}

- (void)setupCartViewItems
{
    NSMutableArray *floatingItemsMArr = [NSMutableArray array];
    for (HXSBoxOrderItemModel *boxOrderItemModel in [[HXSBoxCarManager sharedManager] getBoxAllItems])
    {
        HXSFloatingCartEntity *entity = [[HXSFloatingCartEntity alloc] initWithBoxItem:boxOrderItemModel];
        [floatingItemsMArr addObject:entity];
    }
}

#pragma mark  - HXSFoodieItemPopViewDelegate

- (void)boxItemUpdate:(NSString *)productIDStr quantity:(NSInteger)quantity
{
    HXSBoxOrderItemModel *boxOrderItem;
    for (HXSBoxOrderItemModel *boxOrderItemModel in _boxModelList)
    {
        if([boxOrderItemModel.productIdStr isEqualToString:productIDStr])
        {
            boxOrderItem = boxOrderItemModel;
            break;
        }
    }
 
    if (boxOrderItem)
    {
        [[HXSBoxCarManager sharedManager] updateCartWithItem:boxOrderItem];
    }

    [self updateProduct:productIDStr quantity:@(quantity)];
}

- (void)dormItemTableViewCellDidClickEvent:(HXSClickEvent *)event
{
    
}


#pragma mark  - HXSFloatingCartViewDelegate

- (void)updateItem:(NSNumber *)itemIDNum
          quantity:(NSNumber *)quantityNum
{

}

- (void)updateProduct:(NSString *)productIDStr
             quantity:(NSNumber *)quantityNum
{
    if (self.boxCarManager.totalCount.integerValue > quantityNum.integerValue)
    {
        [HXSUsageManager trackEvent:kUsageEventBoxCarReduce parameter:nil];
    }
    else
    {
        [HXSUsageManager trackEvent:kUsageEventBoxCarAdd parameter:nil];
    }
    HXSBoxOrderItemModel *boxItemModel = [[HXSBoxOrderItemModel alloc] init];
    boxItemModel.quantityNum  = quantityNum;
    boxItemModel.productIdStr = productIDStr;
    [self.boxCarManager updateCartWithItem:boxItemModel];
    
    if ([self.boxCarManager.totalCount integerValue] == 0)
    {
        [self.floatingCartView hide:YES];
    }
    [self updateSnackBoxCar];
    [self updateCarManager];
    [self.tableView reloadData];
}

- (void)clearCart
{
    [HXSUsageManager trackEvent:kUsageEventBoxClearCar parameter:nil];
    [self.boxCarManager emptyCart];
    [self updateSnackBoxCar];
    [self.tableView reloadData];
}

#pragma mark - GET SET

- (HXSBoxOwnerInfoView *)boxOwnerInfoView
{
    if (!_boxOwnerInfoView)
    {
        _boxOwnerInfoView = [HXSBoxOwnerInfoView initFromXib];
        [_boxOwnerInfoView initialBoxInfo:_boxInfoEntity];
    }
    return _boxOwnerInfoView;
}

- (HXSBoxCarManager *)boxCarManager
{
    if (!_boxCarManager)
    {
        _boxCarManager = [HXSBoxCarManager sharedManager];
    }
    return _boxCarManager;
}

- (NSMutableArray *)boxModelList
{
    if (!_boxModelList)
    {
        _boxModelList = [NSMutableArray array];
    }
    return _boxModelList;
}

@end
