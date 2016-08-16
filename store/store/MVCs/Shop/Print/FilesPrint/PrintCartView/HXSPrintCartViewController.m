//
//  HXSPrintCartViewController.m
//  store
//
//  Created by J006 on 16/3/30.
//  Copyright © 2016年 huanxiao. All rights reserved.
//

//controller
#import "HXSPrintCartViewController.h"
#import "HXSPrintSettingViewController.h"
#import "HXSPrintCheckoutViewController.h"
#import "HXSShopInfoViewController.h"

//view
#import "HXSPrintCartTableViewCell.h"
#import "HXSActionSheet.h"

//model
#import "HXSMyPrintOrderItem.h"
#import "HXSPrintCartEntity.h"
#import "HXSPrintSettingViewModel.h"
#import "HXSPrintFilesManager.h"

@interface HXSPrintCartViewController ()<HXSPrintSettingViewControllerDelegate>

/**店铺名称*/
@property (weak, nonatomic) IBOutlet UILabel                        *shopNameLabel;
@property (weak, nonatomic) IBOutlet UITableView                    *mainTableView;
/**合计共计页数*/
@property (weak, nonatomic) IBOutlet UILabel                        *totalPagesNumsLabel;
/**合计价格*/
@property (weak, nonatomic) IBOutlet UILabel                        *totalPriceLabel;
/**确认订单*/
@property (weak, nonatomic) IBOutlet UIButton                       *confirmOrderButton;
@property (weak, nonatomic) IBOutlet UIView                         *topView;
@property (nonatomic, strong) HXSShopEntity                         *shop;
/**购物车*/
@property (nonatomic, strong) NSMutableArray<HXSMyPrintOrderItem *> *cartArray;
/**提交的购物车entity*/
@property (nonatomic, strong) HXSPrintCartEntity                    *printCartEntity;
/**弹出的店铺信息*/
@property (nonatomic, strong) HXSShopInfoViewController             *shopInfoVC;
/**是否已经淡出店铺信息*/
@property (nonatomic, assign) BOOL                                  hasDisplayShopInfoView;
@property (nonatomic, strong) HXSActionSheet                        *actionSheet;
/**待删除文件*/
@property (nonatomic, strong) HXSMyPrintOrderItem                   *needToBeRemovedEntity;
/**打印设置*/
@property (nonatomic, strong) HXSPrintTotalSettingEntity            *settingEntity;
@property (nonatomic, strong) HXSPrintFilesManager                  *printFilesManager;

@end

@implementation HXSPrintCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    
    [self initTheShopName];
    
    [self initTheShopVCInfor];
    
    [self initTableView];
    
    [self fetchThePrintSettingNetworking];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mainTableView reloadData];
    
    [self checkTheCartView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - init

- (void)initPrintCartViewWithShopEntity:(HXSShopEntity *)shopEntity
                       andWithCartArray:(NSMutableArray *)cartArray;
{
    _shop               = shopEntity;
    _cartArray          = cartArray;
}

/**
 *  初始化导航栏
 */
- (void)initNavigationBar
{
    self.navigationItem.title = @"购物车";
}

/**
 *  初始化商店名称
 */
- (void)initTheShopName
{
    if(_shop) {
        [_shopNameLabel setText:_shop.shopNameStr];
    }
}

/**
 *  初始化tableview
 */
- (void)initTableView
{
    [_mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([HXSPrintCartTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HXSPrintCartTableViewCell class])];
}

/**
 *  初始化并设置底部购物车的价格
 */
- (void)initTheCart
{
    [self checkTheCartView];
}

/**
 *  为购物车中每一个商品设置默认打印类型
 */
- (void)initTheSettingEntityForCart
{
    if(!_settingEntity || !_cartArray || _cartArray.count == 0) {
        return;
    }
    
    HXSPrintSettingEntity        *defaultPrintEntity  = [_settingEntity.printSettingArray objectAtIndex:0];
    HXSPrintSettingReducedEntity *defaultReduceEntity = [_settingEntity.reduceSettingArray objectAtIndex:0];
    
    
    for (HXSMyPrintOrderItem *orderItem in _cartArray) {
        orderItem.currentSelectSetPrintEntity  = defaultPrintEntity;
        orderItem.currentSelectSetReduceEntity = defaultReduceEntity;
        orderItem.reducedTypeIntNum            = defaultReduceEntity.reduceedTypeNum;
        orderItem.printTypeIntNum              = defaultPrintEntity.printTypeNum;
        orderItem.quantityIntNum               = [NSNumber numberWithInteger:1];
        
        [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPrice:orderItem];
    }
}

/**
 *  初始化店铺下拉信息
 */
- (void)initTheShopVCInfor
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(onClickTopView:)];
    [_topView addGestureRecognizer:tapGesture];
}

/**
 *  店铺名称点击或者店铺信息点击的事件
 *
 *  @param button
 */
- (void)onClickTopView:(UITapGestureRecognizer *)tap
{
    if (self.hasDisplayShopInfoView) {
        [_shopInfoVC dismissView];
    } else {
        __weak typeof(self) weakSelf = self;
        self.shopInfoVC.shopEntity = _shop;
        _shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];
            weakSelf.hasDisplayShopInfoView = NO;
        };
        [self addChildViewController:_shopInfoVC];
        [self.view addSubview:_shopInfoVC.view];
        [_shopInfoVC.view mas_remakeConstraints:^(MASConstraintMaker *make)
         {
             make.edges.equalTo(self.view);
         }];
        
        [_shopInfoVC didMoveToParentViewController:self];
        _hasDisplayShopInfoView = YES;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    if(_cartArray && [_cartArray count] && _settingEntity) {
        rows = [_cartArray count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXSPrintCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HXSPrintCartTableViewCell class]) forIndexPath:indexPath];
    HXSMyPrintOrderItem *entity = [_cartArray objectAtIndex:indexPath.row];
    [cell initPrintCartTableViewCellWithEntity:entity andType:kHXSPrintCartCellSettingTypeDoc];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self jumpToSettingViewWithEntity:[_cartArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.actionSheet show];
        _needToBeRemovedEntity = [_cartArray objectAtIndex:indexPath.row];
    }
}


#pragma mark - HXSPrintSettingViewControllerDelegate

- (void)confirmCartWithOrderItem:(HXSMyPrintOrderItem *)entity
andWithPrintDownloadsObjectEntity:(HXSPrintDownloadsObjectEntity *)objectEntity
{
    NSInteger index = [_cartArray indexOfObject:entity];
    NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [indexPathArray addObject:indexPath];
    
    [_mainTableView beginUpdates];
    [_mainTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
    [_mainTableView endUpdates];
    
    [self.printFilesManager checkTheCurrentSettingAndGetTheTotalPrice:entity];
    
    [self checkTheCartView];
}


#pragma mark - DeleteTheEntity

- (void)deleteSheetAction
{
    [self removedFromCartWithEntity:_needToBeRemovedEntity];
}

- (void)removedFromCartWithEntity:(HXSMyPrintOrderItem *)entity
{
    NSInteger index = [_cartArray indexOfObject:entity];
    
    [_cartArray removeObject:entity];
    
    entity.isAddToCart = NO;
    
    if(_cartArray.count == 0) {
        [_mainTableView reloadData];
    } else {
        [_mainTableView beginUpdates];
        NSMutableArray<NSIndexPath *> * indexPathArray = [[NSMutableArray alloc]init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [indexPathArray addObject:indexPath];
        [_mainTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        [_mainTableView endUpdates];
    }
    
    [self checkTheCartView];
}


#pragma mark - networking

/**
 *  网络连接获取打印设置
 */
- (void)fetchThePrintSettingNetworking
{
    HXSPrintSettingViewModel *model = [[HXSPrintSettingViewModel alloc]init];
    __weak __typeof(self)weakSelf = self;
    [MBProgressHUD showInView:self.view];
    
    [model fetchPrintSettingWithShopId:_shop.shopIDIntNum
                              Complete:^(HXSErrorCode status, NSString *message, HXSPrintTotalSettingEntity *entity) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(entity) {
            weakSelf.settingEntity = entity;
            
            [weakSelf initTheSettingEntityForCart];
            
            [weakSelf.mainTableView reloadData];
            
            [weakSelf initTheCart];
        }
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (weakSelf.view) {
            [MBProgressHUD showInViewWithoutIndicator:weakSelf.view status:errorMessage afterDelay:1.5];
        }
    }];
    
}


#pragma mark - Button Action

/**
 *  确认订单
 *
 *  @param sender
 */
- (IBAction)confirmOrderAction:(id)sender
{
    if(!_cartArray || [_cartArray count] == 0) {
        NSString *noCartStr = @"购物车中没有商品,无法确认订单~";
        if (self.view) {
            [MBProgressHUD showInViewWithoutIndicator:self.view status:noCartStr afterDelay:1.5];
        }
        return;
    }
    
    HXSPrintCheckoutViewController *checkoutViewController = [HXSPrintCheckoutViewController controllerFromXib];
    [checkoutViewController initPrintCheckoutViewControllerWithEntity:_printCartEntity andWithShopEntity:_shop];
    __weak typeof(self) weakSelf = self;
    checkoutViewController.clearPrintStoreCart = ^{
        for (HXSMyPrintOrderItem *orderItem in weakSelf.cartArray) {
            orderItem.isAddToCart = NO;
        }
        [weakSelf.cartArray removeAllObjects];
        
        NSMutableArray *arr =[NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
        NSInteger indexPrev = [arr indexOfObject:weakSelf] - 1;
        [arr removeObject:[arr objectAtIndex:indexPrev]];
        [arr removeObject:weakSelf];
        weakSelf.navigationController.viewControllers = arr;
    };
    [self.navigationController pushViewController:checkoutViewController animated:YES];
}


#pragma mark - JumpAction

/**
 *  跳转到设置界面
 *
 *  @param entity
 */
- (void)jumpToSettingViewWithEntity:(HXSMyPrintOrderItem *)entity
{
    HXSPrintSettingViewController *printSettingVC = [HXSPrintSettingViewController controllerFromXib];
    [printSettingVC initPrintSettingViewControllerWithEntity:entity
                                                 andWithShop:_shop
                                            andWithCartArray:_cartArray
                           andWithPrintDownloadsObjectEntity:nil
                                                     andType:HXSPrintCartSettingTypeDoc];
    printSettingVC.delegate = self;
    
    self.definesPresentationContext = YES;
    [printSettingVC.view setBackgroundColor:[UIColor clearColor]];
    printSettingVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:printSettingVC animated:YES completion:nil];
}


#pragma mark - checkCart

/**
 *  检查并计算所有打印页面的总数和价格
 */
- (void)checkTheCartView
{
    NSInteger totalPage = 0;
    double totalPrice = 0.00;
    
    if(!_cartArray || _cartArray.count ==0 || !_settingEntity) {
        [_confirmOrderButton setEnabled:NO];
    } else {
        [_confirmOrderButton setEnabled:YES];
        for (HXSMyPrintOrderItem *orderItem in _cartArray) {
            NSInteger pageReduceIntNum  = [orderItem.pageReduceIntNum integerValue];
            NSInteger quantityNum = [orderItem.quantityIntNum integerValue];
            NSInteger temptotalPageNums = pageReduceIntNum * quantityNum;
            double tempPrice = [orderItem.amountDoubleNum doubleValue];
            totalPage  += temptotalPageNums;
            totalPrice += tempPrice;
        }
    }

    [_totalPagesNumsLabel setText:[NSString stringWithFormat:@"%ld页",(long)totalPage]];
    [_totalPriceLabel setText:[NSString stringWithFormat:@"¥%.2f",totalPrice]];
    self.printCartEntity.itemsArray = (NSMutableArray<HXSMyPrintOrderItem> *)_cartArray;
    NSNumber *totalPriceNumber = [[NSNumber alloc]initWithDouble:totalPrice];
    NSNumber *totalPageNumber  = [[NSNumber alloc]initWithInteger:totalPage];
    _printCartEntity.totalAmountDoubleNum    = totalPriceNumber;
    _printCartEntity.deliveryAmountDoubleNum = totalPriceNumber;
    _printCartEntity.documentAmountDoubleNum = totalPriceNumber;
    _printCartEntity.printPagesIntNum        = totalPageNumber;
    _printCartEntity.shopIdIntNum = [_shop shopIDIntNum];
    
}


#pragma mark - getter setter

- (HXSPrintCartEntity *)printCartEntity
{
    if(!_printCartEntity) {
        _printCartEntity = [[HXSPrintCartEntity alloc]init];
        _printCartEntity.docTypeNum = @(HXSPrintDocumentTypeOther);
    }
    return _printCartEntity;
}

- (HXSShopInfoViewController *)shopInfoVC
{
    if (!_shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXib];
    }
    
    return _shopInfoVC;
}

- (HXSActionSheet *)actionSheet
{
    if(!_actionSheet) {
        HXSActionSheetEntity *deleteEntity = [[HXSActionSheetEntity alloc] init];
        deleteEntity.nameStr = @"删除";
        __weak typeof(self) weakSelf = self;
        HXSAction *deleteAction = [HXSAction actionWithMethods:deleteEntity
                                                       handler:^(HXSAction *action){
                                                           [weakSelf deleteSheetAction];
                                                           
                                                       }];
        
        _actionSheet = [HXSActionSheet actionSheetWithMessage:@"确定将该文件从购物车中删除?"
                                            cancelButtonTitle:@"取消"];
        [_actionSheet addAction:deleteAction];
    }
    return _actionSheet;
}

- (HXSPrintFilesManager *)printFilesManager
{
    if(!_printFilesManager) {
        _printFilesManager = [[HXSPrintFilesManager alloc]init];
    }
    return _printFilesManager;
}

@end
