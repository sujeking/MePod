//
//  HXSDormMainViewController.m
//  store
//
//  Created by chsasaw on 15/1/23.
//  Copyright (c) 2015年 huanxiao. All rights reserved.
//

#import "HXSDormMainViewController.h"
#import "HXSShop.h"

// Controllers
#import "HXSShopInfoViewController.h"
#import "HXSWebViewController.h"
#import "HXSDormListHorizontalViewController.h"
#import "HXSDormListVerticalViewController.h"

// Model
#import "HXSSite.h"
#import "HXSDormItem.h"
#import "HXSDormCategory.h"
#import "HXSDormItemList.h"
#import "HXSDormCartManager.h"
#import "HXSFloatingCartEntity.h"
#import "HXSOrderRequest.h"
#import "HXSAlipayManager.h"
#import "HXSBuildingEntry.h"
#import "HXSCategoryModel.h"
#import "HXSShopViewModel.h"

// Views
#import "MIBadgeButton.h"
#import "HXSDormCart.h"
#import "HXSFloatingCartView.h"
#import "HXSCoupon.h"
#import "HXSCheckoutViewController.h"
#import "HXSLocationCustomButton.h"
#import "HXSNoticeView.h"
#import "HXSShopCategoryToolView.h"
#import "HXSLoadingView.h"

// Others
#import "HXSShopManager.h"

static NSInteger const kHeightScrollTabBar = 40;

//每页请求的商品的个数
static NSInteger const kPerPageCount = 10;

@interface HXSDormMainViewController () <HXSItemListDelegate,
                                         HXSDormListHorizontalViewControllerDelegate,
                                         HXSDormListVerticalViewControllerDelegate,
                                         HXSFloatingCartViewDelegate>



@property (weak, nonatomic) IBOutlet UIView *listContentView;
@property (nonatomic, weak) IBOutlet JCRBlurView   *blurView;
@property (nonatomic, weak) IBOutlet MIBadgeButton *cartButton;
@property (nonatomic, weak) IBOutlet UILabel       *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel       *promotionLabel;
@property (nonatomic, weak) IBOutlet UIButton      *checkoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeListTypeBtn;

@property (nonatomic, weak) IBOutlet UIView *noticeView;
@property (nonatomic, weak) IBOutlet HXSShopCategoryToolView *shopCategoryToolView;
@property (weak, nonatomic) IBOutlet UIView *dontOpenView;
@property (weak, nonatomic) IBOutlet UIButton *openDormStoreBtn;
@property (weak, nonatomic) IBOutlet HXSNoticeView *noticeAndActivitiesView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint  *topViewTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalAmountTopConstraint;

@property (nonatomic, strong) NSNumber *shopIDIntNum;
@property (nonatomic, strong) HXSShopEntity *shopEntity;

@property (nonatomic, assign) BOOL    autoScrolling;
@property (nonatomic, assign) BOOL    isAnimating;
@property (nonatomic, assign) BOOL    isHidden;

@property (nonatomic, strong) HXSDormItemList *itemList;

@property (nonatomic, strong) HXSFloatingCartView *cartView;

@property (nonatomic, strong) UIView * noticeDetailView;

// Sub VCs
@property (nonatomic, strong) HXSDormListHorizontalViewController *listHorizontalVC;
@property (nonatomic, strong) HXSDormListVerticalViewController   *listVerticalVC;
@property (nonatomic, strong) UIViewController                    *currentVC;

@property (nonatomic, strong) NSArray                       *dormEntryOpenArr;
@property (nonatomic, strong) HXSLocationCustomButton       *locationButton;
@property (nonatomic, strong) HXSShopInfoViewController     *shopInfoVC;

@property (nonatomic, assign) BOOL                       hasDisplayShopInfoView;

@property (nonatomic, assign) int fromPage;                          //从第几页开始请求
@property (nonatomic, strong) NSNumber *currentCategoryId;           //当前分类的Id
@property (nonatomic, strong) HXSShopViewModel *shopModel;

@end

@implementation HXSDormMainViewController


#pragma mark - View Controller LifeCycle

+ (instancetype)createDromVCWithShopId:(NSNumber *)shopIdIntNum
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HXSDormMainViewController *mainVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"HXSDormMainViewController"];
    
    mainVC.shopIDIntNum = shopIdIntNum;
    
    return mainVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.autoScrolling = NO;
    self.isHidden      = NO;
    self.isAnimating   = NO;
    
    [self initialSubChildViewControllers];
    
    [self setupChangeTypeBtn];
    
    [self initialButtonStatus];
    
    [self initialEventMethods];
    
    [self saveShopEntityToCurrentEntry];

    [self initialNavigationBar];
    
    [self performSelector:@selector(fetchShopInfo) withObject:nil afterDelay:0.5];   // Must fetch shop info
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MobClick event:@"dorm_main"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.cartView && self.cartView.superview) {
        [self.cartView hide:NO];
        self.cartView = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.itemList               = nil;
    self.cartView               = nil;
    self.noticeDetailView       = nil;
    self.listHorizontalVC       = nil;
    self.listVerticalVC         = nil;
    self.currentVC              = nil;
    self.dormEntryOpenArr       = nil;
    self.shopCategoryToolView   = nil;
    
}

#pragma mark - override
- (void)turnBack{
    [super turnBack];
    [HXSUsageManager trackEvent:kUsageEventGoodsSelectGoBack parameter:@{@"business_type":@"夜猫店"}];

}
- (void)close{
    [super close];
    [HXSUsageManager trackEvent:kUsageEventGoodsSelectGoBack parameter:@{@"business_type":@"夜猫店"}];
}


#pragma mark - Initial Methods

- (void)initialNavigationBar
{
    if(!self.locationButton) {
        self.locationButton = [HXSLocationCustomButton buttonWithType:UIButtonTypeCustom];
        [self.locationButton addTarget:self action:@selector(onClickTitleView:) forControlEvents:UIControlEventTouchUpInside];
        [self.locationButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
        [self.locationButton setImage:[UIImage imageNamed:@"ic_downwardwhite"] forState:UIControlStateNormal];
    }
    
    [self.locationButton setTitle:self.shopEntity.shopNameStr forState:UIControlStateNormal];
    
    self.navigationItem.titleView = self.locationButton;
    [self.navigationItem.titleView layoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)initialSubChildViewControllers
{
    __weak typeof(self) weakSelf = self;
    _listHorizontalVC = [HXSDormListHorizontalViewController controllerFromXib];
    self.listHorizontalVC.listDelegate = self;
    [self.listHorizontalVC setLoadMoreAction:^{
        //同一分类  加载更多
        weakSelf.fromPage++;
        [weakSelf.itemList fetchCategoryitemsWith:weakSelf.currentCategoryId
                                           shopId:weakSelf.shopIDIntNum
                                     categoryType:weakSelf.categoryModel.categoryType
                                         starPage:@(weakSelf.fromPage)
                                       isLoadMore:YES
                                       numPerPage:@(kPerPageCount)];
        
    }];
    
    [self addChildViewController:self.listHorizontalVC];
    
    _listVerticalVC = [HXSDormListVerticalViewController controllerFromXib];
    self.listVerticalVC.listDelegate = self;
    [self.listVerticalVC setLoadMoreAction:^{
        //同一分类  加载更多
        weakSelf.fromPage++;
        [weakSelf.itemList fetchCategoryitemsWith:weakSelf.currentCategoryId
                                           shopId:weakSelf.shopIDIntNum
                                     categoryType:weakSelf.categoryModel.categoryType
                                         starPage:@(weakSelf.fromPage)
                                       isLoadMore:YES
                                       numPerPage:@(kPerPageCount)];
    }];
    
    
    [self addChildViewController:self.listVerticalVC];
    
    NSNumber *dormTypeNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DORM_LIST_TYPE];
    
    UIViewController *tempVC = nil;
    if (nil == dormTypeNum ||
        (kHXSDormListTypeHorizontal == [dormTypeNum integerValue])) {
        tempVC = self.listHorizontalVC;
    } else {
        tempVC = self.listVerticalVC;
    }
    
    [self.listContentView addSubview:tempVC.view];
    [tempVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.listContentView);
    }];
    
    self.currentVC = tempVC;
    
    [tempVC didMoveToParentViewController:self];
}

- (void)setupChangeTypeBtn
{
    NSNumber *dormTypeNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DORM_LIST_TYPE];
    
    if (nil == dormTypeNum ||
        (kHXSDormListTypeHorizontal == [dormTypeNum integerValue])) {
        [self.changeListTypeBtn setImage:[UIImage imageNamed:@"ic_grid"] forState:UIControlStateNormal];
    } else {
        [self.changeListTypeBtn setImage:[UIImage imageNamed:@"ic_list"] forState:UIControlStateNormal];
    }
    

}


/**
 *  初始化分类菜单
 */
- (void)initialCategoryToolView
{
    __weak typeof(self) weakSelf = self;
    self.fromPage = 1;
    [self.shopCategoryToolView getCategoryItemsWith:self.shopEntity complete:^(HXSCategoryModel *categoryModel) {
        
        if (categoryModel) {

            weakSelf.categoryModel = categoryModel;
            weakSelf.currentCategoryId = weakSelf.categoryModel.categoryId;
            [weakSelf.itemList fetchCategoryitemsWith:weakSelf.categoryModel.categoryId
                                               shopId:weakSelf.shopEntity.shopIDIntNum
                                         categoryType:weakSelf.categoryModel.categoryType
                                             starPage:@(weakSelf.fromPage)
                                           isLoadMore:NO
                                           numPerPage:@(kPerPageCount)];
            
        }
        
    }];
}


- (void)initialButtonStatus
{
    // check out btn    
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:HXS_COLOR_COMPLEMENTARY]
                                forState:UIControlStateNormal];
    [self.checkoutBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                                forState:UIControlStateDisabled];
    [self.checkoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkoutBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateDisabled];
    
    // open store
    self.openDormStoreBtn.layer.masksToBounds = YES;
    self.openDormStoreBtn.layer.cornerRadius  = 4.0f;
}

- (void)initialEventMethods
{
    // blur view
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCart:)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    [self.blurView addGestureRecognizer:gesture];
    
    self.blurView.blurTintColor = UIColorFromRGB(0xF5FBFD);
    
    // notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdated:) name:kUpdateDormCartComplete object:nil];

    self.itemList = [[HXSDormItemList alloc] init];
    self.itemList.delegate = self;
    
    //shopCategoryToolView
    __weak typeof (self) weakSelf = self;
    
    [self.shopCategoryToolView setSelectCategoryType:^(HXSCategoryModel *categoryModel) {

        if (categoryModel) {
            
            [HXSUsageManager trackEvent:kUsageEventFoodTypeChange parameter:@{@"business_type":@"夜猫店",@"type":categoryModel.categoryName}];
            
            weakSelf.fromPage = 1;
            
            weakSelf.categoryModel = categoryModel;
            
            weakSelf.currentCategoryId = categoryModel.categoryId;
            
            [weakSelf reloadDataWith:categoryModel starPage:@(weakSelf.fromPage) limitPage:@(kPerPageCount)];
        }
    }];
}

#pragma mark - Fetch Data Methods

- (void)fetchShopInfo
{
    [HXSLoadingView showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    HXSLocationManager *manager = [HXSLocationManager manager];
    [self.shopModel fetchShopInfoWithSiteId:manager.currentSite.site_id
                                   shopType:@(0)
                                dormentryId:manager.buildingEntry.dormentryIDNum
                                     shopId:self.shopIDIntNum
                                   complete:^(HXSErrorCode status, NSString *message, HXSShopEntity *shopEntity) {
                                       // Don't close loading view now, it will close after fetching the item list.
                                       
                                       if (kHXSNoError != status) {
                                           [HXSLoadingView showLoadFailInView:weakSelf.view
                                                                        block:^{
                                                                            [weakSelf fetchShopInfo];
                                                                        }];
                                           
                                           return ;
                                       }
                                       
                                       weakSelf.shopEntity = shopEntity;
                                       
                                       [weakSelf initialNavigationBar];
                                       
                                       [weakSelf saveShopEntityToCurrentEntry];
                                       
                                       [weakSelf initialCategoryToolView];
                                   }];
}

- (void)reloadDataWith:(HXSCategoryModel *)categoryModel starPage:(NSNumber *)starPage limitPage:(NSNumber *)pageNums
{
    [self.itemList fetchCategoryitemsWith:categoryModel.categoryId
                                   shopId:self.shopIDIntNum
                             categoryType:categoryModel.categoryType
                                 starPage:starPage
                               isLoadMore:NO
                               numPerPage:pageNums
     ];
    
    [HXSUsageManager trackEvent:@"dorm_category" parameter:@{@"title":categoryModel.categoryName}];
}

#pragma mark -

- (void)saveShopEntityToCurrentEntry
{
    HXSShopManager *manager = [HXSShopManager shareManager];
    HXSDormEntry *dormEntry = [[HXSDormEntry alloc] init];
    dormEntry.shopEntity = self.shopEntity;
    
    [manager setCurrentEntry:dormEntry];
}



#pragma mark - Public Methods

- (void)updateDataSource:(BOOL)isMustReload
{
    if (isMustReload
        || (0 >= [self.itemList.itemList count])) {
        
        [self reloadDataShouldAnimation:YES];
        
        [self performSelector:@selector(cartUpdated:) withObject:nil afterDelay:0.3];
    }
}


#pragma mark - View Controller Override Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (self.cartView && self.cartView.superview) {
        self.cartView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.blurView.frame.size.height);
    }
}


#pragma mark - Notification Methods

- (void)cartUpdated:(NSNotification *)noti
{
    // show message
    if (nil != noti) {
        NSNumber *reslut = (NSNumber *)noti.object;
        if ((nil != reslut)
            && (![reslut boolValue])) {
            NSString *message = [noti.userInfo objectForKey:@"msg"];
            
            [MBProgressHUD showInViewWithoutIndicator:self.view status:message afterDelay:1.5f];
        }
    }
    
    HXSDormCart * cart = [[HXSDormCartManager sharedManager] getCartOfCurrentSession];
    
    // update cart view's items
    [self setupCartViewItems];
    
    //一定要刷新   因为有可能在购物车里做了操作
    [self reloadDataShouldAnimation:NO];
    
    self.cartButton.roundLabel = YES;
    [self.cartButton setBadgeEdgeInsets:UIEdgeInsetsMake(20, 10, 0, 28)];
    [self.cartButton setLabelFont:[UIFont systemFontOfSize:10.0f]];
    [self.cartButton setLabelTextColor:[UIColor whiteColor]];
    [self.cartButton setLabelBackGroundColor:HXS_COLOR_COMPLEMENTARY];
    
    
    [self.totalLabel setText:[NSString stringWithFormat:@"¥%.2f", [cart.itemAmount floatValue]]];
    
    if(cart.itemNum.intValue > 0)
        self.cartButton.badgeString = [NSString stringWithFormat:@"%d", cart.itemNum.intValue];
    else
        self.cartButton.badgeString = nil;
    
    if(cart.errorInfo.length > 0) {
        self.promotionLabel.text = cart.errorInfo;
        self.totalAmountTopConstraint.constant = 8;
    }else if(cart.promotion_tip.length > 0) {
        self.promotionLabel.text = cart.promotion_tip;
        self.totalAmountTopConstraint.constant = 8;
    }else {
        self.promotionLabel.text = @"";
        self.totalAmountTopConstraint.constant = 15; // make the label in the center of view
    }
    
    if(MAX(cart.itemAmount.doubleValue, cart.originAmountDoubleNum.doubleValue) >= self.shopEntity.minAmountFloatNum.floatValue && cart.itemNum.intValue > 0) {
        [self.checkoutBtn setBackgroundColor:UIColorFromRGB(0xF78815)];
        self.checkoutBtn.enabled = YES;
        [self.checkoutBtn setTitle:@"结算" forState:UIControlStateNormal];
        [self.checkoutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }else {
        [self.checkoutBtn setBackgroundColor:[UIColor clearColor]];
        self.checkoutBtn.enabled = YES;
        
        if(MAX(cart.itemAmount.doubleValue, cart.originAmountDoubleNum.doubleValue) <= 0.00){
            [self.checkoutBtn setTitle:[NSString stringWithFormat:@"%d 元起送", self.shopEntity.minAmountFloatNum.intValue] forState:UIControlStateNormal];
        }else{
            [self.checkoutBtn setTitle:[NSString stringWithFormat:@"还差 %0.2f 元起送", self.shopEntity.minAmountFloatNum.floatValue - MAX(cart.itemAmount.doubleValue, cart.originAmountDoubleNum.doubleValue)] forState:UIControlStateNormal];
            
        }
        [self.checkoutBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

        self.checkoutBtn.enabled = NO;
    }
}


/**
 *  下拉刷新
 */
- (void)reload
{
    self.fromPage = 1;
    [self.itemList fetchCategoryitemsWith:self.currentCategoryId
                                   shopId:self.shopIDIntNum
                             categoryType:self.categoryModel.categoryType
                                 starPage:@(self.fromPage)
                               isLoadMore:NO
                               numPerPage:@(kPerPageCount)];
}

#pragma mark - HXSDormItemListDelegate

- (void)itemListUpdate:(BOOL)success error:(NSString *)error
{
    __weak typeof(self) weakSelf = self;
    
    [self stopReloadData];
    [[self.listHorizontalVC.tableView infiniteScrollingView] stopAnimating];
    self.listHorizontalVC.tableView.showsInfiniteScrolling = self.itemList.hasMoreItem;
    
    [[self.listVerticalVC.dormItemCollectionView infiniteScrollingView] stopAnimating];
    if(!success) {
        [MBProgressHUD showInViewWithoutIndicator:self.view
                                           status:error
                                       afterDelay:1.5f];
        
        self.autoScrolling = YES;
        
        [self reloadDataShouldAnimation:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.autoScrolling = NO;
        });
    } else {
        [self dismissWarning];
        if(self.noticeView) {
            [[HXSDormCartManager sharedManager] refreshCartInfo];
            
            __weak typeof(self) weakSelf = self;
            [self.noticeAndActivitiesView createWithShopEntity:self.shopEntity targetMethod:^{
                [weakSelf onClickTitleView:nil];
            }];
        }
    }
}


#pragma mark - Action Methods

- (IBAction)onClickCart:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventDormBalanceCartButton parameter:nil];
    
    [self tapCart:nil];
}

- (IBAction)onClickCheckOut:(id)sender
{
    [HXSUsageManager trackEvent:kUsageEventCheckout parameter:@{@"business_type":@"夜猫店"}];
    
    HXSCheckoutViewController * checkout  = [[HXSCheckoutViewController alloc] initWithNibName:@"HXSCheckoutViewController" bundle:nil];
    [self.navigationController pushViewController:checkout animated:YES];
}

- (void)tapCart:(UITapGestureRecognizer *)tap
{
    if((self.cartView && self.cartView.isAnimating)
       || (0 >= [[[HXSDormCartManager sharedManager] getCartItemsOfCurrentSession] count])) {
        return;
    }
    
    if (!self.cartView || !self.cartView.superview) {
        
        [HXSUsageManager trackEvent:kUsageEventShoppingCartClick parameter:@{@"business_type":@"夜猫店"}];
        self.cartView = [HXSFloatingCartView viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.blurView.height)];

        self.cartView.cartViewDelegate = self;
        
        [self setupCartViewItems];
        
        [self.cartView show];
        
        [[HXSDormCartManager sharedManager] refreshCartInfo];
    } else {
        [self.cartView hide:YES];
    
    }
    
    [self cartUpdated:nil];
}

/**
 *  横、竖列表排列切换
 *
 *  @param sender
 */
- (IBAction)onClickChangeListTypeBtn:(id)sender
{
    
    
    [sender setUserInteractionEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
    
    NSNumber *dormTypeNum = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_DORM_LIST_TYPE];
    
    if (nil == dormTypeNum ||
        (kHXSDormListTypeHorizontal == [dormTypeNum integerValue])) {
        
        [HXSUsageManager trackEvent:kUsageEventDormChangeListType parameter:@{@"business_type":@"夜猫店",@"type":@"方格"}];
        
        [self transitionFromViewController:weakSelf.currentVC
                          toViewController:weakSelf.listVerticalVC
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [weakSelf.currentVC.view removeFromSuperview];
                                    
                                    [weakSelf.listContentView addSubview:weakSelf.listVerticalVC.view];
                                    
                                    [weakSelf.listVerticalVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                        make.edges.equalTo(weakSelf.listContentView);
                                    }];
                                } completion:^(BOOL finished) {
                                    [weakSelf.listVerticalVC didMoveToParentViewController:weakSelf];
                                    [weakSelf.currentVC willMoveToParentViewController:nil];
                                    
                                    weakSelf.currentVC = weakSelf.listVerticalVC;
                                    
                                    [sender setUserInteractionEnabled:YES];
                                    
                                    [weakSelf reloadDataShouldAnimation:NO];
                                }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSDormListTypeVertical]
                                                  forKey:USER_DEFAULT_DORM_LIST_TYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        [HXSUsageManager trackEvent:kUsageEventDormChangeListType parameter:@{@"business_type":@"夜猫店",@"type":@"列表"}];
        
        [self transitionFromViewController:self.currentVC
                          toViewController:self.listHorizontalVC
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [weakSelf.currentVC.view removeFromSuperview];
                                    
                                    [weakSelf.listContentView addSubview:weakSelf.listHorizontalVC.view];
                                    
                                    [weakSelf.listHorizontalVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                                        make.edges.equalTo(weakSelf.listContentView);
                                    }];
                                } completion:^(BOOL finished) {
                                    [weakSelf.listHorizontalVC didMoveToParentViewController:weakSelf];
                                    [weakSelf.currentVC willMoveToParentViewController:nil];
                                    
                                    weakSelf.currentVC = weakSelf.listHorizontalVC;
                                    
                                    [sender setUserInteractionEnabled:YES];
                                    
                                    [weakSelf reloadDataShouldAnimation:NO];
                                }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:kHXSDormListTypeHorizontal]
                                                  forKey:USER_DEFAULT_DORM_LIST_TYPE];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [self setupChangeTypeBtn];
    
}

- (void)onClickTitleView:(UIButton *)button
{
    [HXSUsageManager trackEvent:kUsageEventNavShopnameClikc parameter:@{@"business_type":@"夜猫店"}];
    
    if (self.hasDisplayShopInfoView) {
        [self.shopInfoVC dismissView];
    } else {
        
        [self.shopCategoryToolView dismissView];
        __weak typeof(self) weakSelf = self;
        
        self.shopInfoVC.shopEntity = self.shopEntity;
        self.shopInfoVC.dismissShopInfoView = ^(void) {
            [weakSelf.shopInfoVC.view removeFromSuperview];
            [weakSelf.shopInfoVC removeFromParentViewController];
            
            [weakSelf.locationButton setImage:[UIImage imageNamed:@"ic_downwardwhite"] forState:UIControlStateNormal];
            
            weakSelf.hasDisplayShopInfoView = NO;
        };
        [self addChildViewController:self.shopInfoVC];
        
        [self.view addSubview:self.shopInfoVC.view];
        
        [self.shopInfoVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self.shopInfoVC didMoveToParentViewController:self];
        
        self.hasDisplayShopInfoView = YES;
        
        [self.locationButton setImage:[UIImage imageNamed:@"ic_upwardwhite"] forState:UIControlStateNormal];
    }
}

- (IBAction)onClickOpenDormStroeBtn:(id)sender
{
    HXSLocationManager *locationMgr = [HXSLocationManager manager];
    NSString *baseURL = [[ApplicationSettings instance] registerStoreManagerBaseURL];
    NSString *url = [NSString stringWithFormat:@"%@?dormentry_id=%d", baseURL, [locationMgr.buildingEntry.dormentryIDNum intValue]];
    
    HXSWebViewController *webVc = [HXSWebViewController controllerFromXib];
    webVc.url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    RootViewController *tabRootCtrl = [AppDelegate sharedDelegate].rootViewController;
    UINavigationController *nav = tabRootCtrl.currentNavigationController;
    
    [nav pushViewController:webVc animated:YES];
}


#pragma mark - HXSFloatingCartViewDelegate

- (void)updateItem:(NSNumber *)itemIDNum quantity:(NSNumber *)quantityNum
{
    [HXSUsageManager trackEvent:kUsageEventCartChangeQuantity parameter:@{@"business_type":@"夜猫店"}];
    
    [[HXSDormCartManager sharedManager] updateItem:itemIDNum quantity:[quantityNum intValue]];
}

- (void)clearCart
{
    [HXSUsageManager trackEvent:kUsageEventCartClearCart parameter:@{@"business_type":@"夜猫店"}];
    
    [[HXSDormCartManager sharedManager] clearCart];
}

- (void)updateProduct:(NSString *)productIDStr
             quantity:(NSNumber *)quantityNum
{

}

#pragma mark -  HXSDormListHorizontalViewControllerDelegate, HXSDormListVerticalViewControllerDelegate

#pragma mark 下拉、隐藏效果

- (void)showView
{
    if (self.isAnimating || !self.isHidden) {

        return;
    }
    
    self.isHidden = NO;
    
    self.isAnimating = YES;
    
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.5];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakSelf.topViewTopOffset.constant = 0;
                         [weakSelf.view layoutIfNeeded];
                     }
                     completion:nil
     ];
}

- (void)hideView
{
    if (self.isAnimating) {
        return;
    }
    
    self.isHidden = YES;
    
    self.isAnimating = YES;
    
    [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.5];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:.0f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            weakSelf.topViewTopOffset.constant = kHeightScrollTabBar - weakSelf.noticeView.frame.size.height;
                            [weakSelf.view layoutIfNeeded];
                        }
                     completion:nil
     ];
}

- (void)endAnimation:(id)sender
{
    @synchronized(self){
        
        self.isAnimating = NO;
    }
}

- (void)reloadItemList
{
    [self fetchEntryInfo];
}


#pragma mark - Update SubChild Status

- (void)reloadDataShouldAnimation:(BOOL)animation
{
    if (self.currentVC == self.listHorizontalVC) {
        self.listHorizontalVC.shopEntity = self.shopEntity;
        self.listHorizontalVC.itemList = self.itemList;
        [self.listHorizontalVC reloadDataShouldAnimation:animation];
    } else {
        self.listVerticalVC.shopEntity = self.shopEntity;
        self.listVerticalVC.itemList = self.itemList;
        [self.listVerticalVC reloadDataShouldAnimation:animation];
    }
    
}

- (void)stopReloadData
{
    // Close the loading view at this view
    [HXSLoadingView closeInView:self.view];
    
    if (self.currentVC == self.listHorizontalVC) {
        [self.listHorizontalVC stopReloadData];
    } else {
        [self.listVerticalVC stopReloadData];
    }
    
}

- (void)scrollToAssignRowWhenClickIndex:(int)index
{
    if (self.currentVC == self.listHorizontalVC) {
        
        [self.listHorizontalVC scrollToAssignRowWhenClickIndex:index];
    } else {
        
        [self.listVerticalVC scrollToAssignRowWhenClickIndex:index];
    }
}


#pragma mark - Fetch Dorm Entry Methods

- (void)fetchEntryInfo
{
    if (self.categoryModel) {
        
        if (nil == self.shopEntity) {
            [self.dontOpenView setHidden:NO];
            [self.view bringSubviewToFront:self.dontOpenView];
            
        } else {
            [self.dontOpenView setHidden:YES];
            [self.view sendSubviewToBack:self.dontOpenView];
        }
        
        [self reload];
    }
}


#pragma mark - Private Methods

- (void)setupCartViewItems
{
    NSMutableArray *floatingItemsMArr = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (HXSDormCartItem *item in [[HXSDormCartManager sharedManager] getCartItemsOfCurrentSession]) {
        HXSFloatingCartEntity *entity = [[HXSFloatingCartEntity alloc] initWithCartItem:item];
        
        [floatingItemsMArr addObject:entity];
    }
    
    self.cartView.itemsArray = floatingItemsMArr;
}



#pragma mark - Setter Getter Methods

- (HXSShopInfoViewController *)shopInfoVC
{
    if (nil == _shopInfoVC) {
        _shopInfoVC = [HXSShopInfoViewController controllerFromXib];
    }
    
    return _shopInfoVC;
}

- (HXSShopViewModel *)shopModel
{
    if (nil == _shopModel) {
        _shopModel = [[HXSShopViewModel alloc] init];
    }
    
    return _shopModel;
}


@end
